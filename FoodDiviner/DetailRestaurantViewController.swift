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
    
    func go() {
        
    }
    
    func isFromMain() {
        let likeBtn = UIButton()
        likeBtn.heightAnchor.constraintEqualToConstant(70).active = true
        likeBtn.widthAnchor.constraintEqualToConstant(70).active = true
        likeBtn.imageView?.image = UIImage(named: "Collect")
        
        let dislikeBtn = UIButton()
        dislikeBtn.heightAnchor.constraintEqualToConstant(70).active = true
        dislikeBtn.widthAnchor.constraintEqualToConstant(70).active = true
        dislikeBtn.imageView?.image = UIImage(named: "Cancel")
        
        let takeBtn = UIButton()
        takeBtn.heightAnchor.constraintEqualToConstant(70).active = true
        takeBtn.widthAnchor.constraintEqualToConstant(70).active = true
        takeBtn.imageView?.image = UIImage(named: "Take")
        
        let stackView = UIStackView()
        
        stackView.center.x = self.view.frame.width/2
        stackView.center.y = self.view.frame.height - 90
        stackView.axis = UILayoutConstraintAxis.Horizontal
        stackView.distribution = UIStackViewDistribution.EqualSpacing
        stackView.alignment = UIStackViewAlignment.Center
        stackView.spacing = 50
        
        stackView.addArrangedSubview(dislikeBtn)
        stackView.addArrangedSubview(takeBtn)
        stackView.addArrangedSubview(likeBtn)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)
        stackView.backgroundColor = UIColor.blueColor()
        print(stackView.frame.origin.x)
        print(stackView.frame.origin.y)
    }
    
    func isFromBeen() {
        
    }
    
    func isFromLike() {
        
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


