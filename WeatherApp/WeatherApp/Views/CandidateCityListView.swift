//
//  CandidateCityListView.swift
//  WeatherApp
//
//  Created by Ningyuan Gao on 11/19/22.
//

import Foundation
import SwiftUI

struct CandidateCityListView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) private var viewContext
    
    @Binding var candidates: [CityModel]
    var body: some View {
        NavigationView {
            List {
                ForEach(candidates, id: \.self) { candidate in
                    HStack {
                        Text("\(candidate.name), \(candidate.state.isEmpty ?  "" : candidate.state + ",") \(candidate.country)")
                    }
                    .onTapGesture {
                        addCity(candidate: candidate)
                    }
                }
            }
            .navigationBarTitle("Cities", displayMode: .large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
    
    private func addCity(candidate: CityModel) {
        withAnimation {
            let newCity = City(context: viewContext)
            newCity.timestamp = Date()
            newCity.name = candidate.name
            
            var nameData = candidate.name.data(using: .utf8)
            nameData?.append(contentsOf: withUnsafeBytes(of: candidate.lat) { Data($0) })
            nameData?.append(contentsOf: withUnsafeBytes(of: candidate.lon) { Data($0) })
            
            let id = SHA256.hash(data: nameData!).compactMap { String(format: "%02x", $0) }.joined()
            
            newCity.id = id
            newCity.lat = candidate.lat
            newCity.lon = candidate.lon
            newCity.state = candidate.state
            newCity.country = candidate.country

            do {
                try viewContext.save()
                presentationMode.wrappedValue.dismiss()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}
