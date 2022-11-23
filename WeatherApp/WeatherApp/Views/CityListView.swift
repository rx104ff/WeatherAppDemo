//
//  ContentView.swift
//  WeatherApp
//
//  Created by Ningyuan Gao on 11/19/22.
//

import SwiftUI
import CoreData

struct CityListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var inputString: String = ""
    @State private var showErrorAlert: Bool = false
    @State private var errorTitle: String = ""
    @State private var errorMessage: String = ""
    
    @State private var candidateCities: [CityModel] = []
    @State private var showCandidateCityList: Bool = false
    
    @FetchRequest(entity:City.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \City.timestamp, ascending: true)]) private var cities: FetchedResults<City>
    
    var body: some View {
        NavigationView {
            List {
                ForEach(cities.filter({ (city: City) -> Bool in
                    return city.name!.contains(inputString) || city.country!.contains(inputString) || city.state!.contains(inputString) || inputString == ""
                }), id: \.self) { city in
                    NavigationLink {
                        CityDetailView(cityWeatherViewModel: CityWeatherViewModel(city: city))
                    } label: {
                        CityCellView(cityWeatherViewModel: CityWeatherViewModel(city: city))
                    }
                }
                .onDelete(perform: removeCity)
            }
            .navigationBarTitle("Cities", displayMode: .large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    TextField(
                        "Example: Toronto, Ontario, CA",
                        text: $inputString
                    ).disableAutocorrection(true)
                }
                ToolbarItem {
                    Button(action: addCity) {
                        Label("Add Item", systemImage: "plus")
                    }.disabled(inputString.isEmpty)
                }
            }
        }
        .sheet(isPresented: $showCandidateCityList) {
          CandidateCityListView(candidates: $candidateCities)
                .environment(\.managedObjectContext, viewContext)
        }
        .alert(isPresented: $showErrorAlert) {
            Alert(
                title: Text(errorTitle),
                message: Text(errorMessage)
            )
        }
    }

    private func addCity() {
        withAnimation {
            candidateCities = []
            
            let parsedInfo = inputString.split(separator: ",")
            
            let cityName = parsedInfo[0].trimmingCharacters(in: CharacterSet.whitespaces).addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
            let stateCode = parsedInfo.count > 1 ? parsedInfo[1].trimmingCharacters(in:  CharacterSet.whitespaces).addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) : ""
            let countryCode =  parsedInfo.count > 2 ? parsedInfo[2].trimmingCharacters(in:  CharacterSet.whitespaces).addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) : ""
            
            OpenWeatherAPIClient().fetchGeoInfo(cityName: cityName!, stateCode: stateCode!, countryCode: countryCode!) { (result) in
                switch result {
                case .success(let cities):
                    candidateCities = cities
                    self.inputString = ""
                    showCandidateCityList = true
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
    
    private func removeCity(offsets: IndexSet) {
        withAnimation {
            offsets.map { cities[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}
