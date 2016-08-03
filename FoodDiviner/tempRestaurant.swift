//
//  trialRestaurant.swift
//  FoodDiviner
//
//  Created by 廖慶麟 on 2016/6/22.
//  Copyright © 2016年 廖慶麟. All rights reserved.
//

import Foundation

class tempRestaurant: NSObject{
    
    override init(){
        super.init()
    }
    
    var address: String!
    var cuisine: String!
    var name: String!
    var order: String!
    var phone: String!
    var price: String!
    var scenario: String!
    var time: String!
    var restaurant_id: NSNumber!
    var tags: String!
    var photo: NSData!
    var avgRating: Float!
}