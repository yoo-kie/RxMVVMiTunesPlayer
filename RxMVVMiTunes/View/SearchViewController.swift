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

    let disposeBag: DisposeBag = DisposeBag()
    var coordinator: SearchCoordinator?
    var viewModel: SearchViewModel = SearchViewModel()
    private var searchController: UISearchController?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "검색"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        configureSearchController()
        bind()
    }
    
    private func configureSearchController() {
        let storyboard = UIStoryboard.init(name: "Main", bundle: .main)
        
        guard let resultVC = storyboard.instantiateViewController(identifier: "ResultViewController") as? ResultViewController
        else { return }
        
        resultVC.viewModel = viewModel
        searchController = UISearchController(searchResultsController: resultVC)
        navigationItem.searchController = searchController
        searchController?.searchBar.placeholder = "아티스트, 노래, 가사 등"
        searchController?.searchBar.delegate = self
    }
    
    static func instantiate() -> SearchViewController? {
        let storyboard = UIStoryboard.init(name: "Main", bundle: .main)
        
        guard let viewController = storyboard.instantiateInitialViewController() as? SearchViewController
        else { return nil }
    
        return viewController
    }
    
    func bind() {
        searchController?.searchBar.rx.searchButtonClicked
            .subscribe(
                onNext: { [weak self] in
                    guard let self = self else { return }
                    self.searchController?.searchBar.rx.text
                        .bind(to: self.viewModel.input.term)
                        .disposed(by: self.disposeBag)
                }
            )
            .disposed(by: disposeBag)
    }
    
}

