//
//  Untitled.swift
//  ToDoApp
//
//  Created by Aman Pratap Singh on 08/09/25.
//

import Moya

class MoyaServiceProvider {
    static let weatherService = MoyaProvider<WeatherService>(
        session: DefaultAlamofireManager.sharedManager,
        plugins: MoyaHelper.shared.getPlugins()
    )
}
