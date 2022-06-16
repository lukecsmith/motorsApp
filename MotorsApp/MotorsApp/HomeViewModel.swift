//
//  HomeViewModel.swift
//  MotorsApp
//
//  Created by Luke Smith on 16/06/2022.
//

import Combine
import Foundation

class HomeViewModel: ObservableObject {
    
    init(repository: MotorsQuerying) {
        self.repository = repository
    }
    
    var repository: MotorsQuerying
    
    @Published var make: String = ""
    @Published var model: String = ""
    @Published var year: String = ""
    
    @Published var results: [MotorResult] = []
    
    func queryMotors() async {
        self.results = await repository.queryMotorsWith(make: make, model: model, year: year)
    }
}
