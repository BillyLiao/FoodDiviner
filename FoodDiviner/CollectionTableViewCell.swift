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
    var rateView: FDRatingView!
    var rating: Float!
    let deviceHelper = DeviceHelper()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        rtImageView.layer.cornerRadius = rtImageView.frame.size.width/2
        rtImageView.clipsToBounds = true
        rtImageView.layer.shouldRasterize = true

        rateView = FDRatingView(frame: self.starView.frame, style: .Star, numberOfElements: 5, fillValue: 5, color: UIColor(red: 255.0/255.0, green: 106.0/255.0, blue: 79.0/255.0, alpha: 1.0), lineWidth: 0.7, spacing: 1)
        self.addSubview(rateView)

        self.selectionStyle = UITableViewCellSelectionStyle.None
    }

    override func setHighlighted(highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setRating(rating: Float!) {
        rateView = FDRatingView(frame: self.starView.frame, style: .Star, numberOfElements: 5, fillValue: rating, color: UIColor(red: 255.0/255.0, green: 106.0/255.0, blue: 79.0/255.0, alpha: 1.0), lineWidth: 0.7, spacing: 1)
    }
}
