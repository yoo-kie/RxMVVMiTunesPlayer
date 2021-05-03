//
//  EndPoint.swift
//  RxMVVMiTunes
//
//  Created by 유연주 on 2021/05/03.
//

import Foundation

struct EndPoint {
    var baseUrl: String = "https://itunes.apple.com"
    var path: Path
    var parameters: [String: String]?
    var url: URL {
        var components = URLComponents(string: baseUrl)
        components?.path = path.rawValue
        if let params = parameters {
            components?.setQueryItems(with: params)
        }
        
        guard let finalUrl = components?.url else {
            preconditionFailure(
                "유효하지 않은 URL입니다."
            )
        }
        
        return finalUrl
    }

    static func fetchEndPoint(of path: Path, with term: String) -> EndPoint {
        var queryParams: [String: String] = [:]
        
        switch path {
        case .search:
            queryParams = [
                "entity": "song",
                "media": "music",
                "limit": "30",
                "lang": "ko_kr",
                "country": "KR",
                "term": term
            ]
        }
        
        return EndPoint(path: path, parameters: queryParams)
    }
}

enum Path: String {
    case search = "/search"
}
