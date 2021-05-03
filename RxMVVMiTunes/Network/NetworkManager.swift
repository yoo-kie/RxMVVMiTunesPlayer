//
//  NetworkManager.swift
//  RxMVVMiTunes
//
//  Created by 유연주 on 2021/04/20.
//

import Foundation
import RxSwift

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
