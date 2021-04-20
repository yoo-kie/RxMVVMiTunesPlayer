//
//  ViewController.swift
//  RxMVVMiTunes
//
//  Created by 유연주 on 2021/04/17.
//

import UIKit

final class SearchViewController: BaseViewController {

    var coordinator: SearchCoordinator?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "검색"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        configureSearchController()
        
        let queryParams: [String: String] = [
            "entity": "musicTrack",
            "media": "music",
            "limit": "10",
            "country": "KR",
            "lang": "ko_kr",
            "term": "백예린"
        ]
        
        let endpoint = EndPoint.fetchEndPoint(of: .search, with: queryParams)
        NetworkManager.instance.request(endpoint: endpoint) { (result: Result<ITunes, APIError>) in
            switch result {
            case .success(let iTunes):
                print(iTunes)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func configureSearchController() {
        let storyboard = UIStoryboard.init(name: "Main", bundle: .main)
        
        guard let resultVC = storyboard.instantiateViewController(identifier: "ResultViewController") as? ResultViewController
        else { return }
        
        let searchController = UISearchController(searchResultsController: resultVC)
        navigationItem.searchController = searchController
        searchController.searchBar.placeholder = "아티스트, 노래, 가사 등"
    }
    
    static func instantiate() -> SearchViewController? {
        let storyboard = UIStoryboard.init(name: "Main", bundle: .main)
        
        guard let viewController = storyboard.instantiateInitialViewController() as? SearchViewController
        else { return nil }
    
        return viewController
    }
    
}

