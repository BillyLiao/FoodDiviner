//
//  RatingViewController.swift
//  FoodDiviner
//
//  Created by 廖慶麟 on 2016/7/12.
//  Copyright © 2016年 廖慶麟. All rights reserved.
//

import UIKit
import HCSStarRatingView

class RatingViewController: UIViewController {

    @IBOutlet weak var ratingView: HCSStarRatingView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var restaurantName: UILabel!
    @IBOutlet weak var restaurantImage: UIImageView!
    
    var restaurant: Restaurant!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        backBtn.layer.cornerRadius = backBtn.frame.width/2
        backBtn.clipsToBounds = true
        
        let borderColor = UIColor(red: 255.0/255.0, green: 106.0/255.0, blue: 79.0/255.0, alpha: 1.0).CGColor
        
        submitBtn.layer.cornerRadius = 5
        submitBtn.layer.borderWidth = 1
        submitBtn.layer.borderColor = borderColor
        
        restaurantName.text = restaurant.name
        if let image_id = restaurant.image_id{
            if restaurant.photo != nil {
                restaurantImage.sd_setImageWithURL(NSURL(string:"http://flask-env.ansdqhgbnp.us-west-2.elasticbeanstalk.com/images/\(image_id)"), placeholderImage: UIImage(named:"imagePlaceHolder"))
            }
        }else {
            restaurantImage.image = UIImage(named: "imagePlaceHolder")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backToCollection(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func addTags(sender: AnyObject) {
    }
    
    @IBAction func submitRating(sender: AnyObject) {
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
