//
//  MockNetworkManager.swift
//  AdyenFSTests
//
//  Created by Anantha Krishnan K G on 01/09/19.
//  Copyright © 2019 Ananth. All rights reserved.
//

import Foundation
@testable import AdyenFS


class MockRESessionManager: NetWorkManager {
    
    var nextData:RawResponse?
    var nextImageData: RawImageResponse?
    var nextError: Error?
    private (set) var lastURL: URL?
    private (set) var lastMethod: String?
    
    func successHttpURLResponse(request: URLRequest) -> URLResponse {
        return HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: nil)!
    }
    
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        lastURL = request.url
        lastMethod = request.httpMethod
        let data = Data()
        completionHandler(data, successHttpURLResponse(request: request), nextError)
    }
    
    func startNetworkAction<T:Codable>(with url:URL?, forType type:NetworkActionType, withData dataObj:Data? = nil, withCompletionHandler completionHandler: @escaping networkFetchCompletionHandler<T>) {
        
        guard let urlValue = url else {
            completionHandler(nil,nil,nil,.invalidUrl)
            return
        }
        var urlRequest = URLRequest(url: urlValue)
        switch type {
        case .GET:
            urlRequest.httpMethod = "GET"
            break
        case .DELETE:
            urlRequest.httpMethod = "DELETE"
            break
        case .POST,.PUT:
            urlRequest.httpMethod = "POST"
            if let userData = dataObj {
                urlRequest.httpBody = userData
            }
            break
        }
        
        self.dataTask(with: urlRequest) { (data, response, error) in
            
            guard let _ = data , error == nil else {
                completionHandler(nil, nil,400, .jsonError)
                return
            }
            
            if T.self is RawImageResponse.Type {
                completionHandler(self.nextImageData as? T, response.debugDescription, 200, nil)
            } else {
                completionHandler(self.nextData as? T, response.debugDescription, 200, nil)
            }
            
        }
    }
    
    
}
