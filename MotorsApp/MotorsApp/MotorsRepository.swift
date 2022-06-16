//
//  MotorsRepository.swift
//  MotorsApp
//
//  Created by Luke Smith on 16/06/2022.
//

import Foundation

protocol MotorsQuerying {
    func queryMotorsWith(make: String, model: String, year: String) async -> [MotorResult]
}

class MotorsRepository: MotorsQuerying {
    
    let baseURL = URL(string: "http://mcuapi.mocklab.io/")! // (i never normally force unwrap but make an exception for this case)
    lazy var apiClient = MobileAPIClient(baseURL: baseURL)
    
    func queryMotorsWith(make: String, model: String, year: String) async -> [MotorResult] {
        let request = MotorsRequest(make: make, model: model, year: year)
        let results: [MotorResult]? = await apiClient.send(request)
        return results ?? []
    }
}
