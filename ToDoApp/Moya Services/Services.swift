//
//  Services.swift
//  ToDoApp
//
//  Created by Aman Pratap Singh on 08/09/25.
//

import Moya

enum WeatherService {
    case forecast(latitude: String, longitude: String, current: String, hourly: String)
}

extension WeatherService: TargetType {
    var baseURL: URL {
        switch self {
        case .forecast:
            guard let baseURL = URL(string: "https://api.open-meteo.com") else {
                return URL(string: "")!
            }
            return baseURL
        }
    }
    
    var path: String {
        switch self {
        case .forecast:
            return  "v1/forecast"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .forecast:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case let .forecast(latitude, longitude, current, hourly):
            return .requestParameters(
                parameters: [
                    "latitude": latitude,
                    "longitude": longitude,
                    "current": current,
                    "hourly": hourly
                ],
                encoding: URLEncoding.queryString
            )
        }
    }
    
    var headers: [String : String]? {
        return [:]
    }
}
