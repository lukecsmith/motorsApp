//
//  MotorsRepositoryTests.swift
//  MotorsAppTests
//
//  Created by Luke Smith on 18/06/2022.
//

import Combine
import XCTest
@testable import MotorsApp

class MotorsRepositoryTests: XCTestCase {
    
    fileprivate var cancellables = Set<AnyCancellable>()
    
    func testMotorsQueryFinishesWithSuccessAndPublishesResults() {
        let mockResult: MotorSearchResults = MotorSearchResults(searchResults: [Motor(id: "0",
                                                                                  name: "zero",
                                                                                  title: "nissan",
                                                                                  make: "nissan",
                                                                                  model: "leaf",
                                                                                  year: "2010",
                                                                                  price: "£2143.21")])
        let mockClient = MockAPIClient(mockResult: { .success(mockResult) })
        let repo = MotorsRepository(apiClient: mockClient)
        let successResult = expectation(description: "call returns success")
        var results: [Motor]?
        repo.queryMotorsWith(make: "", model: "", year: "")
            .sink(receiveCompletion: { result in
                switch result {
                case .failure(_):
                    print("Failed")
                case .finished: ()
                    print("Finished")
                }
            }, receiveValue: { value in
                print("Received \(value)")
                if value == mockResult.searchResults {
                    results = value
                    successResult.fulfill()
                }
            })
            .store(in: &cancellables)
        waitForExpectations(timeout: 1, handler: nil)
        
        XCTAssertNotNil(results)
        XCTAssertEqual(results![0], mockResult.searchResults[0])
    }
    
    func testMotorsQueryFinishesWithFailure() {
        let mockClient = MockAPIClient(mockResult: { .failure(MockError.notImplemented) })
        let repo = MotorsRepository(apiClient: mockClient)
        let failResult = expectation(description: "call returns a failure")
        repo.queryMotorsWith(make: "", model: "", year: "")
            .sink(receiveCompletion: { result in
                switch result {
                case .failure(_):
                    failResult.fulfill()
                case .finished: ()
                    print("Finished")
                }
            }, receiveValue: { _ in })
            .store(in: &cancellables)
        waitForExpectations(timeout: 1, handler: nil)
    }
}
