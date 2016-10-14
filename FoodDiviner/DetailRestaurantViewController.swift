//
//  DetailRestaurantViewController.swift
//  FoodDiviner
//
//  Created by 廖慶麟 on 2016/6/21.
//  Copyright © 2016年 廖慶麟. All rights reserved.
//

import UIKit
import FDRatingView
import SDWebImage

class DetailRestaurantViewController: UIViewController {
    
    var restaurant: Restaurant! = nil
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var stackView2: UIStackView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var restImage: UIImageView!
    @IBOutlet weak var restName: UILabel! 
    //@IBOutlet weak var starView: FDRatingView!
    @IBOutlet weak var restDistance: UILabel!
    @IBOutlet weak var restCuisine: UILabel!
    @IBOutlet weak var restScen: UILabel!
    @IBOutlet weak var restOrder: UILabel!
    @IBOutlet weak var restPrice: UILabel!
    @IBOutlet weak var restPhone: UILabel!
    @IBOutlet weak var restTime: UILabel!
    @IBOutlet weak var restAddre: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        scrollView.frame = self.view.frame
        scrollView.contentSize = CGSizeMake(self.view.frame.width, self.view.frame.height*1.5)
        let rateView = FDRatingView(frame: CGRectMake(0, 0, stackView2.frame.width/2, stackView2.frame.height), style: .Star, numberOfElements: 5, fillValue: self.restaurant.avgRating as! Float, color: UIColor(red: 255.0/255.0, green: 106.0/255.0, blue: 79.0/255.0, alpha: 1.0), lineWidth: 0.7, spacing: 3)
        //rateView.heightAnchor.constraintEqualToConstant(starView.frame.height).active = true
        //rateView.widthAnchor.constraintEqualToConstant(starView.frame.width).active = true
        stackView2.addSubview(rateView)
        
        backButton.layer.cornerRadius = backButton.frame.width/2
    }
    
    override func viewWillAppear(animated: Bool) {
        //TODO: Implement distance, tags, rating, image
        //TODO: If Image isn't loaded yet, show activity indicator
        if restaurant != nil {
            restName.text = restaurant.name
            restCuisine.text = restaurant.cuisine
            restScen.text = restaurant.scenario
            restOrder.text = restaurant.order
            restPrice.text = restaurant.price
            //TODO: Only show time today

            restAddre.text = restaurant.address
            
            // If phone or time is Empty, then show "無此資訊"
            if let phone = restaurant.phone {
                restPhone.text = restaurant.phone
            }else {
                restPhone.text = "無此資訊"
            }
            
            if let time = restaurant.time{
                restTime.text = time
            }else {
                restTime.text = "無此資訊"
            }
            
            
            if let imageData = restaurant.photo {
                restImage.image = UIImage(data: imageData)
            }else {
                if let image_id = restaurant.image_id {
                    restImage.sd_setImageWithURL(NSURL(string:"http://flask-env.ansdqhgbnp.us-west-2.elasticbeanstalk.com/images/\(image_id)"), placeholderImage: UIImage(named:"imagePlaceHolder"))
                }
            }
            
        }
    }
    
    func viewDidAppear() {
        
    }
    
    @IBAction func backToMain(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func like() {
        
    }
    
    func take() {
    
    }
    
    func dislike() {
        
    }
    
    func delete() {
        
    }
    
    func isFromMain() {
        let likeBtn = UIButton(frame: CGRectMake(0, 0, 55, 55))
        likeBtn.setImage(UIImage(named: "Collect"), forState: .Normal)
        likeBtn.frame.origin.y = self.view.frame.height-70
        likeBtn.center.x = self.view.frame.width/4
        
        let dislikeBtn = UIButton(frame: CGRectMake(0, 0, 55, 55))
        dislikeBtn.setImage(UIImage(named: "Cancel"), forState: .Normal)
        dislikeBtn.frame.origin.y = self.view.frame.height-70
        dislikeBtn.center.x = self.view.frame.width/4*3
        
        
        let takeBtn = UIButton(frame: CGRectMake(0, 0, 55, 55))
        takeBtn.setImage(UIImage(named: "Take"), forState: .Normal)
        takeBtn.frame.origin.y = self.view.frame.height-70
        takeBtn.center.x = self.view.frame.width/2
        
        self.scrollView.addSubview(likeBtn)
        self.scrollView.addSubview(dislikeBtn)
        self.scrollView.addSubview(takeBtn)
    }
    
    func isFromLike() {
        let deleteBtn = UIButton(frame: CGRectMake(0, 0, 55, 55))
        deleteBtn.setImage(UIImage(named: "Delete"), forState: .Normal)
        deleteBtn.frame.origin.y = self.view.frame.height-70
        deleteBtn.center.x = self.view.frame.width/3
        
        let takeBtn = UIButton(frame: CGRectMake(0, 0, 55, 55))
        takeBtn.setImage(UIImage(named: "Take"), forState: .Normal)
        takeBtn.frame.origin.y = self.view.frame.height-70
        takeBtn.center.x = self.view.frame.width/3*2
        
        self.scrollView.addSubview(deleteBtn)
        self.scrollView.addSubview(takeBtn)
    }

    func isFromBeen() {
        let takeBtn = UIButton(frame: CGRectMake(0, 0, 55, 55))
        takeBtn.setImage(UIImage(named: "Take"), forState: .Normal)
        takeBtn.frame.origin.y = self.view.frame.height-70
        takeBtn.center.x = self.view.frame.width/2
        
        self.scrollView.addSubview(takeBtn)
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


