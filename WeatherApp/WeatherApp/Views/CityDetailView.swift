//
//  CityCellView.swift
//  WeatherApp
//
//  Created by Ningyuan Gao on 11/20/22.
//

import Foundation
import SwiftUI

struct CityDetailView: View {
    
    @ObservedObject var viewModel: CityWeatherViewModel
    
    init(city: City) {
        self.viewModel = CityWeatherViewModel(city: city)
    }

    var body: some View {
        VStack {
            Text("\(viewModel.cityWeatherModel.currentWeather == nil ? "" : StringConvertor.temperatureFormat(rawTemp: viewModel.cityWeatherModel.currentWeather!.main.temp))")
                .bold().font(.system(size: 38))
            Text("\(viewModel.cityWeatherModel.city.name!)")
                .bold().font(.system(size: 40))
            
            Text("\(viewModel.cityWeatherModel.city.state ?? " ")  \(viewModel.cityWeatherModel.city.country ?? " ")")
                .bold().font(.system(size: 28))
            
            Spacer()
            
            VStack {
                HStack(spacing: 20.0) {
                    Text("Humidity: \(viewModel.cityWeatherModel.currentWeather!.main.humidity)")
                        .font(.system(size: 24))
                    Text("Pressure: \(viewModel.cityWeatherModel.currentWeather!.main.pressure)")
                        .font(.system(size: 24))
                }
                
                HStack(spacing: 20.0) {
                    Text("Max: \(viewModel.cityWeatherModel.currentWeather == nil ? "" : StringConvertor.temperatureFormat(rawTemp: viewModel.cityWeatherModel.currentWeather!.main.temp_max))")
                        .font(.system(size: 24))
                    Text("Min: \(viewModel.cityWeatherModel.currentWeather == nil ? "" : StringConvertor.temperatureFormat(rawTemp: viewModel.cityWeatherModel.currentWeather!.main.temp_min))")
                        .font(.system(size: 24))
                }
            }
            
            Spacer()
            
            Text("\(viewModel.cityWeatherModel.currentWeather!.weather[0].main.description)")
                .bold().font(.system(size: 30))
        }
        .frame(minHeight: 100.0)
        .alert(isPresented: $viewModel.showErrorAlert) {
            Alert(
                title: Text(viewModel.errorTitle),
                message: Text(viewModel.errorMessage)
            )
        }
    }
}
