//
//  Tutor.swift
//  Fibbonia
//
//  Created by Gurkarn Goindi on 20/Apr/20.
//  Copyright © 2020 Gurkarn Goindi. All rights reserved.
//

import Foundation
import Firebase


class Tutor {
    
    var calEmail: String
    var gradyear: Int
    var classes: [String]
    var rating: Double
    var experience: Int
    var phone: String
    var name: String
    var zoom: String
    var appointments: [[String: Any]]
    var subjects: [String]
    var setPrefs: Bool
    var preferences: [String: Any]
    var img: String
    var firstlogin: Bool
    var prefTime: [String: [Int]]
    
    init(name: String ,calEmail: String, gradyear: Int, subjects: [String], phone: String, zoom: String, setPrefs: Bool, preferences: [String: Any], img: String, firstlogin: Bool, prefTime: [String: [Int]]) {
        self.name = name
        self.calEmail = calEmail
        self.gradyear = gradyear
        self.firstlogin = firstlogin
        self.classes = []
        self.rating = 0.0
        self.experience = 0
        self.phone = phone
        self.zoom = zoom
        self.appointments = [["ABC":"DEF"]]
        self.subjects = subjects
        self.setPrefs = setPrefs
        self.preferences = preferences
        self.img = img
        self.prefTime = prefTime
        
        //self.classRating = [:]
    }
    
    func addClass(clas: String) {
        self.classes.append(clas)
    }
    
    func rateTutor(rate: Double) {
        self.experience += 1
        let newRating = (self.rating + rate) / Double(self.experience)
        self.rating = newRating
    }
    
    func getData() -> [String:Any] {
        return ["name": self.name, "email":self.calEmail, "classes": self.classes, "rating": self.rating, "experience": self.experience, "onlineID": self.zoom, "appointments": self.appointments, "subjects": self.subjects]
    }
    
    
    
    func setOnline(ID: String) {
        self.zoom = ID
    }
    
    func newAppt(appt: [String: Any]) {
        self.appointments.append(appt)
    }
    
    
}
