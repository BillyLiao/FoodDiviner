//
//  RestaurantCell.swift
//  FoodDiviner
//
//  Created by 廖慶麟 on 2016/5/26.
//  Copyright © 2016年 廖慶麟. All rights reserved.
//

import UIKit
import ZLSwipeableViewSwift
import FDRatingView
import SDWebImage

class RestaurantView: ZLSwipeableView {
    
    let titleView: UIView = UIView(frame: CGRectZero)
    let imageView: UIImageView = UIImageView(frame: CGRectZero)
    let nameLabel: UILabel = UILabel(frame: CGRectZero)
    let infoLabel: UILabel = UILabel(frame: CGRectZero)
    let deviceHelper = DeviceHelper()
    var likeSticker: UIImageView!
    var nopeSticker: UIImageView!
    var takeSticker: UIImageView!
    var restaurant: Restaurant!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init() {
        super.init(frame: CGRectZero)
        self.frame = CGRect(origin: CGPointZero, size: CGSize(width: UIScreen.mainScreen().bounds.width - 16 , height: UIScreen.mainScreen().bounds.height * (2/3)))
        self.center.x = UIScreen.mainScreen().bounds.width/2
        self.frame.origin.y = 15
        self.backgroundColor = UIColor.blueColor()
        titleView.frame = CGRectMake(0, self.frame.height-60, self.frame.width, 60)
        titleView.backgroundColor = UIColor.whiteColor()
        
        infoLabel.frame = CGRectMake(5, titleView.frame.height*0.5, titleView.frame.width, titleView.frame.height/2)
        infoLabel.textColor = UIColor.lightGrayColor()
        infoLabel.font = infoLabel.font.fontWithSize(15)
        titleView.addSubview(infoLabel)
        
        nameLabel.frame = CGRectMake(5, 0, titleView.frame.width*0.6, titleView.frame.height/2)
        nameLabel.font = nameLabel.font.fontWithSize(17)
        titleView.addSubview(nameLabel)
        
        imageView.frame = CGRectMake(0, 10, self.frame.width, self.frame.height-60)
        imageView.clipsToBounds = true //裁切超過Parent view的部分
        imageView.contentMode = .ScaleAspectFill
        titleView.backgroundColor = UIColor.redColor()
        self.addSubview(imageView)
        self.addSubview(titleView)
    }
    
    convenience init(restaurant: Restaurant) {
        self.init()
        self.nameLabel.text = restaurant.name
        self.infoLabel.text = restaurant.cuisine
        if let image_id = restaurant.image_id {
            self.imageView.sd_setImageWithURL(NSURL(string:"http://api-server.jqemsuerdm.ap-northeast-1.elasticbeanstalk.com/images/\(image_id)"), placeholderImage: UIImage(named:"imagePlaceHolder"), completed: { (image, error, cacheType, url) in
                restaurant.photo = UIImageJPEGRepresentation(image, 0.6)
            })
        }else {
            self.imageView.image = UIImage(named: "imagePlaceHolder")
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setRatingView(rating: Float?){
        if let rate = rating {
            switch  deviceHelper.checkSize() {
            case "iphone4Family":
                let ratingView = FDRatingView(frame: CGRectMake(titleView.frame.width*0.6, 0, 0, 20), style: .Star, numberOfElements: 5, fillValue: rate, color: UIColor(red: 255.0/255.0, green: 106.0/255.0, blue: 79.0/255.0, alpha: 1.0), lineWidth: 0.7, spacing: 3)
                ratingView.center.y = titleView.frame.height * 0.25
                titleView.addSubview(ratingView)
            case "iphone5Family":
                let ratingView = FDRatingView(frame: CGRectMake(titleView.frame.width*0.6, 0, 0, 19), style: .Star, numberOfElements: 5, fillValue: rate, color: UIColor(red: 255.0/255.0, green: 106.0/255.0, blue: 79.0/255.0, alpha: 1.0), lineWidth: 0.7, spacing: 3)
                ratingView.center.y = titleView.frame.height * 0.25
                titleView.addSubview(ratingView)
            case "iphone6Family":
                let ratingView = FDRatingView(frame: CGRectMake(titleView.frame.width*0.6, 0, 0, 20), style: .Star, numberOfElements: 5, fillValue: rate, color: UIColor(red: 255.0/255.0, green: 106.0/255.0, blue: 79.0/255.0, alpha: 1.0), lineWidth: 0.7, spacing: 3)
                ratingView.center.y = titleView.frame.height * 0.25
                titleView.addSubview(ratingView)
            default:
                break
            }

        }
    }
    
    func setupStatusImage() {
        likeSticker = UIImageView.init(state: "like")
        likeSticker.center.x = self.frame.width/3
        likeSticker.center.y = 100
        
        nopeSticker = UIImageView.init(state: "nope")
        nopeSticker.center.x = self.frame.width*2/3
        nopeSticker.center.y = 100
        
        takeSticker = UIImageView.init(state: "take")
        takeSticker.center.x = self.frame.width/2
        takeSticker.center.y = UIScreen.mainScreen().bounds.height/2
        
        self.addSubview(likeSticker)
        self.addSubview(nopeSticker)
        self.addSubview(takeSticker)
    }


    
}
