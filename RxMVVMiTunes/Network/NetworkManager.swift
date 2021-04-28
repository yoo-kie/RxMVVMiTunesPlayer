//
//  NetworkManager.swift
//  RxMVVMiTunes
//
//  Created by 유연주 on 2021/04/20.
//

import Foundation
import RxSwift

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

enum APIError: Error {
    case ResponseError
    case StatusError
    case DecodingError
}

final class NetworkManager {
    
    static let instance = NetworkManager()
    private init() {}
    
    func request<T: Decodable>(endpoint: EndPoint) -> Single<Result<T, APIError>> {
        
        return Single.create { observer in
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: endpoint.url) { data, response, error in
                guard error == nil else {
                    observer(.success(.failure(.ResponseError)))
                    return
                }
        
                guard let data = data, let response = response as? HTTPURLResponse,
                      response.statusCode == 200
                else {
                    observer(.success(.failure(.StatusError)))
                    return
                }
                    
                do {
                    let jsonData = try JSONDecoder().decode(T.self, from: data)
                    observer(.success(.success(jsonData)))
                } catch {
                    observer(.success(.failure(.DecodingError)))
                }
            }
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
        
    }
    
}
