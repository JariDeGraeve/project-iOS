//
//  DummyData.swift
//  LosTrouvee
//
//  Created by Jari De Graeve on 15/11/2018.
//  Copyright © 2018 Jari De Graeve. All rights reserved.
//

import Foundation

struct DummyData {
    static func getDummyItems() -> [Item] {
        let lost1 = Item(title:"Sleutels peugeot 308", description: "Ik heb mijn sleutels verloren. Heb je ze gevonden? Laat me zeker iets weten!", found: false, category: .key, place: Place(postalCode: "9000", city: "Gent", street: "Overpoortstraat", name: "Cuba"), contact: Contact(firstname: "Jari", lastname: "De Graeve", email: "degraevejari@live.be", mobile: "0472907809"), timestamp: Date().addingTimeInterval(-24*60*60), userEmail: "degraevejari@live.be")
        let lost2 = Item(title:"Iphone 7", description: "Ik heb mijn iphone verloren. Heb je hem gevonden? Laat me zeker iets weten!", found: false, category: .key, place: Place(postalCode: "9000", city: "Gent", street: "Overpoortstraat"), contact: Contact(firstname: "Jari", lastname: "De Graeve", email: "degraevejari@live.be", mobile: "0472907809"), timestamp: Date().addingTimeInterval(-25*60*60), userEmail: "degraevejari@live.be")
        let found1 = Item(title:"Iphone 7", description: "Ik heb een iphone gevonden. Heb je hem verloren? Laat me zeker iets weten!", found: true, category: .key, place: Place(postalCode: "9000", city: "Gent", street: "Overpoortstraat"), contact: Contact(firstname: "Jari", lastname: "De Graeve", email: "degraevejari@live.be", mobile: "0472907809"), timestamp: Date().addingTimeInterval(-25*60*60), userEmail: "degraevejari@live.be")
        return [lost1, lost2, found1]
    }
}
