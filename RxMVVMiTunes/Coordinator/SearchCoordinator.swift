//
//  SearchCoordinator.swift
//  RxMVVMiTunes
//
//  Created by 유연주 on 2021/04/20.
//

import UIKit

class SearchCoordinator: Coordinator {
    
    var parentCoordinator: Coordinator?
    var navigationController: UINavigationController?
    
    required init(
        parentCoordinator: Coordinator?,
        navigationController: UINavigationController?
    ) {
        self.parentCoordinator = parentCoordinator
        self.navigationController = navigationController
    }
    
    func start() {
        // no-child
    }
    
}
