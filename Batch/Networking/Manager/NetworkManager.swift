//
//  NetworkManager.swift
//  Wandr
//
//  Created by Kevin Shiflett on 8/29/19.
//  Copyright © 2019 Wandr Inc. All rights reserved.
//

import Foundation
import FirebaseAuth

struct NetworkManager {
    
    enum Result {
        case success
        case failure(String)
    }
    
    enum NetworkResponse: String {
        case success
        case authenticationError = "You need to be authenticated first"
        case badRequest = "Bad Request"
        case outdated = "The request is outdated"
        case failed = "The request has failed"
        case noData = "No data was returned"
        case unableToDecode = "Could not decode data"
    }
    
    private let router = Router<BatchAPI>()
    
    func getCurrentTime(completion: @escaping (_ date: Date?, _ error: String?) -> ()) {
        router.request(.getCurrentTime) { (data, response, error) in
            
            if error != nil {
                completion(nil, "Please check your network connection")
            }
            
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let responseData = data else {
                        completion(nil, NetworkResponse.noData.rawValue)
                        return
                    }
                    if let timeString = String(data: responseData, encoding: String.Encoding.utf8) {
                        let epochTime = TimeInterval(timeString)! / 1000
                        let date = Date(timeIntervalSince1970: epochTime)
                        completion(date, nil)
                    } else {
                        completion(nil, NetworkResponse.unableToDecode.rawValue)
                    }
                        
                case .failure(let networkFailureError):
                    completion(nil, networkFailureError)
                }
            }
        }
    }
    
    func addUserToQueue(completion: @escaping (_ error: String?) -> ()) {
        
        let currentUser = Auth.auth().currentUser
        currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
            
            if error != nil {
                completion(NetworkResponse.failed.rawValue)
                return
            }
            
            router.request(.addUserToQueue, additionalHeaders: ["Authorization": "Bearer \(idToken!)"]) { (data, response, error) in
                
                if error != nil {
                    completion("Please check your network connection")
                    return
                }
                
                if let response = response as? HTTPURLResponse {
                    let result = self.handleNetworkResponse(response)
                    switch result {
                    case .success:
                        completion(nil)
                            
                    case .failure(let networkFailureError):
                        completion(networkFailureError)
                    }
                }
            }
        }
    }
    
    fileprivate func handleNetworkResponse(_ response: HTTPURLResponse) -> Result {
        switch response.statusCode {
        case 200...299: return .success
        case 401...500: return .failure(NetworkResponse.authenticationError.rawValue)
        case 501...599: return .failure(NetworkResponse.badRequest.rawValue)
        case 600: return .failure(NetworkResponse.outdated.rawValue)
        default: return .failure(NetworkResponse.failed.rawValue)
        }
    }
}
