//
//  StringConvertor.swift
//  WeatherApp
//
//  Created by Ningyuan Gao on 11/20/22.
//

import Foundation

struct StringConvertor {
    
    static func temperatureFormat(rawTemp: Double, unit: UnitTemperature = .celsius) -> String {
        let formatter = MeasurementFormatter()
        var measurement = Measurement(value: rawTemp, unit: UnitTemperature.kelvin)
        measurement.convert(to: unit)

        formatter.unitOptions = .providedUnit
        formatter.numberFormatter.numberStyle = .decimal
        formatter.numberFormatter.maximumFractionDigits = 0
        
        return formatter.string(from: measurement)
    }
}
