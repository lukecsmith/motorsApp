//
//  MotorResult.swift
//  MotorsApp
//
//  Created by Luke Smith on 16/06/2022.
//

import Foundation

struct MotorSearchResults: Decodable {
    var searchResults: [Motor]
}

struct Motor: Decodable, Hashable {
    var id: String
    var name: String
    var title: String
    var make: String
    var model: String
    var year: String
    var price: String
}
