//
//  DetailViewController.swift
//  RxMVVMiTunes
//
//  Created by 유연주 on 2021/04/20.
//

import UIKit

final class DetailViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    static func instantiate() -> DetailViewController? {
        let storyboard = UIStoryboard.init(name: "Main", bundle: .main)
        
        guard let viewController = storyboard.instantiateViewController(identifier: "DetailViewController") as? DetailViewController
        else { return nil }
    
        return viewController
    }
    
}
