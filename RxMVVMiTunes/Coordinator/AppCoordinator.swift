//
//  AppCoordinator.swift
//  RxMVVMiTunes
//
//  Created by 유연주 on 2021/04/19.
//

import UIKit

protocol Coordinator {
    var parentCoordinator: Coordinator? { get set }
    var navigationController: UINavigationController? { get set }
    
    init(parentCoordinator: Coordinator?, navigationController: UINavigationController?)
    func start()
}

class AppCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var navigationController: UINavigationController?
    
    var window: UIWindow?
    
    required init(parentCoordinator: Coordinator?, navigationController: UINavigationController?) {
        self.parentCoordinator = parentCoordinator
        self.navigationController = navigationController
    }
    
    func start() {
        guard let vc = SearchViewController.instantiate(viewModel: SearchViewModel()) else { return }
        
        let navigationController = UINavigationController(rootViewController: vc)
    
        vc.coordinator = SearchCoordinator(
            parentCoordinator: self,
            navigationController: navigationController
        )
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}
