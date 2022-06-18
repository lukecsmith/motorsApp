//
//  MockAPIClient.swift
//  ModeTests
//
//  Created by Luke Smith on 09/12/2021.
//  Copyright © 2021 FiberMode Ltd. All rights reserved.
//

import Foundation
import Combine

enum MockError: Error {
    case notImplemented
}

class MockAPIClient: APIClient {
    var decoder: JSONDecoder = JSONDecoder()
    
    func endpoint<T>(for request: T) -> URL where T : APIRequesting {
        return URL(string: "")!
    }
    
    var mock: (() -> Result<Any, Error>)?
    
    init(mock: (() -> Result<Any, Error>)? = nil) {
        self.mock = mock
    }
    
    func send<Request, Response>(_ request: Request) -> AnyPublisher<Response, Error> {
        return Deferred {
            Future { promise in
                guard let result = self.mock?() else {
                    promise(.failure(MockError.notImplemented))
                    return
                }
                
                switch result {
                case .failure(let error):
                    promise(.failure(error))
                    return
                    
                case .success(let value):
                    guard let responseValue = value as? Response else {
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
