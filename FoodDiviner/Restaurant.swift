//
//  Restaurant.swift
//  FoodDiviner
//
//  Created by 廖慶麟 on 2016/5/28.
//  Copyright © 2016年 廖慶麟. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON
import SDWebImage

class Restaurant: Object{
    dynamic var address: String! = ""
    dynamic var cuisine: String! = ""
    dynamic var name: String! = ""
    dynamic var order: String! = ""
    dynamic var phone: String?
    dynamic var price: String! = ""
    dynamic var scenario: String! = ""
    dynamic var time: String?
    dynamic var restaurant_id: NSNumber! = 0
    dynamic var tags: String! = ""
    dynamic var photo: NSData?
    dynamic var image_id: String?
    dynamic var avgRating: NSNumber! = 0
    dynamic var userRating: NSNumber! = 0
    dynamic var lastBeenDate: NSDate! = NSDate()
    dynamic var collectTime: NSNumber! = 0
    dynamic var beenTime: NSNumber! = 0 
    dynamic var status: NSNumber! = 0
    
    convenience init(json: JSON) {
        self.init()
        address = json["address"].string
        cuisine = json["cuisine"][0].string
        time = json["hours"].string
        name = json["name"].string
        order = json["ordering"][0].string
        phone = json["phone"].string
        price = json["price"].string
        restaurant_id = json["restaurant_id"].int
        scenario = json["scenario"][0].string
        tags = json["tags"][0].string
        image_id = json["image"][0].string
        avgRating = 5
        
        if let image = UIImage(named: "\(name)") {
            photo = UIImageJPEGRepresentation(image, 0.6)
        }

        if json["cuisine"].count > 1 {
            for j in 1..<json["cuisine"].count {
                cuisine = cuisine + ", \(json["cuisine"][j].string!)"
            }
        }
        
        if json["scenario"].count > 1 {
            for j in 1..<json["scenario"].count {
                scenario = scenario + ", \(json["scenario"][j].string!)"
            }
        }
        
        if json["tags"].count > 1 {
            for j in 1..<json["tags"].count {
                tags = tags + ", \(json["tags"][j].string!)"
            }
        }
        
        if json["ordering"].count > 1 {
            for j in 1..<json["ordering"].count {
                order = order + ", \(json["ordering"][j].string!)"
            }
        }

    }
    
}