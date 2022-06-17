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
    
    var make: String
    var model: String
    var year: String
    
    var resourceName: String {
        return "search?make=\(make)&model=\(model)&year=\(year)"
    }
}
