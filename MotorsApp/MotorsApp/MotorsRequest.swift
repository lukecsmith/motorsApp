//
//  MotorsRequest.swift
//  MotorsApp
//
//  Created by Luke Smith on 16/06/2022.
//

import Foundation

struct MotorsRequest: URLRequestConvertible, Codable {
    
    var make: String
    var model: String
    var year: String
    
    var urlRequest: URLRequest {
        URL(string: "/search?make=\(make)&model=\(model)&year=\(year)")!
            .urlRequest
    }
    
    
}
