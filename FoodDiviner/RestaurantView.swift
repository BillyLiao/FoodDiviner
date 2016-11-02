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

class RestaurantView: UIView {
    
    let titleView: UIView = UIView(frame: CGRectZero)
    let imageView: UIImageView = UIImageView(frame: CGRectZero)
    let nameLabel: UILabel = UILabel(frame: CGRectZero)
    let infoLabel: UILabel = UILabel(frame: CGRectZero)
    let deviceHelper = DeviceHelper()
    var likeSticker: UIImageView!
    var nopeSticker: UIImageView!
    var takeSticker: UIImageView!
    var restaurant: Restaurant!
    let scaleToRemoveCell: CGFloat = 0.3
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 5
        
        titleView.frame = CGRectMake(0, self.frame.height-60, self.frame.width, 60)
        titleView.backgroundColor = UIColor.whiteColor()
        
        infoLabel.frame = CGRectMake(5, titleView.frame.height*0.5, titleView.frame.width, titleView.frame.height/2)
        infoLabel.textColor = UIColor.lightGrayColor()
        infoLabel.font = infoLabel.font.fontWithSize(15)
        titleView.addSubview(infoLabel)
        
        nameLabel.frame = CGRectMake(5, 0, titleView.frame.width*0.6, titleView.frame.height/2)
        nameLabel.font = nameLabel.font.fontWithSize(17)
        titleView.addSubview(nameLabel)
        self.addSubview(titleView)
        
        imageView.frame = CGRectMake(0, 0, self.frame.width, self.frame.height-60)
        imageView.clipsToBounds = true //裁切超過Parent view的部分
        imageView.contentMode = .ScaleAspectFill
        self.addSubview(imageView)
        
        setupStatusImage()
    }

    convenience init(frame: CGRect, restaurant: Restaurant) {
        self.init(frame: frame)
        self.restaurant = restaurant
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
    
    func respondToTranslation(translation: CGPoint) {
        let xDrift = translation.x
        let yDrift = translation.y
        
        let likeAlpha = xDrift / (self.frame.width * scaleToRemoveCell)
        let dislikeAlpha = -xDrift / (self.frame.width * scaleToRemoveCell)
        let superlikeAlpha = -yDrift / (self.frame.height * scaleToRemoveCell)
        
        UIView.animateWithDuration(0, animations: { 
            if likeAlpha > dislikeAlpha && likeAlpha > superlikeAlpha {
                self.setImaegAlpha(likeAlpha: likeAlpha, dislikeAlpha: 0, superlikeAlpha: 0)
            }else if dislikeAlpha > likeAlpha && dislikeAlpha > superlikeAlpha {
                self.setImaegAlpha(likeAlpha: 0, dislikeAlpha: dislikeAlpha, superlikeAlpha: 0)
            }else {
                self.setImaegAlpha(likeAlpha: 0, dislikeAlpha: 0, superlikeAlpha: superlikeAlpha)
            }

            }) { (finished) in
        }
    }
    
    private func setImaegAlpha(likeAlpha likeAlpha: CGFloat, dislikeAlpha: CGFloat, superlikeAlpha: CGFloat){
        likeSticker.alpha = likeAlpha
        nopeSticker.alpha = dislikeAlpha
        takeSticker.alpha = superlikeAlpha
    }
    
    func clearStickers() {
        self.setImaegAlpha(likeAlpha: 0, dislikeAlpha: 0, superlikeAlpha: 0)
    }
    
    func setup() {
        // Shadow
        layer.shadowColor = UIColor.blackColor().CGColor
        layer.shadowOpacity = 0.25
        layer.shadowOffset = CGSizeMake(0, 1.5)
        layer.shadowRadius = 4.0
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.mainScreen().scale
        
        // Corner Radius
        layer.cornerRadius = 10.0;
    }
    
}
