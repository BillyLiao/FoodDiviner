//
//  BeenTableViewCell.swift
//  FoodDiviner
//
//  Created by 廖慶麟 on 2016/5/28.
//  Copyright © 2016年 廖慶麟. All rights reserved.
//

import UIKit
import FDRatingView

class BeenTableViewCell: UITableViewCell {

    @IBOutlet weak var rtName: UILabel!
    @IBOutlet weak var beenDate: UILabel!
    @IBOutlet weak var rtImageView: UIImageView!
    @IBOutlet weak var starView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyle.None
        rtImageView.layer.cornerRadius = rtImageView.frame.size.width/2
        rtImageView.clipsToBounds = true
        
        let rateView = FDRatingView(frame: CGRectMake(starView.frame.origin.x, starView.frame.origin.y, starView.frame.width, starView.frame.height), style: .Star, numberOfElements: 5, fillValue: 3.67, color: UIColor(red: 255.0/255.0, green: 106.0/255.0, blue: 79.0/255.0, alpha: 1.0), lineWidth: 0.7, spacing: 3)
        rateView.heightAnchor.constraintEqualToConstant(starView.frame.height).active = true
        rateView.widthAnchor.constraintEqualToConstant(starView.frame.width).active = true
        self.addSubview(rateView)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
