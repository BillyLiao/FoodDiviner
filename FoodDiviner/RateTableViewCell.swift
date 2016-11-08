//
//  RateTableViewCell.swift
//  FoodDiviner
//
//  Created by 廖慶麟 on 2016/11/8.
//  Copyright © 2016年 廖慶麟. All rights reserved.
//

import UIKit
import FDRatingView

class RateTableViewCell: UITableViewCell {

    @IBOutlet weak var starView: UIView!
    @IBOutlet weak var rtName: UILabel!
    @IBOutlet weak var beenTime: UILabel!
    @IBOutlet weak var rtImageView: UIImageView!
    
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
        
        rateView = FDRatingView(frame: self.starView.frame, style: .Star, numberOfElements: 5, fillValue: 5, color: UIColor(red: 255.0/255.0, green: 106.0/255.0, blue: 79.0/255.0, alpha: 1.0), lineWidth: 0.7, spacing: 1)
        self.addSubview(rateView)
        
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
        beenTime.text = String(restaurant.beenTime)
        if let image_id = restaurant.image_id{
            self.rtImageView.sd_setImageWithURL(NSURL(string:"http://api-server.jqemsuerdm.ap-northeast-1.elasticbeanstalk.com/images/\(image_id)"), placeholderImage: UIImage(named:"imagePlaceHolder"))
        }else {
            self.rtImageView.sd_setImageWithURL(NSURL(string:"http://api-server.jqemsuerdm.ap-northeast-1.elasticbeanstalk.com/images/"), placeholderImage: UIImage(named:"imagePlaceHolder"))
        }
        self.setRating(restaurant.avgRating as Float)
    }
    
    private func setRating(rating: Float!) {
        rateView.removeFromSuperview()
        rateView = FDRatingView(frame: self.starView.frame, style: .Star, numberOfElements: 5, fillValue: rating, color: UIColor(red: 255.0/255.0, green: 106.0/255.0, blue: 79.0/255.0, alpha: 1.0), lineWidth: 0.7, spacing: 1)
        self.addSubview(rateView)
    }
}
