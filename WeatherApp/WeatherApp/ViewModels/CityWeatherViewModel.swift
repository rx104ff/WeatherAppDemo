//
//  CityWeatherViewModel.swift
//  WeatherApp
//
//  Created by Ningyuan Gao on 11/21/22.
//

import Foundation
import SwiftUI

class CityWeatherViewModel: ObservableObject {
    @Published var cityWeatherModel: CityWeatherModel
    @Published var errorTitle: String = ""
    @Published var errorMessage: String = ""
    @Published var showErrorAlert: Bool = false
    @Published var now: Double = Date().timeIntervalSince1970
    
    var timer: Timer?
    init(city: City) {
        self.cityWeatherModel = CityWeatherModel(city: city)
        
        self.refresh()
        
        timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true, block: { _ in
            self.refresh()
        })
    }
    deinit {
        timer?.invalidate()
    }
    
    func refresh() {
        OpenWeatherAPIClient().fetchCurrentWeather(lat: cityWeatherModel.city.lat, lon: cityWeatherModel.city.lon) { (result) in
            switch result {
            case .success(let currentWeather):
                DispatchQueue.main.async {
                    self.cityWeatherModel.currentWeather = currentWeather
                    self.now = Date().timeIntervalSince1970
                }
            case .failure(let error):
                switch error {
                case .serverSideError(let statusCode, let message):
                    DispatchQueue.main.async {
                        self.errorTitle = "Status: \(statusCode)"
                        self.errorMessage = message
                        self.showErrorAlert = true
                    }
                case .transportError:
                    DispatchQueue.main.async {
                        self.errorTitle = "Connection Issues"
                        self.errorMessage = "Please Check the Internet Connection"
                        self.showErrorAlert = true
                    }
                case .parseError:
                    DispatchQueue.main.async {
                        self.errorTitle = "Error Parsing JSON"
                        self.errorMessage = ""
                        self.showErrorAlert = true
                    }
                case .internetConnectionError:
                    DispatchQueue.main.async {
                        self.errorTitle = "No Internet"
                        self.errorMessage = "Please connection to the Internet while using the APP"
                        self.showErrorAlert = true
                    }
                }
            }
        }
    }
}
