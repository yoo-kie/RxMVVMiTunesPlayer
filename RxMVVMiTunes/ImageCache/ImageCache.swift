//
//  ImageCacheManager.swift
//  RxMVVMiTunes
//
//  Created by 유연주 on 2021/04/20.
//

import UIKit
import RxSwift
import RxCocoa

final class ImageCache {
    
    static let instance = ImageCache()
    private init() {}
    
    var cache = NSCache<NSString, UIImage>()

}
