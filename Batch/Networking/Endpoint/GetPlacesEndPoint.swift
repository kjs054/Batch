//
//  GooglePlacesEndPoint.swift
//  Wandr
//
//  Created by Kevin Shiflett on 8/29/19.
//  Copyright © 2019 Wandr Inc. All rights reserved.
//

import Foundation
import FirebaseAuth

enum NetworkEnvironment {
    case qa
    case production
    case staging
}

public enum BatchAPI {
    case getCurrentTime
    case addUserToQueue
}

extension BatchAPI: EndPointType {
    
    var baseURL: URL {
        guard let url = URL(string: "https://us-central1-batch-24ec0.cloudfunctions.net/") else { fatalError("baseURL could not be configured.")}
        return url
    }
    
    var path: String {
        switch self {
            case .getCurrentTime: return "getCurrentTime"
            case .addUserToQueue: return "addUserToQueue"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
            case .getCurrentTime: return .get
            case .addUserToQueue: return .post
        }
    }
    
    var task: HTTPTask {
        switch self {
            case .getCurrentTime: return .request
            case .addUserToQueue: return .request
        }
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
}
