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
    
    @Published var errorText: String = ""
    @Published var results: [MotorResult] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    func queryMotors() {
        repository.queryMotorsWith(make: make, model: model, year: year)
            .sink(receiveCompletion: { result in
                switch result {
                case .finished:
                    break
                case .failure(let error):
                    self.errorText = "Failed with error: \(error.localizedDescription)"
                }
            }, receiveValue: { value in
                self.results = value
            })
            .store(in: &cancellables)
    }
}
