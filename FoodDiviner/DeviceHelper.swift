//
//  DeviceHelper.swift
//  FoodDiviner
//
//  Created by 廖慶麟 on 2016/8/28.
//  Copyright © 2016年 廖慶麟. All rights reserved.
//

import Foundation
import DeviceKit

class DeviceHelper {
    let device = Device()
    
    let iphone4sSizedGroup: [Device] = [.iPhone4, .iPhone4s, .Simulator(.iPhone4), .Simulator(.iPhone4s)]
    let iphone5sSizedGroup: [Device] = [.iPhone5, .iPhone5c, .iPhone5s, .iPhoneSE, .iPodTouch5, .iPodTouch6, .Simulator(.iPhone5), .Simulator(.iPhone5c), .Simulator(.iPhone5s), .Simulator(.iPhoneSE), .Simulator(.iPodTouch5), .Simulator(.iPodTouch6)]
    let iphone6sSizedGroup: [Device] = [.iPhone6, .iPhone6s, .Simulator(.iPhone6), .Simulator(.iPhone6s)]
    
    func checkSize() -> String {
        if device.isOneOf(iphone4sSizedGroup) {
            return "iphone4Family"
        }else if device.isOneOf(iphone5sSizedGroup){
            return "iphone5Family"
        }else {
            return "iphone6Family"
        }
    }
    
}