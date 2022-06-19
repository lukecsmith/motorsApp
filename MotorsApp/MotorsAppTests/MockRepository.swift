//
//  MockRepository.swift
//  MotorsAppTests
//
//  Created by Luke Smith on 18/06/2022.
//

import Combine
import XCTest
@testable import MotorsApp

class MockMotorsRepository: MotorsQuerying {
    
    var mockResult: (() -> Result<Any, Error>)?
    
    init(mockResult: (() -> Result<Any, Error>)? = nil) {
        self.mockResult = mockResult
    }
    
    func queryMotorsWith(make: String, model: String, year: String) -> AnyPublisher<[Motor], Error> {
        return Deferred {
            Future { promise in
                guard let result = self.mockResult?() else {
                    promise(.failure(MockError.notImplemented))
                    return
                }
                
                switch result {
                case .failure(let error):
                    promise(.failure(error))
                    return
                    
                case .success(let value):
                    guard let responseValue = value as? [Motor] else {
                        promise(.failure(MockError.notImplemented))
                        return
                    }
                    
                    promise(.success(responseValue))
                }

            }
        }
        .eraseToAnyPublisher()
    }
}
