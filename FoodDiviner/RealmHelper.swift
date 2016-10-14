//
//  RealmHelper.swift
//  FoodDiviner
//
//  Created by 廖慶麟 on 2016/8/26.
//  Copyright © 2016年 廖慶麟. All rights reserved.
//

import Foundation
import RealmSwift

class RealmHelper {
    
    static func addRestaurant(restaurant: Restaurant) {
        let realm = try! Realm()
        print("Add restaurant")
        
        // In case the phone and time is nil.
        try! realm.write() {
            realm.add(restaurant)
        }
    }
    
    static func deleteRestaurant(restaurant: Restaurant) {
        let realm = try! Realm()
        
        if isRestaurantExist(restaurant) {
            try! realm.write() {
                realm.delete(restaurant)
            }
        }
    }
    
    static func updateRestaurant(restaurant: Restaurant, status: Int){
        let realm = try! Realm()
        if isRestaurantExist(restaurant){
            if let result = realm.objects(Restaurant).filter("restaurant_id == \(restaurant.restaurant_id)").first! as? Restaurant {
                try! realm.write() {
                    result.status = status
                }
            }
        }

    }

    static func updateRestaurant(restaurant: Restaurant, status: Int, rate: Int, date: NSDate){
        let realm = try! Realm()
        try! realm.write() {
            restaurant.status = status
            restaurant.userRating = rate
            restaurant.lastBeenDate = date
        }
    }
    
    static func retriveRestaurantByStatus(status: Int) -> Results<Restaurant> {
        let realm = try! Realm()
        return realm.objects(Restaurant).filter("status == \(status)").sorted("collectTime", ascending: false)
    }
    
    static func retriveAllRestaurants() -> Results<Restaurant> {
        let realm = try! Realm()
        return realm.objects(Restaurant)
    }
    
    static func cleanPhotosInRestaurants() {
        let restaurants = retriveAllRestaurants()
        for restaurant in restaurants {
            restaurant.photo = nil
        }
    }
    
    static func addPhotosInRestaurant(restaurant: Restaurant, imageData: NSData){
        let realm = try! Realm()
        try! realm.write() {
            restaurant.photo = imageData
        }
    }
    
    static func isRestaurantExist(restaurant: Restaurant) -> Bool {
        let realm = try! Realm()
        if (realm.objects(Restaurant).filter("restaurant_id == \(restaurant.restaurant_id)").count) != 0
        {
            return true
        }else {
            return false
        }
    }
    
    static func addRestaurantCollectionTime(restaurant: Restaurant){
        let realm = try! Realm()
        print("Add collection times.")
        if isRestaurantExist(restaurant){
            if let result = realm.objects(Restaurant).filter("restaurant_id == \(restaurant.restaurant_id)").first! as? Restaurant {
                try! realm.write() {
                    let collectTime = Int(result.collectTime)
                    result.collectTime = collectTime + 1
                }
            }
        }
    }
    
    static func addRestaurantBeenTime(restaurant: Restaurant) {
        let realm = try! Realm()
        if isRestaurantExist(restaurant) {
            if let result = realm.objects(Restaurant).filter("restarant_id == \(restaurant.restaurant_id)").first! as? Restaurant {
                try! realm.write() {
                    let beenTime = Int(result.beenTime)
                    result.beenTime = beenTime + 1
                }
            }
        }
    }
    
}