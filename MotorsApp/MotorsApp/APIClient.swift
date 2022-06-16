//
//  APIClient.swift
//  MotorsApp
//
//  Created by Luke Smith on 16/06/2022.
//

// Data Layer, handles network calls

import Combine
import Foundation

protocol APIClient {
    func send<Request, Response>(_ request: Request) async -> [Response]?
    where Request: URLRequestConvertible, Response: Decodable
}

public protocol URLRequestConvertible {
    var urlRequest: URLRequest { get }
}

extension URL: URLRequestConvertible {
    public var urlRequest: URLRequest {
        URLRequest(url: self)
    }
}

class MobileAPIClient: APIClient {
    
    var baseEndpointUrl: URL
    private var session: URLSession
    
    init(baseURL: URL, session: URLSession = URLSession.shared) {
        self.baseEndpointUrl = baseURL
        self.session = session
    }
    
    private static var defaultJSONDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
    
    func send<Request, Response>(_ request: Request) async -> [Response]? where Request: URLRequestConvertible, Response: Decodable {
        return []
    }
}
