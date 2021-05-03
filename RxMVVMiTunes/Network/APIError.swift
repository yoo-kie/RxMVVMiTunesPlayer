//
//  APIError.swift
//  RxMVVMiTunes
//
//  Created by 유연주 on 2021/05/03.
//

import Foundation

enum APIError: Error {
    case ResponseError
    case StatusError
    case DecodingError
}

extension APIError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .ResponseError:
            return "응답이 없습니다."
        case .StatusError:
            return "서버 상태가 정상적이지 않습니다."
        case .DecodingError:
            return "디코딩에 실패하였습니다."
        }
    }
    
    var failureReason: String? {
        switch self {
        case .ResponseError:
            return "응답을 정상적으로 받지 못하였습니다."
        case .StatusError:
            return "StatusCode가 200이 아닙니다."
        case .DecodingError:
            return "ITunes result 규격에 맞지 않습니다."
        }
    }
    
    var helpAnchor: String? {
        switch self {
        case .ResponseError:
            return "Request를 확인해주세요."
        case .StatusError:
            return "서버 담당자에게 문의 바랍니다."
        case .DecodingError:
            return "API 명세서를 재확인해주세요."
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .ResponseError, .StatusError, .DecodingError:
            return "helpAnchor를 참고해주세요."
        }
    }
}
