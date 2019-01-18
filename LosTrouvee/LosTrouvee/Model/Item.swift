//
//  Item.swift
//  LosTrouvee
//
//  Created by Jari De Graeve on 15/11/2018.
//  Copyright © 2018 Jari De Graeve. All rights reserved.
//

import Foundation
import RealmSwift

class Item : Object {
    //var id: Int
    @objc dynamic var title: String = ""
    @objc dynamic var itemDescription: String = ""
    @objc dynamic var found: Bool = true
    @objc dynamic var categoryRaw: String = ""
    @objc dynamic var place: Place? = nil
    @objc dynamic var contact: Contact? = nil
    @objc dynamic var timestamp: Date = Date() //time when lost or found
    @objc dynamic var userEmail: String = ""
    @objc dynamic var timeAdded: Date = Date() //time when lost or found item was posted
    
    var category: Category {
        get {
            return Category(rawValue: categoryRaw) ?? .other
        } set {
            categoryRaw = newValue.rawValue
        }
    }
    
    //var user: User
    //var image: Image //not sure
    convenience init(title:String, itemDescription: String, found: Bool, category: Category, place: Place, contact: Contact, timestamp: Date,userEmail:String, timeAdded: Date = Date()) {
        self.init()
        self.title = title
        self.itemDescription = itemDescription
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

class Place : Object{
    //var id: Int
    @objc dynamic var postalCode: String = ""
    @objc dynamic var city: String = ""
    @objc dynamic var street: String = ""
    @objc dynamic var nr: String = ""
    @objc dynamic var placeName: String = ""
    
    convenience init(postalCode:String, city: String, street: String, nr: String = "", name: String = "") {
        self.init()
        self.postalCode = postalCode
        self.city = city
        self.street = street
        self.nr = nr
        self.placeName = name
    }
}

class Contact : Object{
    //var id: Int
    @objc dynamic var firstname: String = ""
    @objc dynamic var lastname: String = ""
    @objc dynamic var email: String = ""
    @objc dynamic var tel: String = ""
    @objc dynamic var mobile: String = ""
    
    convenience init(firstname: String, lastname: String, email: String, tel: String = "", mobile: String = "") {
        self.init()
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


