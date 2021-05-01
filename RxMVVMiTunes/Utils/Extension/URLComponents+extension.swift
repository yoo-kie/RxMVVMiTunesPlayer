//
//  URLComponents.swift
//  RxMVVMiTunes
//
//  Created by 유연주 on 2021/04/20.
//

import Foundation

extension URLComponents {
    mutating func setQueryItems(with parameters: [String: String]) {
        self.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
    }
}
