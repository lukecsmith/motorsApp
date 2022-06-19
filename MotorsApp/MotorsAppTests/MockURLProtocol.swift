//
//  MockURLProtocol.swift
//  MotorsAppTests
//
//  Created by Luke Smith on 19/06/2022.
//

import Foundation

class MockURLProtocol: URLProtocol {
    // Dictionary maps URLs to tuples of error, data, and response
    static var mockURLs = [URL?: (error: Error?, data: Data?, response: HTTPURLResponse?)]()

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        if let url = request.url {
            if let (error, data, response) = MockURLProtocol.mockURLs[url] {
                
                // Theres a mock response specified - return it
                if let responseStrong = response {
                    self.client?.urlProtocol(self, didReceive: responseStrong, cacheStoragePolicy: .notAllowed)
                }
                
                // Theres mocked data specified - return it
                if let dataStrong = data {
                    self.client?.urlProtocol(self, didLoad: dataStrong)
                }
                
                // Theres a mocked error - return it
                if let errorStrong = error {
                    self.client?.urlProtocol(self, didFailWithError: errorStrong)
                }
            }
        }

        // Done returning our mock response -
        self.client?.urlProtocolDidFinishLoading(self)
    }

    // required
    override func stopLoading() {}
}
