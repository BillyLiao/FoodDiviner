//
//  Restaurant.swift
//  FoodDiviner
//
//  Created by 廖慶麟 on 2016/5/28.
//  Copyright © 2016年 廖慶麟. All rights reserved.
//

import Foundation
import CoreData

class Restaurant:NSManagedObject{
    
    @NSManaged var address: String!
    @NSManaged var cuisine: String!
    @NSManaged var name: String!
    @NSManaged var order: String!
    @NSManaged var phone: String!
    @NSManaged var price: String!
    @NSManaged var scenario: String!
    @NSManaged var time: String!
    @NSManaged var restaurant_id: NSNumber!
    @NSManaged var tags: String!
    @NSManaged var photo: NSData!
    @NSManaged var avgRating: NSNumber!
    @NSManaged var userRating: NSNumber!
    @NSManaged var lastBeenDate: NSDate!
    @NSManaged var collectTime: NSNumber!
    @NSManaged var status: NSNumber!
}