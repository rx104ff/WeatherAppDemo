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
                ForEach(cities.filter({ (fruit: City) -> Bool in
                    return fruit.name!.contains(inputString) || inputString == ""
                }), id: \.self) { item in
                    NavigationLink {
                        CityDetailView(cityWeatherViewModel: CityWeatherViewModel(city: item))
                    } label: {
                        CityCellView(cityWeatherViewModel: CityWeatherViewModel(city: item))
                    }
                }
                .onDelete(perform: removeCity)
            }
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
                    showCandidateCityList = true
                case .failure(let error):
                    switch error {
                    case .serverSideError(let statusCode, let message):
                        errorTitle = "Status: \(statusCode)"
                        errorMessage = message
                        showErrorAlert = true
                    case .transportError:
                        errorTitle = "Connection Issues"
                        errorMessage = "Please Check the Internet Connection"
                        showErrorAlert = true
                    case .parseError:
                        errorTitle = "Error Parsing JSON"
                        errorMessage = ""
                        showErrorAlert = true
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
