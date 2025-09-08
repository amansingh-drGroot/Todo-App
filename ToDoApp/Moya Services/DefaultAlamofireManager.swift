//
//  Default Alamofire Manager.swift
//  ToDoApp
//
//  Created by Aman Pratap Singh on 08/09/25.
//

import Alamofire

class DefaultAlamofireManager: Alamofire.Session {

    static let sharedManager: DefaultAlamofireManager = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 120 // as seconds, you can set your request timeout
        configuration.timeoutIntervalForResource = 120 // as seconds, you can set your resource timeout
        configuration.requestCachePolicy = .useProtocolCachePolicy
        return DefaultAlamofireManager(configuration: configuration)
    }()
}
