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
    
    private func updateUI(){
        rtName.text = restaurant.name
        cltTime.text = String(restaurant.collectTime)
        if let image_id = restaurant.image_id{
            self.rtImageView.sd_setImageWithURL(NSURL(string:"http://flask-env.ansdqhgbnp.us-west-2.elasticbeanstalk.com/images/\(image_id)"), placeholderImage: UIImage(named:"imagePlaceHolder"))
        }else {
            self.rtImageView.sd_setImageWithURL(NSURL(string:"http://flask-env.ansdqhgbnp.us-west-2.elasticbeanstalk.com/images/"), placeholderImage: UIImage(named:"imagePlaceHolder"))
        }
        self.setRating(restaurant.avgRating as Float)
    }
    
    private func setRating(rating: Float!) {
        rateView = FDRatingView(frame: self.starView.frame, style: .Star, numberOfElements: 5, fillValue: rating, color: UIColor(red: 255.0/255.0, green: 106.0/255.0, blue: 79.0/255.0, alpha: 1.0), lineWidth: 0.7, spacing: 1)
    }
}
