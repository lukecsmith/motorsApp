//
//  APIRequesting.swift
//  MotorsApp
//
//  Created by Luke Smith on 17/06/2022.
//

import Foundation

public protocol APIRequesting: Encodable {
    associatedtype Response: Decodable

    var resourceName: String { get }
    var httpMethod: String? { get }
    var bodyData: Encodable? { get }
    var debugPrint: Bool { get }
}

extension APIRequesting {

    public var httpMethod: String? { return "GET" }
    public var bodyData: Encodable? { return nil }
}
