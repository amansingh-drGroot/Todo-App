//
//  WeatherModel.swift
//  ToDoApp
//
//  Created by Aman Pratap Singh on 08/09/25.
//

import Foundation

// MARK: - WeatherModel
struct ForecastModel: Codable {
    let latitude, longitude, generationtimeMS: Double?
    let utcOffsetSeconds: Int?
    let timezone, timezoneAbbreviation: String?
    let elevation: Int?
    let currentUnits: Units?
    let current: Current?
    let hourlyUnits: Units?
    let hourly: Hourly?

    enum CodingKeys: String, CodingKey {
        case latitude, longitude
        case generationtimeMS = "generationtime_ms"
        case utcOffsetSeconds = "utc_offset_seconds"
        case timezone
        case timezoneAbbreviation = "timezone_abbreviation"
        case elevation
        case currentUnits = "current_units"
        case current
        case hourlyUnits = "hourly_units"
        case hourly
    }
}

// MARK: - Current
struct Current: Codable {
    let time: String?
    let interval: Int?
    let temperature2M, windSpeed10M: Double?
    let relativeHumidity2M: Int?

    enum CodingKeys: String, CodingKey {
        case time, interval
        case temperature2M = "temperature_2m"
        case windSpeed10M = "wind_speed_10m"
        case relativeHumidity2M = "relative_humidity_2m"
    }
}

// MARK: - Units
struct Units: Codable {
    let time: String?
    let interval: String?
    let temperature2M, windSpeed10M, relativeHumidity2M: String?

    enum CodingKeys: String, CodingKey {
        case time, interval
        case temperature2M = "temperature_2m"
        case windSpeed10M = "wind_speed_10m"
        case relativeHumidity2M = "relative_humidity_2m"
    }
}

// MARK: - Hourly
struct Hourly: Codable {
    let time: [String]?
    let temperature2M: [Double]?
    let relativeHumidity2M: [Int]?
    let windSpeed10M: [Double]?

    enum CodingKeys: String, CodingKey {
        case time
        case temperature2M = "temperature_2m"
        case relativeHumidity2M = "relative_humidity_2m"
        case windSpeed10M = "wind_speed_10m"
    }
}
