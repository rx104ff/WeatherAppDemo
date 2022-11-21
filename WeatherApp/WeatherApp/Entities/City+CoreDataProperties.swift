//
//  City+CoreDataProperties.swift
//  WeatherApp
//
//  Created by Ningyuan Gao on 11/19/22.
//
//

import Foundation
import CoreData


extension City {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<City> {
        return NSFetchRequest<City>(entityName: "City")
    }

    @NSManaged public var timestamp: Date?
    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var lat: Double
    @NSManaged public var lon: Double
    @NSManaged public var country: String?
    @NSManaged public var state: String?

}

extension City : Identifiable {

}
