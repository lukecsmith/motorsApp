//
//  DataError.swift
//
//
//  Created by Luke Smith 21/09/2020
//  Copyright © 2020 Luke Smith. All rights reserved.
//

import Foundation

enum DataError: Error {
    case apiError(_ code: Int)
    case jsonDecoderError
    case networkingError
    case timedOut
}

extension DataError: LocalizedError {
    public var localizedDescription: String {
        switch self  {
        case .apiError(let code):
            return "API Error Code \(code)"
        case .jsonDecoderError:
            return "Error decoding json"
        case .networkingError:
            return "Network Connection Error"
        case .timedOut:
            return "Timed Out"
        }
    }
    
    public var alertTitle: String {
        switch self {
        case .networkingError:
            return "Network Error"
        case .timedOut:
            return "Slow Connection"
        default:
            return "Data Error"
        }
    }
    
    public var alertMessage: String {
        switch self {
        case .networkingError:
            return "There was a problem with your internet connection"
        case .timedOut:
            return "The network request timed out before finishing.  Please check you have a good internet connection."
        default:
            return "There was a problem executing the request"
        }
    }
}

