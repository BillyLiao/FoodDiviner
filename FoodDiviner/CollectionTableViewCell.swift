//
//  CollectionTableViewCell.swift
//  FoodDiviner
//
//  Created by 廖慶麟 on 2016/5/28.
//  Copyright © 2016年 廖慶麟. All rights reserved.
//

import UIKit
import HCSStarRatingView

class CollectionTableViewCell: UITableViewCell {

    @IBOutlet weak var rtImageView: UIImageView!
    @IBOutlet weak var cltTime: UILabel!
    @IBOutlet weak var rtName: UILabel!
    @IBOutlet weak var starView: HCSStarRatingView!
    
    var rating: Float!
    let deviceHelper = DeviceHelper()
    var restaurant: Restaurant! {
        didSet{
            updateUI()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        rtImageView.layer.cornerRadius = rtImageView.frame.size.width/2
        rtImageView.clipsToBounds = true
        rtImageView.layer.shouldRasterize = true
        
        self.selectionStyle = .None
        self.selectionStyle = UITableViewCellSelectionStyle.None
    }

    override func setHighlighted(highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    private func updateUI(){
        rtName.text = restaurant.name
        cltTime.text = String(restaurant.collectTime)
        self.rtImageView.sd_setImageWithURL(NSURL(string:"http://api-server.jqemsuerdm.ap-northeast-1.elasticbeanstalk.com/images/\(restaurant.restaurant_id)"), placeholderImage: UIImage(named:"imagePlaceHolder"))

        self.setRating(restaurant.avgRating as Float)
    }
    
    private func setRating(rating: Float!) {
        starView.enabled = false
        starView.tintColor = UIColor(red: 255.0/255.0, green: 106.0/255.0, blue: 79.0/255.0, alpha: 1.0)
        starView.maximumValue = 5
        starView.minimumValue = 0
        starView.value = CGFloat(rating)
    }
}
