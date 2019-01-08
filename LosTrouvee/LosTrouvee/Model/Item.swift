//
//  Item.swift
//  LosTrouvee
//
//  Created by Jari De Graeve on 15/11/2018.
//  Copyright © 2018 Jari De Graeve. All rights reserved.
//

import Foundation

struct Item {
    //var id: Int
    let title: String
    let description: String
    let found: Bool
    let category: Category
    let place: Place
    let contact: Contact
    let timestamp: Date //time when lost or found
    let userEmail: String
    let timeAdded: Date//time when lost or found item was posted
    
    //var user: User
    //var image: Image //not sure
    init(title:String, description: String, found: Bool, category: Category, place: Place, contact: Contact, timestamp: Date,userEmail:String, timeAdded: Date = Date()) {
        self.title = title
        self.description = description
        self.found = found
        self.category = category
        self.place = place
        self.contact = contact
        self.timestamp = timestamp
        self.userEmail = userEmail
        //default current date when new item is created
        //default empty when new item is created
        self.timeAdded = timeAdded
    }
    
    static let timeStampDateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .none
        return df
    }()
    
    static let timeAddedDateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .short
        return df
    }()
}

struct Place {
    //var id: Int
    let postalCode: String
    let city: String
    let street: String
    let nr: String
    let placeName: String
    
    init(postalCode:String, city: String, street: String, nr: String = "", name: String = "") {
        self.postalCode = postalCode
        self.city = city
        self.street = street
        self.nr = nr
        self.placeName = name
    }
}

struct Contact {
    //var id: Int
    let firstname: String
    let lastname: String
    let email: String
    let tel: String
    let mobile: String
    
    init(firstname: String, lastname: String, email: String, tel: String = "", mobile: String = "") {
        self.firstname = firstname
        self.lastname = lastname
        self.email = email
        self.tel = tel
        self.mobile = mobile
    }
}

enum Category : String, CaseIterable {
    case pet
    case key
    case laptop
    case smartphone
    case wallet
    case handbag
    case clothes
    case jewellery
    case toy
    case picture
    case document
    case headphones
    case computeraccessory
    case game
    case identitycard
    case medication
    case food
    case book
    case tool
    case carraccessory
    case suitcase
    case backpack
    case other
}


