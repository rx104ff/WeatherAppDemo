//
//  CityWeatherModel.swift
//  WeatherApp
//
//  Created by Ningyuan Gao on 11/21/22.
//

import Foundation
import SwiftUI

class CityWeatherModel: ObservableObject, Hashable {
    static func == (lhs: CityWeatherModel, rhs: CityWeatherModel) -> Bool {
        lhs.city.id == rhs.city.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.city.id)
    }
    
    let city: City
    
    @Published var currentWeather: CurrentWeatherModel?
    
    init(city: City) {
        self.city = city
    }
}
