//
//  NetworkManager.swift
//  AdyenFS
//
//  Created by Anantha Krishnan K G on 01/09/19.
//  Copyright © 2019 Ananth. All rights reserved.
//

import Foundation
import UIKit

typealias networkFetchCompletionHandler<T> = (_ dataObject:T?, _ response:String?,_ statusCode:Int?, _ error:AFSError?) -> ()

// network protocol - Handles the action
protocol NetWorkManager {
    func startNetworkAction<T:Codable>(with url:URL?, forType type:NetworkActionType, withData dataObj:Data?, withCompletionHandler completionHandler: @escaping networkFetchCompletionHandler<T>)
}

// Network request types
enum NetworkActionType {
    case POST
    case PUT
    case DELETE
    case GET
}

// Custom decoder
func AFSJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}


// Class to handle the network calls
class AFSSessionmanager: NetWorkManager {
    
    // MARK: Variables
    static let shared = AFSSessionmanager()
    static let afsCache = NSCache<AnyObject, AnyObject>()
    
    lazy var sharedSession:URLSession = {
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = ["Content-Type":"application/json"]
        return URLSession(configuration: config, delegate: nil, delegateQueue: nil)
    }()
    
    // MARK: Methods
    
    // Data task methods
    fileprivate func dataTask(with urlRequest:URLRequest, with completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void){
        
        let task = sharedSession.dataTask(with: urlRequest) { (data, response, error) in
            completionHandler(data, response, error)
        }
        task.resume()
    }
    
    /**
     A generic method to handle all the network calls
     - parameter url:  Url for the request
     - parameter forType:  Request type
     - parameter withData:  Data object for the POST and PUT calls
     - parameter withCompletionHandler:  A completion handler to handle the response
     */
    func startNetworkAction<T>(with url: URL?, forType type: NetworkActionType, withData dataObj: Data?, withCompletionHandler completionHandler: @escaping (T?, String?, Int?, AFSError?) -> ()) where T : Codable {
        
        if AFSSessionmanager.isCacheType(object: T.self) {
            if let imageUrlCache = AFSSessionmanager.afsCache.object(forKey: url as AnyObject) as? T {
                completionHandler(imageUrlCache,nil,200,nil)
                return
            }
        }
        guard let urlValue = url else {
            completionHandler(nil,nil,500,.invalidUrl)
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
            
            guard let data = data , error == nil else {
                completionHandler(nil, nil,400, .noData)
                return
            }
            let statusCode = (response as! HTTPURLResponse).statusCode
            
            do {
                switch type {
                case .GET,.PUT,.POST:
                    let responseModel = try AFSJSONDecoder().decode(T.self, from: data)
                    completionHandler(responseModel, response.debugDescription, statusCode, nil)
                    AFSSessionmanager.storeInCache(url: urlValue, object: responseModel)
                    break
                case .DELETE:
                    switch statusCode {
                    case 200...299 :
                        completionHandler(nil,response.debugDescription,statusCode,nil)
                        break
                    default:
                        completionHandler(nil,response.debugDescription,statusCode,.invalidResponse)
                        break
                    }
                    
                    break
                }
                
            } catch let error as NSError {
                print(error.debugDescription)
                completionHandler(nil,nil, 500,.jsonError)
            }
        }
    }
    
    /**
     Get image from the url
     - parameter fromURL:  Url for the request
     - parameter withCompletionHandler:  A completion handler to handle the response
     */
    static func image(fromURL url:URL,completionHandler:@escaping ((_ image:UIImage?, _ succes:Bool?, _ error:Error?)->Void))  {

        if let imageFromCache = afsCache.object(forKey: url as AnyObject) as? UIImage {
            completionHandler(imageFromCache,true,nil)
            return
        }
        
        URLSession(configuration: .default)
            .dataTask(with: url) { (data, response, error) in
                if let error = error {
                    completionHandler(nil,false,error)
                    return
                }
                if let response = response as? HTTPURLResponse {
                    if response.statusCode != 200 {
                        completionHandler(nil,false,
                                          RuntimeError("bad response \(response.statusCode) - \(response.description)"))
                        return
                    }
                    if let data = data {
                        if let image = UIImage(data: data) {
                            completionHandler(image,true,error)
                            storeInCache(url: url, object: image)
                            return
                        }
                        if response.mimeType?.contains("text") ?? false ||
                            response.mimeType?.contains("json") ?? false {
                            completionHandler(nil,false,
                                              RuntimeError("unable to convert data " +
                                                (String(data: data, encoding: .utf8) ?? "\(data)") +
                                                " to image"))
                            return
                        }
                        completionHandler(nil,false,
                                          RuntimeError("unable to convert data \(data) to image"))
                        return
                    }
                    completionHandler(nil,false,
                                      RuntimeError("unable to retrieve response data"))
                    return
                }
                completionHandler(nil,false,
                                  RuntimeError("unknown response type"))
            }.resume()
    }
    
    
    fileprivate static func isCacheType<T>(object: T) -> Bool {
        if T.self is RawImageResponse.Type {
            return true
        }
        return false
    }
    fileprivate static func storeInCache<T>(url: URL, object: T) {
        if T.self is RawImageResponse.Type {
            AFSSessionmanager.afsCache.setObject(object as AnyObject, forKey: url as AnyObject)
        }
    }
}
