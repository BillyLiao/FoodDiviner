//
//  CustomizedButton.swift
//  FoodDiviner
//
//  Created by 廖慶麟 on 2016/11/8.
//  Copyright © 2016年 廖慶麟. All rights reserved.
//

import UIKit

class CustomizedButton: UIButton {

    static let borderColor = UIColor(red: 255.0/255.0, green: 106.0/255.0, blue: 79.0/255.0, alpha: 1.0).CGColor
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    func setup(){
        let borderColor = UIColor(red: 255.0/255.0, green: 106.0/255.0, blue: 79.0/255.0, alpha: 1.0).CGColor

        self.setTitleColor(UIColor.whiteColor(), forState: .Selected)
        self.setTitleColor(UIColor(red: 255.0/255.0, green: 106.0/255.0, blue: 79.0/255.0, alpha: 1.0), forState: .Normal)
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 1
        self.layer.borderColor = borderColor
    }
    
    override var selected: Bool {
        didSet{
            if selected == true {
                self.backgroundColor = UIColor(red: 255.0/255.0, green: 106.0/255.0, blue: 79.0/255.0, alpha: 1)
            }else {
                self.backgroundColor = UIColor.whiteColor()
            }
        }
    }
}
