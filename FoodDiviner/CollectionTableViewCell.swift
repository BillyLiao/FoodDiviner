//
//  CollectionTableViewCell.swift
//  FoodDiviner
//
//  Created by 廖慶麟 on 2016/5/28.
//  Copyright © 2016年 廖慶麟. All rights reserved.
//

import UIKit
import FDRatingView

class CollectionTableViewCell: UITableViewCell {

    @IBOutlet weak var rtImageView: UIImageView!
    @IBOutlet weak var cltTime: UILabel!
    @IBOutlet weak var rtName: UILabel!
    @IBOutlet weak var starView: UIView!
    var rating: Float!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        rtImageView.layer.cornerRadius = rtImageView.frame.size.width/2
        rtImageView.clipsToBounds = true
        self.selectionStyle = UITableViewCellSelectionStyle.None
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setRating(rating: Float!) {
        let deviceHelper = DeviceHelper()
        let rateView = FDRatingView(frame: CGRectMake(starView.frame.origin.x, starView.frame.origin.y, starView.frame.width, 16), style: .Star, numberOfElements: 5, fillValue: rating, color: UIColor(red: 255.0/255.0, green: 106.0/255.0, blue: 79.0/255.0, alpha: 1.0), lineWidth: 0.7, spacing: 1)
        rateView.backgroundColor = UIColor.blueColor()
        //FIXME
        switch deviceHelper.checkSize() {
        case "iphone4":
            rateView.frame = CGRectMake(starView.frame.origin.x, starView.frame.origin.y, starView.frame.width, 18)
            print("iphone4")
        case "iphone5":
            print("iphone5")
        case "iphone6":
            rateView.frame = CGRectMake(starView.frame.origin.x, starView.frame.origin.y, starView.frame.width, 23)
            print("iphone6")
        default:
            break
        }

        self.addSubview(rateView)
    }
}
