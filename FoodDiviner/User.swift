//
//  User.swift
//  FoodDiviner
//
//  Created by 廖慶麟 on 2016/7/14.
//  Copyright © 2016年 廖慶麟. All rights reserved.
//

import Foundation
import CoreData

class User:NSManagedObject{
    @NSManaged var age: NSNumber?
    @NSManaged var email: String!
    @NSManaged var user_id: String?
    @NSManaged var fb_user_id: String!
    @NSManaged var gender: String!
    @NSManaged var name: String!
}