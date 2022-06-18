//
//  APIClient.swift
//  MotorsApp
//
//  Created by Luke Smith on 16/06/2022.
//

// Data Layer, handles network calls

import Combine
import Foundation

public protocol APIClient {
    var decoder: JSONDecoder { get }
    func send<T: APIRequesting>(_ request: T) -> AnyPublisher<T.Response, Error>
    func endpoint<T: APIRequesting>(for request: T) -> URL
}

public protocol APIRequesting: Encodable {
    associatedtype Response: Decodable

    var resourceName: String { get }
    var httpMethod: String? { get }
    var bodyData: Encodable? { get }
    var debugPrint: Bool { get }
    var queryItems: [String: String]? { get }
}

extension APIRequesting {

    public var httpMethod: String? { return "GET" }
    public var bodyData: Encodable? { return nil }
}
