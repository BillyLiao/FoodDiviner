//
//  BeenTableViewCell.swift
//  FoodDiviner
//
//  Created by 廖慶麟 on 2016/5/28.
//  Copyright © 2016年 廖慶麟. All rights reserved.
//

import UIKit
import HCSStarRatingView

class BeenTableViewCell: UITableViewCell {

    @IBOutlet weak var rtName: UILabel!
    @IBOutlet weak var beenDate: UILabel!
    @IBOutlet weak var rtImageView: UIImageView!
    @IBOutlet weak var starView: HCSStarRatingView!
    
    var restaurant: Restaurant!{
        didSet{
            updateUI()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyle.None
        rtImageView.layer.cornerRadius = rtImageView.frame.size.width/2
        rtImageView.clipsToBounds = true
    }
    
    private func updateUI(){
        rtName.text = restaurant.name
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        beenDate.text = dateFormatter.stringFromDate(restaurant.lastBeenDate)

        self.rtImageView.sd_setImageWithURL(NSURL(string:"http://api-server.jqemsuerdm.ap-northeast-1.elasticbeanstalk.com/images/\(restaurant.restaurant_id)"), placeholderImage: UIImage(named:"imagePlaceHolder"))

        self.setRating(restaurant.userRating as Float)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    private func setRating(rate: Float){
        starView.enabled = false
        starView.tintColor = UIColor(red: 255.0/255.0, green: 106.0/255.0, blue: 79.0/255.0, alpha: 1.0)
        starView.maximumValue = 5
        starView.minimumValue = 0
        starView.value = CGFloat(rate)
    }

}
