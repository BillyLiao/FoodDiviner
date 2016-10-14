//
//  Restaurant.swift
//  FoodDiviner
//
//  Created by 廖慶麟 on 2016/5/28.
//  Copyright © 2016年 廖慶麟. All rights reserved.
//

import Foundation
import RealmSwift

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
}