//
//  UIImageView+extension.swift
//  RxMVVMiTunes
//
//  Created by 유연주 on 2021/05/07.
//

import UIKit

final class ImageView: UIImageView {
    
    var loader: ImageLoader = ImageLoader()
    
    func setImage(with url: String) {
        loader.fetchImage(with: url) { result in
            switch result {
            case .success(let image):
                self.image = image
            case .failure(let error):
                ErrorUtil.instance.logError(error: error)
            }
        }
    }
    
}
