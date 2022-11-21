//
//  CityModel.swift
//  WeatherApp
//
//  Created by Ningyuan Gao on 11/19/22.
//

import Foundation

struct CityModel: Codable, Hashable {
    
    let name: String
    let lat: Double
    let lon: Double
    let country: String
    let state: String
    
    init (name: String, lat: Double, lon: Double, country: String, state: String) {
        self.name = name
        self.lat = lat
        self.lon = lon
        self.country = country
        self.state = state
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if let name = try container.decodeIfPresent(String.self, forKey: .name) {
            self.name = name
        } else {
            throw InvalidCityError.invalidKey(forKey: "name")
        }
        
        if let lat = try container.decodeIfPresent(Double.self, forKey: .lat) {
            self.lat = lat
        } else {
            throw InvalidCityError.invalidKey(forKey: "lat")
        }
        
        if let lon = try container.decodeIfPresent(Double.self, forKey: .lon) {
            self.lon = lon
        } else {
            throw InvalidCityError.invalidKey(forKey: "lon")
        }
        
        if let country = try container.decodeIfPresent(String.self, forKey: .country) {
            self.country = country
        } else {
            throw InvalidCityError.invalidKey(forKey: "country")
        }
        
        if let state = try container.decodeIfPresent(String.self, forKey: .state) {
            self.state = state
        } else {
            self.state = ""
        }
    }
}
