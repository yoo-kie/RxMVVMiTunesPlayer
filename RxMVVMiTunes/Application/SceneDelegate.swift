//
//  SceneDelegate.swift
//  RxMVVMiTunes
//
//  Created by 유연주 on 2021/04/17.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var coordinator: AppCoordinator?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: scene)
        
        coordinator = AppCoordinator(
            parentCoordinator: nil,
            navigationController: nil
        )
        coordinator?.window = window
        coordinator?.start()
    }

}

