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
    @Published var results: [Motor] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    func queryMotors() {
        guard make.count > 0 || model.count > 0 || year.count > 0 else {
            errorText = "Please enter something for Make, Model or Year"
            return
        }
        results = []
        repository.queryMotorsWith(make: make, model: model, year: year)
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
                self.results = value.searchResults
            })
            .store(in: &cancellables)
    }
}
