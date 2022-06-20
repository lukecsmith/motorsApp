//
//  MobileAPIClientTests.swift
//  MotorsAppTests
//
//  Created by Luke Smith on 18/06/2022.
//

import Combine
import XCTest
@testable import MotorsApp

class MobileAPIClientTests: XCTestCase {
    
    fileprivate var cancellables = Set<AnyCancellable>()
     
    func testClientWillDecodeJsonIntoSpecifiedObjects() {
        
        //create client to test
        let testClient = MobileAPIClient()
        //mock URLSession on client to return json loaded from bundle (rather than a real call)
        testClient.session = mockURLSessionReturning(jsonFilename: "nissan",
                                                     for: "https://mcuapi.mocklab.io/search?make=nissan&model=&year=")
        
        // MotorsRequest includes Response typealias, which defines the type to decode the json into, in this case SearchResults, which contain [Motor]s
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
        
        guard let objects = returnedObject?.searchResults else {
            XCTFail("Object still nil")
            return
        }
        
        //assert that 4 Motor objects were decoded from the call
        XCTAssertEqual(objects.count, 4)
    }
    
    func testClientWillReportStatusCodesCorrectlyAsErrors() {
        //create client to test
        let testClient = MobileAPIClient()
        //call set up to return a status code of 400 (Bad Request)
        testClient.session = mockURLSessionReturning(jsonFilename: "nissan",
                                                     for: "https://mcuapi.mocklab.io/search?make=nissan&model=&year=",
                                                     statusCodeToReturn: 400)
        
        let request = MotorsRequest(make: "nissan", model: "", year: "")
        
        let completedExpectation = expectation(description: #function)
        
        var returnedError: Error?
        
        testClient.send(request)
            .sink(receiveCompletion: { result in
                switch result {
                case .finished:
                    print("finished")
                case .failure(let error):
                    returnedError = error
                    completedExpectation.fulfill()
                }
            }, receiveValue: { _ in })
            .store(in: &cancellables)
        waitForExpectations(timeout: 1.0, handler: nil)
        
        guard let error = returnedError else {
            XCTFail("Error missing")
            return
        }
        
        //assert that the given error status code was correctly reported
        XCTAssertEqual(String(describing: error), "apiError(400)")
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
