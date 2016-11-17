//
//  MainButton.swift
//  FoodDiviner
//
//  Created by 廖慶麟 on 2016/11/8.
//  Copyright © 2016年 廖慶麟. All rights reserved.
//

import UIKit

class MainButton: UIButton {

    override init(frame: CGRect){
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup(){
        self.backgroundColor = UIColor.whiteColor()
        self.layer.cornerRadius = self.bounds.size.width/2
        self.clipsToBounds = true
        self.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }

}
