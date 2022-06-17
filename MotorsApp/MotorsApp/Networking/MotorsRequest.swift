//
//  MotorsRequest.swift
//  MotorsApp
//
//  Created by Luke Smith on 16/06/2022.
//

import Foundation

struct MotorsRequest: APIRequesting {
    
    var debugPrint = true
    
    typealias Response = [MotorResult]
    
    var queryItems: [String : String]?
    
    var resourceName: String {
        return "search"
    }
    
    init(make: String, model: String, year: String) {
        self.queryItems = ["make": make,
                           "model": model,
                           "year": year]
    }
}
