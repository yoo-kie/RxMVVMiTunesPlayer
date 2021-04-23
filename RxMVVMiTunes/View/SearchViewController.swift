//
//  ViewController.swift
//  RxMVVMiTunes
//
//  Created by 유연주 on 2021/04/17.
//

import UIKit
import RxSwift
import RxCocoa

final class SearchViewController: BaseViewController, UISearchBarDelegate {

    private let disposeBag: DisposeBag = DisposeBag()
    var coordinator: SearchCoordinator?
    var viewModel: SearchViewModel!
    private var searchController: UISearchController?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "검색"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        configureSearchController()
        bind()
    }
    
    static func instantiate(viewModel: SearchViewModel) -> SearchViewController? {
        let storyboard = UIStoryboard.init(name: "Main", bundle: .main)
        
        guard let viewController = storyboard.instantiateInitialViewController() as? SearchViewController
        else { return nil }
        
        viewController.viewModel = viewModel
    
        return viewController
    }
    
    private func configureSearchController() {
        guard let vc = ResultViewController.instantiate(viewModel: viewModel) else { return }
        
        searchController = UISearchController(searchResultsController: vc)
        navigationItem.searchController = searchController
        searchController?.searchBar.placeholder = "아티스트, 노래, 가사 등"
        searchController?.searchBar.delegate = self
    }
    
    private func bind() {
        searchController?.searchBar.rx.searchButtonClicked
            .subscribe(
                onNext: { [weak self] in
                    guard let self = self else { return }
                    self.searchController?.searchBar.rx.text
                        .orEmpty
                        .distinctUntilChanged()
                        .bind(to: self.viewModel.input.term)
                        .disposed(by: self.disposeBag)
                }
            )
            .disposed(by: disposeBag)
    }
    
}

