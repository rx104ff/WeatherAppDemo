//
//  OpenWeatherApiClient.swift
//  WeatherApp
//
//  Created by Ningyuan Gao on 11/18/22.
//

import Foundation

let API_KEY =  "10e872f3e84de716b0bfcda54634073b";

func GEO_CODING_API(cityName:String, stateCode:String, countryCode:String) -> String {
    return "https://api.openweathermap.org/geo/1.0/direct?q=\(cityName),\(stateCode),\(countryCode)&limit=5&appid=\(API_KEY)"
}

func WEATHER_API(lat: Double, lon: Double) -> String {
    return "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(API_KEY)"
}

class OpenWeatherAPIClient {
    let urlSession: URLSession
    
    init(urlSession: URLSession = URLSession.shared) {
      self.urlSession = urlSession
    }

    func fetchGeoInfo(cityName: String, stateCode:String, countryCode:String, completion: @escaping (Result<[CityModel], OpenWeatherAPIError>) -> ()) {
        
        guard let url = URL(string: GEO_CODING_API(cityName: cityName, stateCode: stateCode, countryCode: countryCode)) else {
            fatalError()
        }
        urlSession.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            
            if error != nil {
                completion(Result.failure(OpenWeatherAPIError.transportError))
                return
            }
            
            let response = response as! HTTPURLResponse
            let status = response.statusCode
            guard (200...299).contains(status) else {
                let errorMessage = response.value(forHTTPHeaderField: "message")
                completion(.failure(OpenWeatherAPIError.serverSideError(status, errorMessage ?? "Weird status. Please try again later")))
                return
            }
            
            do {
                let retrivedCities = try JSONDecoder().decode([CityModel].self, from: data)
                completion(.success(retrivedCities))
            } catch let errore {
                print(errore)
                completion(.failure(OpenWeatherAPIError.parseError))
            }

        }.resume()
    }
    
    func fetchCurrentWeather(lat: Double, lon: Double, completion: @escaping (Result<CurrentWeatherModel, OpenWeatherAPIError>) -> ()) {

        guard let url = URL(string: WEATHER_API(lat: lat, lon: lon)) else {
            fatalError()
        }

        urlSession.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            
            if error != nil {
                completion(Result.failure(OpenWeatherAPIError.transportError))
                return
            }
            
            let response = response as! HTTPURLResponse
            let status = response.statusCode
            guard (200...299).contains(status) else {
                let errorMessage = response.value(forHTTPHeaderField: "message")
                completion(.failure(OpenWeatherAPIError.serverSideError(status, errorMessage ?? "Weird status. Please try again later")))
                return
            }
            
            do {
                let currentWeather = try JSONDecoder().decode(CurrentWeatherModel.self, from: data)
                completion(.success(currentWeather))
            } catch {
                completion(.failure(OpenWeatherAPIError.parseError))
            }

        }.resume()
    }
}
