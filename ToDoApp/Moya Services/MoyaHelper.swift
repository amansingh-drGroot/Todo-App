//
//  MoyaHelper.swift
//  ToDoApp
//
//  Created by Aman Pratap Singh on 08/09/25.
//

import Moya

class MoyaHelper {
    static let shared = MoyaHelper()

    private init() {}

    func getPlugins() -> [PluginType] {
        var plugins: [PluginType] = []
        let config = NetworkLoggerPlugin.Configuration(
            formatter: .init(responseData: jsonResponseDataFormatter),
            logOptions: [.formatRequestAscURL, .verbose]
        )
        plugins.append(NetworkLoggerPlugin(configuration: config))
        return plugins
    }

    private func jsonResponseDataFormatter(_ data: Data) -> String {
        do {
            let dataAsJSON = try JSONSerialization.jsonObject(with: data)
            let prettyData = try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
            return String(data: prettyData, encoding: .utf8) ?? String(data: data, encoding: .utf8) ?? ""
        } catch {
            return String(data: data, encoding: .utf8) ?? ""
        }
    }
}
