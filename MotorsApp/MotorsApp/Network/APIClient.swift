//
//  APIClient.swift
//  MotorsApp
//
//  Created by Luke Smith on 16/06/2022.
//

// Data Layer, handles network calls

import Combine
import Foundation

public protocol APIClient {
    var decoder: JSONDecoder { get }
    func send<T: APIRequesting>(_ request: T) -> AnyPublisher<T.Response, Error>
    func endpoint<T: APIRequesting>(for request: T) -> URL
}

class MobileAPIClient: APIClient {
    
    var baseEndpointUrl: URL = URL(string: "https://mcuapi.mocklab.io/")!
    private var session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    lazy public var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
    
    public func send<T: APIRequesting>(_ request: T) -> AnyPublisher<T.Response, Error> {
        let endpoint = self.endpoint(for: request)
        guard var components = URLComponents(string: endpoint.absoluteString) else {
            fatalError("unable to build url")
        }
        if let queryItems = request.queryItems {
            components.queryItems = queryItems.map { (key, value) in
                URLQueryItem(name: key, value: value)
            }
        }
        var apiRequest = URLRequest(url: components.url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 20)
        apiRequest.httpMethod = request.httpMethod
        
        if request.debugPrint {
            print("Calling : \(apiRequest.url?.absoluteString ?? "")")
        }
        
        if let bodyData = request.bodyData {
            apiRequest.httpBody = bodyData.toJSONData()
            if request.debugPrint {
                print("Sending json : \(bodyData.printableJSON)")
            }
        }
        
        apiRequest.allHTTPHeaderFields = ["accept": "application/json", "Content-Type": "application/json"]
        
        return self.session.dataTaskPublisher(for: apiRequest)
            .timeout(20, scheduler: DispatchQueue.global())
            .tryMap { output in
                if request.debugPrint, let json = NSString(data: output.data, encoding: String.Encoding.utf8.rawValue) {
                    print("Received json : \(json)")
                }
                if let response = output.response as? HTTPURLResponse {
                    if response.statusCode == 200 {
                        return output.data
                    }
                    throw DataError.apiError(response.statusCode)
                }
                throw DataError.networkingError
            }
            .decode(type: T.Response.self, decoder: self.decoder)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    public func endpoint<T: APIRequesting>(for request: T) -> URL {
        let urlString = "\(baseEndpointUrl)\(request.resourceName)"
        guard let url = URL(string: urlString) else {
            fatalError("Bad resourceName: \(request.resourceName)")
        }
        return url
    }
}