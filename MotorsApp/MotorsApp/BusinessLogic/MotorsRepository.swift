//
//  MotorsRepository.swift
//  MotorsApp
//
//  Created by Luke Smith on 16/06/2022.
//

import Combine
import Foundation

protocol MotorsQuerying {
    func queryMotorsWith(make: String, model: String, year: String) -> AnyPublisher<MotorSearchResults, Error>
}

class MotorsRepository: MotorsQuerying {
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    var apiClient: APIClient
    
    func queryMotorsWith(make: String, model: String, year: String) -> AnyPublisher<MotorSearchResults, Error> {
        let request = MotorsRequest(make: make, model: model, year: year)
        return apiClient.send(request)
    }
}
