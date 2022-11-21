//
//  OpenWeatherAPIClientTest.swift
//  WeatherAppTests
//
//  Created by Ningyuan Gao on 11/20/22.
//

import XCTest
@testable import WeatherApp

class OpenWeatherAPIClientTest: XCTestCase {
    var openWeatherAPIClient: OpenWeatherAPIClient!
    var expectation: XCTestExpectation!
    
    override func setUpWithError() throws {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession.init(configuration: configuration)
        
        openWeatherAPIClient = OpenWeatherAPIClient(urlSession: urlSession)
        
    }
    
    override func tearDownWithError() throws {
    }
    
    func testGetGeoInfoSuccessful() throws {
        
        let cityModel = CityModel(name: "Toronto", lat: 43.6534817, lon: -79.3839347, country: "CA", state: "Ontario")
        
        let data = try JSONEncoder().encode([cityModel])
        
        MockURLProtocol.requestHandler = { request in
            return (HTTPURLResponse(), data)
        }
        
        let expectation = XCTestExpectation(description: "response")
        
        openWeatherAPIClient.fetchGeoInfo(cityName: cityModel.name, stateCode: cityModel.state, countryCode: cityModel.country) { (result) in
            switch result {
            case .success(let city):
                
                XCTAssertEqual(city[0].name, cityModel.name, "Incorrect name.")
                XCTAssertEqual(city[0].state,  cityModel.state, "Incorrect state.")
                XCTAssertEqual(city[0].country, cityModel.country, "Incorrect country.")
                XCTAssertEqual(city[0].lat, cityModel.lat, "Incorrect lat.")
                XCTAssertEqual(city[0].lon, cityModel.lon, "Incorrect lon.")
            case .failure(let error):
                XCTFail("Error was not expected: \(error)")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testGetGeoInfoParseError() throws {
        
        let cityModel = CityModel(name: "Toronto", lat: 43.6534817, lon: -79.3839347, country: "CA", state: "Ontario")
        
        let data = try JSONEncoder().encode(cityModel)
        
        MockURLProtocol.requestHandler = { request in
            return (HTTPURLResponse(), data)
        }
        
        let expectation = XCTestExpectation(description: "response")
        
        openWeatherAPIClient.fetchGeoInfo(cityName: cityModel.name, stateCode: cityModel.state, countryCode: cityModel.country) { (result) in
            switch result {
            case .success(_):
                XCTFail("Success was not expected")
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, OpenWeatherAPIError.parseError.localizedDescription, "Incorrect error.")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testGetGeoInfoServerSideError() throws {
        
        let cityModel = CityModel(name: "Toronto", lat: 43.6534817, lon: -79.3839347, country: "CA", state: "Ontario")
        
        let data = try JSONEncoder().encode(cityModel)
        
        let response = HTTPURLResponse(url: URL(string: GEO_CODING_API(cityName: cityModel.name, stateCode: "", countryCode: ""))!, statusCode: 404, httpVersion: nil, headerFields: nil)!
        
        MockURLProtocol.requestHandler = { request in
            return (response, data)
        }
        
        let expectation = XCTestExpectation(description: "response")
        
        openWeatherAPIClient.fetchGeoInfo(cityName: cityModel.name, stateCode: cityModel.state, countryCode: cityModel.country) { (result) in
            switch result {
            case .success(_):
                XCTFail("Success was not expected")
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, OpenWeatherAPIError.serverSideError(404, "").localizedDescription, "Incorrect error.")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testGetWeatherSuccessful() throws {
        
        let cityModel = CityModel(name: "Toronto", lat: 43.6534817, lon: -79.3839347, country: "CA", state: "Ontario")
        
        let currentWeatherModel = CurrentWeatherModel(weather: [Weather(id: 0, main: "clouds", description: "", icon: "")], base: "Station", main: Main(temp: 290.0, feels_like: 290.0, temp_min: 280.0, temp_max: 300.0, pressure: 100000, humidity: 50), name: "Toronto")
        
        let data = try JSONEncoder().encode(currentWeatherModel)
        
        MockURLProtocol.requestHandler = { request in
            return (HTTPURLResponse(), data)
        }
        
        let expectation = XCTestExpectation(description: "response")
        
        openWeatherAPIClient.fetchCurrentWeather(lat: cityModel.lat, lon: cityModel.lon) { (result) in
            switch result {
            case .success(let currentWeather):
                
                XCTAssertEqual(currentWeather.name, currentWeatherModel.name, "Incorrect name.")
                XCTAssertEqual(currentWeather.base,  currentWeatherModel.base, "Incorrect base.")
                XCTAssertEqual(currentWeather.main.temp, currentWeatherModel.main.temp, "Incorrect main.temp.")
                XCTAssertEqual(currentWeather.main.temp_min, currentWeatherModel.main.temp_min, "Incorrect main.temp_min.")
                XCTAssertEqual(currentWeather.main.temp_max, currentWeatherModel.main.temp_max, "Incorrect main.temp_max.")
                XCTAssertEqual(currentWeather.main.feels_like, currentWeatherModel.main.feels_like, "Incorrect main.feels_like.")
                XCTAssertTrue(currentWeather.weather.count == 1)
                XCTAssertEqual(currentWeather.weather[0].main, currentWeatherModel.weather[0].main, "Incorrect weather.main.")

            case .failure(let error):
                XCTFail("Error was not expected: \(error)")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testGetWeatherParseError() throws {
        
        let cityModel = CityModel(name: "Toronto", lat: 43.6534817, lon: -79.3839347, country: "CA", state: "Ontario")
        
        let data = try JSONEncoder().encode(cityModel)
        
        MockURLProtocol.requestHandler = { request in
            return (HTTPURLResponse(), data)
        }
        
        let expectation = XCTestExpectation(description: "response")
        
        openWeatherAPIClient.fetchCurrentWeather(lat: cityModel.lat, lon: cityModel.lon) { (result) in
            switch result {
            case .success(_):
                XCTFail("Success was not expected")
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, OpenWeatherAPIError.parseError.localizedDescription, "Incorrect error.")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testGetWeatherServerError() throws {
        
        let cityModel = CityModel(name: "Toronto", lat: 43.6534817, lon: -79.3839347, country: "CA", state: "Ontario")
        
        let currentWeatherModel = CurrentWeatherModel(weather: [Weather(id: 0, main: "clouds", description: "", icon: "")], base: "Station", main: Main(temp: 290.0, feels_like: 290.0, temp_min: 280.0, temp_max: 300.0, pressure: 100000, humidity: 50), name: "Toronto")
        
        let data = try JSONEncoder().encode(currentWeatherModel)
        
        let response = HTTPURLResponse(url: URL(string: GEO_CODING_API(cityName: cityModel.name, stateCode: "", countryCode: ""))!, statusCode: 404, httpVersion: nil, headerFields: nil)!
        
        MockURLProtocol.requestHandler = { request in
            return (response, data)
        }
        
        let expectation = XCTestExpectation(description: "response")
        
        openWeatherAPIClient.fetchCurrentWeather(lat: cityModel.lat, lon: cityModel.lon) { (result) in
            switch result {
            case .success(_):
                XCTFail("Success was not expected")
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, OpenWeatherAPIError.serverSideError(404, "").localizedDescription, "Incorrect error.")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
}
