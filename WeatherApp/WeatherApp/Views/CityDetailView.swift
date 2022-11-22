//
//  CityCellView.swift
//  WeatherApp
//
//  Created by Ningyuan Gao on 11/20/22.
//

import Foundation
import SwiftUI

struct CityDetailView: View {
    
    @ObservedObject var cityWeatherViewModel: CityWeatherViewModel

    var body: some View {
        VStack {
            Text("\(cityWeatherViewModel.cityWeatherModel.currentWeather == nil ? "" : StringConvertor.temperatureFormat(rawTemp: cityWeatherViewModel.cityWeatherModel.currentWeather!.main.temp))")
                .bold().font(.system(size: 38))
            Text("\(cityWeatherViewModel.cityWeatherModel.city.name!)")
                .bold().font(.system(size: 40))
            
            Text("\(cityWeatherViewModel.cityWeatherModel.city.state ?? " ")  \(cityWeatherViewModel.cityWeatherModel.city.country ?? " ")")
                .bold().font(.system(size: 28))
            
            Spacer()
            
            VStack {
                HStack(spacing: 20.0) {
                    Text("Humidity: \(cityWeatherViewModel.cityWeatherModel.currentWeather!.main.humidity)")
                        .font(.system(size: 24))
                    Text("Pressure: \(cityWeatherViewModel.cityWeatherModel.currentWeather!.main.pressure)")
                        .font(.system(size: 24))
                }
                
                HStack(spacing: 20.0) {
                    Text("Max: \(cityWeatherViewModel.cityWeatherModel.currentWeather == nil ? "" : StringConvertor.temperatureFormat(rawTemp: cityWeatherViewModel.cityWeatherModel.currentWeather!.main.temp_max))")
                        .font(.system(size: 24))
                    Text("Min: \(cityWeatherViewModel.cityWeatherModel.currentWeather == nil ? "" : StringConvertor.temperatureFormat(rawTemp: cityWeatherViewModel.cityWeatherModel.currentWeather!.main.temp_min))")
                        .font(.system(size: 24))
                }
            }
            
            Spacer()
            
            Text("\(cityWeatherViewModel.cityWeatherModel.currentWeather!.weather[0].main.description)")
                .bold().font(.system(size: 30))
        }
        .frame(minHeight: 100.0)
        .alert(isPresented: $cityWeatherViewModel.showErrorAlert) {
            Alert(
                title: Text(cityWeatherViewModel.errorTitle),
                message: Text(cityWeatherViewModel.errorMessage)
            )
        }
    }
}
