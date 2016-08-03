//
//  RestaurantCell.swift
//  FoodDiviner
//
//  Created by 廖慶麟 on 2016/5/26.
//  Copyright © 2016年 廖慶麟. All rights reserved.
//

import UIKit
import SPTinderView
import FDRatingView

class RestaurantCell: SPTinderViewCell {
    let titleView: UIView = UIView(frame: CGRectZero)
    let imageView: UIImageView = UIImageView(frame: CGRectZero)
    let nameLabel: UILabel = UILabel(frame: CGRectZero)
    let infoLabel: UILabel = UILabel(frame: CGRectZero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required init(reuseIdentifier: String) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.frame = CGRect(origin: CGPointZero, size: CGSize(width: UIScreen.mainScreen().bounds.width - 40 , height: UIScreen.mainScreen().bounds.height-180))
        titleView.frame = CGRectMake(0, self.frame.height-60, self.frame.width, 60)
        titleView.backgroundColor = UIColor.whiteColor()
        
        infoLabel.frame = CGRectMake(15, titleView.frame.height*0.5, titleView.frame.width, titleView.frame.height/2)
        infoLabel.textColor = UIColor.lightGrayColor()
        titleView.addSubview(infoLabel)
        
        nameLabel.frame = CGRectMake(15, 0, titleView.frame.width*0.6, titleView.frame.height/2)
        nameLabel.font = nameLabel.font.fontWithSize(20)
        titleView.addSubview(nameLabel)
        
        imageView.frame = CGRectMake(0, 10, self.frame.width, self.frame.height-60)

        imageView.clipsToBounds = true //裁切超過Parent view的部分
        imageView.contentMode = .ScaleAspectFill
        self.addSubview(imageView)
        self.addSubview(titleView)
    }
    
    func setRatingView(rating: Float?){
        if let rate = rating {
            let ratingView = FDRatingView(frame: CGRectMake(titleView.frame.width*0.6, 0, titleView.frame.width*0.4, 23), style: .Star, numberOfElements: 5, fillValue: rate, color: UIColor(red: 255.0/255.0, green: 106.0/255.0, blue: 79.0/255.0, alpha: 1.0), lineWidth: 0.7, spacing: 3)
            
            ratingView.center.y = titleView.frame.height * 0.25
            titleView.addSubview(ratingView)
        }
    }

    
}
