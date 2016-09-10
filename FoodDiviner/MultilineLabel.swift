//
//  MultilineLabel.swift
//  FoodDiviner
//
//  Created by 廖慶麟 on 2016/9/10.
//  Copyright © 2016年 廖慶麟. All rights reserved.
//

import UIKit

class MultilineLabel: UILabel{
    override func layoutSubviews() {
        super.layoutSubviews()
        preferredMaxLayoutWidth = bounds.width
        super.layoutSubviews()
    }
}