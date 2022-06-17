//
//  MotorsRepository.swift
//  MotorsApp
//
//  Created by Luke Smith on 16/06/2022.
//

import Combine
import Foundation

protocol MotorsQuerying {
    func queryMotorsWith(make: String, model: String, year: String) -> AnyPublisher<[MotorResult], Error>
}

class MotorsRepository: MotorsQuerying {
    
    let baseURL = URL(string: "https://mcuapi.mocklab.io/")!
    lazy var apiClient = MobileAPIClient(baseURL: baseURL)
    var error: DataError?
    var returnedMotors: [MotorResult]?
    
    func queryMotorsWith(make: String, model: String, year: String) -> AnyPublisher<[MotorResult], Error> {
        let request = MotorsRequest(make: make, model: model, year: year)
        return apiClient.send(request)
    }
}
