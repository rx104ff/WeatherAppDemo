//
//  CityCellView.swift
//  WeatherApp
//
//  Created by Ningyuan Gao on 11/20/22.
//

import Foundation
import SwiftUI

struct CityCellView: View {
    
    @ObservedObject var cityWeatherViewModel: CityWeatherViewModel
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("\(cityWeatherViewModel.cityWeatherModel.city.name!)")
                    .bold().font(.system(size: 22))
                
                Spacer()
                
                HStack {
                    Text("\(cityWeatherViewModel.cityWeatherModel.city.country!)")
                        .font(.system(size: 18))
                    
                    Text("\(cityWeatherViewModel.cityWeatherModel.city.state!)")
                        .font(.system(size: 18))
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text("\(cityWeatherViewModel.cityWeatherModel.currentWeather == nil ? "N/A" : StringConvertor.temperatureFormat(rawTemp: cityWeatherViewModel.cityWeatherModel.currentWeather!.main.temp))")
                    .bold().font(.system(size: 38))
                
                Spacer()
                
                Text("\(cityWeatherViewModel.cityWeatherModel.currentWeather == nil ? "N/A" : cityWeatherViewModel.cityWeatherModel.currentWeather!.weather[0].main)")
            }
        }
        .frame(minHeight: 100.0)
        .alert(isPresented: Binding<Bool>(
            get: { self.cityWeatherViewModel.showErrorAlert },
            set: { _ in self.cityWeatherViewModel.showErrorAlert = false }
        )) {
            Alert(
                title: Text(cityWeatherViewModel.errorTitle),
                message: Text(cityWeatherViewModel.errorMessage)
            )
        }
    }
}
