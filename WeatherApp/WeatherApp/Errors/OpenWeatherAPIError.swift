//
//  NetworkError.swift
//  WeatherApp
//
//  Created by Ningyuan Gao on 11/20/22.
//

import Foundation

enum OpenWeatherAPIError: Error {
    case internetConnectionError
    case transportError
    case serverSideError(Int, String)
    case parseError
}
