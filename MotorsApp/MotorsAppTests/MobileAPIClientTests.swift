//
//  MobileAPIClientTests.swift
//  MotorsAppTests
//
//  Created by Luke Smith on 18/06/2022.
//

import Combine
import XCTest
@testable import MotorsApp

//Things it will do:

/*
 - Given an APIRequesting object with typealias return types, will decode and return those
 - baseEndpoint works
 - given response is status code 200, will return data
 - given any other status code, will return apiError(statusCode)
 - given the wrong json, will return a decode error
 */

class MobileAPIClientTests: XCTestCase {
    
    fileprivate var cancellables = Set<AnyCancellable>()
     
    func testClientWillDecodeJsonIntoSpecifiedObjects() {
        
        //create client to test
        let testClient = MobileAPIClient()
        //mock URLSession on client to return json loaded from bundle (rather than a real call)
        testClient.session = mockURLSessionReturning(jsonFilename: "nissan", for: "https://mcuapi.mocklab.io/search?make=nissan&model=&year=")
        
        let request = MotorsRequest(make: "nissan", model: "", year: "")
        
        let completedExpectation = expectation(description: #function)
        
        var returnedObject: MotorSearchResults?
        
        testClient.send(request)
            .sink(receiveCompletion: { result in
                switch result {
                case .finished:
                    completedExpectation.fulfill()
                    print("finished")
                case .failure(let error):
                    print("Error: \(error)")
                }
            }, receiveValue: { value in
                returnedObject = value
            })
            .store(in: &cancellables)
        waitForExpectations(timeout: 1.0, handler: nil)
        
        XCTAssertNotNil(returnedObject)
    }
    
    func mockURLSessionReturning(jsonFilename: String,
                                 for urlPathQuerying: String,
                                 statusCodeToReturn: Int = 200) -> URLSession {
        // the data which will be returned when code makes the call to the responseURL:
        let data = loadStub(bundle: Bundle(for: type(of: self)), name: jsonFilename)
        // responseURL - will be called by combo of baseURL and endpoint on request
        let responseURL = URL(string: urlPathQuerying)
        
        // create the HTTPURLResponse that will come back:
        let response = HTTPURLResponse(url: responseURL!, statusCode: statusCodeToReturn, httpVersion: nil, headerFields: nil)
        // .. and add it to the response array on the mock
        MockURLProtocol.mockURLs = [responseURL: (nil, data, response)]
        
        // create a normal URLSession, but using this protocol instead
        let sessionConfiguration = URLSessionConfiguration.ephemeral
        sessionConfiguration.protocolClasses = [MockURLProtocol.self]
        let mockSession = URLSession(configuration: sessionConfiguration)
        sessionConfiguration.timeoutIntervalForRequest = TimeInterval(15)
        return mockSession
    }
    
    func loadStub(bundle: Bundle, name: String, fileExtension: String = "json") -> Data {
        
        guard let url = bundle.url(forResource: name, withExtension: fileExtension),
            let data = try? Data(contentsOf: url)
        else {
            fatalError("invalid stub")
        }
        return data
    }
}
