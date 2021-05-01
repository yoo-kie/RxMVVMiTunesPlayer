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
    var searchViewModel: SearchViewModel!
    private var searchController: UISearchController?
       
    static func instantiate(viewModel: SearchViewModel) -> SearchViewController? {
        let storyboard = UIStoryboard.init(
            name: StoryBoard.Main.rawValue,
            bundle: .main
        )
        
        guard let viewController = storyboard.instantiateViewController(
                identifier: SearchViewController.className
            ) as? SearchViewController
        else { return nil }
        
        viewController.searchViewModel = viewModel
    
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = Title.search
        navigationController?.navigationBar.prefersLargeTitles = true
        
        configureSearchController()
        bind()
    }
    
    private func configureSearchController() {
        guard let vc = ResultViewController.instantiate(viewModel: searchViewModel)
        else { return }
        
        searchController = UISearchController(searchResultsController: vc)
        navigationItem.searchController = searchController
        searchController?.searchBar.placeholder = PlaceHolder.searchBar
        searchController?.searchBar.delegate = self
    }
    
    private func bind() {
        searchController?.searchBar.rx.text
            .orEmpty
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .bind(to: self.searchViewModel.input.term)
            .disposed(by: self.disposeBag)
    }
    
}

