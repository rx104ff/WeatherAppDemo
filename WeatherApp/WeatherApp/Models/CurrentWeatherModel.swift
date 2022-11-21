//
//  CurrentWeatherModel.swift
//  WeatherApp
//
//  Created by Ningyuan Gao on 11/19/22.
//

import Foundation

struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct Main: Codable {
    let temp: Double
    let feels_like: Double
    let temp_min: Double
    let temp_max: Double
    let pressure: Int
    let humidity: Int
}

struct CurrentWeatherModel: Codable {
    let weather: [Weather]
    let base: String
    let main: Main
    let name: String
}
