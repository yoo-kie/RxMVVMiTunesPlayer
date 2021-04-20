//
//  NetworkManager.swift
//  RxMVVMiTunes
//
//  Created by 유연주 on 2021/04/20.
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

    static func fetchEndPoint(of path: Path, with params: [String: String]?) -> EndPoint {
        return EndPoint(path: path, parameters: params)
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
    
    func request<T: Decodable>(endpoint: EndPoint, completion: @escaping (Result<T, APIError>) -> ()) {
        let session = URLSession(configuration: .default)
        session.dataTask(with: endpoint.url) { data, response, error in
            guard error == nil else {
                completion(.failure(.ResponseError))
                return
            }
    
            guard let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.StatusError))
                return
            }
                
            do {
                let jsonData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(jsonData))
            } catch {
                completion(.failure(.DecodingError))
            }
        }.resume()
    }
    
}
