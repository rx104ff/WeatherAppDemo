//
//  InvalidCityError.swift
//  WeatherApp
//
//  Created by Ningyuan Gao on 11/21/22.
//

import Foundation

enum InvalidCityError: Error {
    case invalidKey(forKey: String)
}
