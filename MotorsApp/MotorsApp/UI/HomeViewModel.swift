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
    
    @Published var makeField: String = ""
    @Published var modelField: String = ""
    @Published var yearField: String = ""
    
    @Published var errorText: String = ""
    @Published var results: [Motor] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    func queryMotors() {
        guard makeField.count > 0 || modelField.count > 0 || yearField.count > 0 else {
            errorText = "Please enter something for Make, Model or Year"
            return
        }
        results = []
        repository.queryMotorsWith(make: makeField, model: modelField, year: yearField)
            .sink(receiveCompletion: { [weak self] result in
                switch result {
                case .finished:
                    if self?.results.count == 0 {
                        self?.errorText = "Your search returned 0 results"
                    }
                case .failure(let error):
                    self?.errorText = "Failed with error: \(error.localizedDescription)"
                }
            }, receiveValue: { value in
                self.results = value
            })
            .store(in: &cancellables)
    }
}
