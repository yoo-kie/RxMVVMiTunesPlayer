//
//  ImageError.swift
//  RxMVVMiTunes
//
//  Created by 유연주 on 2021/05/06.
//

import Foundation

enum ImageError: Error {
    case URLError
    case ResponseError
}

extension ImageError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .URLError:
            return "URL이 정상적이지 않습니다."
        case .ResponseError:
            return "Reponse를 받지 못했습니다."
        }
    }
    
    var failureReason: String? {
        switch self {
        case .URLError:
            return "잘못된 URL입니다."
        case .ResponseError:
            return "Reponse를 정상적으로 받지 못했습니다."
        }
    }
    
    var helpAnchor: String? {
        switch self {
        case .URLError:
            return "URL을 확인해주세요."
        case .ResponseError:
            return "Request 정보를 확인해주세요."
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .URLError, .ResponseError:
            return "helpAnchor를 참고해주세요."
        }
    }
}
