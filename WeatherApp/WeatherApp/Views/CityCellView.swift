//
//  CityCellView.swift
//  WeatherApp
//
//  Created by Ningyuan Gao on 11/20/22.
//

import Foundation
import SwiftUI

struct CityCellView: View {
    
    @ObservedObject var timeScheduler: TimeScheduler<CityWeatherModel>
    
    init(city: City, showErrorAlert: Binding<Bool>, errorTitle: Binding<String>, errorMessage: Binding<String>) {
        let cityWeatherModel = CityWeatherModel(city: city)

        self.timeScheduler = TimeScheduler<CityWeatherModel>(cityWeatherModel) { (data) in
            OpenWeatherAPIClient().fetchCurrentWeather(lat: city.lat, lon: city.lon) { (result) in
                switch result {
                case .success(let currentWeather):
                    DispatchQueue.main.async {
                        data!.currentWeather = currentWeather
                    }
                case .failure(let error):
                    switch error {
                    case .serverSideError(let statusCode, let message):
                        errorTitle.wrappedValue = "Status: \(statusCode)"
                        errorMessage.wrappedValue = message
                        showErrorAlert.wrappedValue = true
                    case .transportError:
                        errorTitle.wrappedValue = "Connection Issues"
                        errorMessage.wrappedValue = "Please Check the Internet Connection"
                        showErrorAlert.wrappedValue = true
                    case .parseError:
                        errorTitle.wrappedValue = "Error Parsing JSON"
                        errorMessage.wrappedValue = ""
                        showErrorAlert.wrappedValue = true
                    }
                }
            }
        }
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("\(timeScheduler.data!.city.name ?? "")")
                    .bold().font(.system(size: 22))
                
                Spacer()
                
                HStack {
                    Text("\(timeScheduler.data!.city.country ?? "")")
                        .font(.system(size: 18))
                    
                    Text("\(timeScheduler.data!.city.state ?? "")")
                        .font(.system(size: 18))
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text("\(timeScheduler.data!.currentWeather == nil ? "" : StringConvertor.temperatureFormat(rawTemp: timeScheduler.data!.currentWeather!.main.temp))")
                    .bold().font(.system(size: 38))
                
                Spacer()
                
                Text("\(timeScheduler.data!.currentWeather == nil ? "" : timeScheduler.data!.currentWeather!.weather[0].main)")
            }
        }
        .frame(minHeight: 100.0)
    }
}
