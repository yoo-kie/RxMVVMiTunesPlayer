//
//  NSObjectProtocol+extension.swift
//  RxMVVMiTunes
//
//  Created by 유연주 on 2021/05/01.
//

import Foundation

extension NSObjectProtocol {
    static var className: String {
        return String(describing: self)
    }
}
