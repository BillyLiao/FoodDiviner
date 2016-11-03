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
import MapKit

class DetailRestaurantViewController: UIViewController {
    
    
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
    
    var restaurant: Restaurant! = nil
    let user = NSUserDefaults()
    typealias restaurantDeleted = (Restaurant, String)-> ()
    var restaurantWillDeleted: restaurantDeleted?
    var trialHelper: TrialHelper!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        scrollView.frame = self.view.frame
        scrollView.contentSize = CGSizeMake(self.view.frame.width, self.view.frame.height*1.5)
        let rateView = FDRatingView(frame: CGRectMake(0, 0, stackView2.frame.width/2, stackView2.frame.height), style: .Star, numberOfElements: 5, fillValue: self.restaurant.avgRating as! Float, color: UIColor(red: 255.0/255.0, green: 106.0/255.0, blue: 79.0/255.0, alpha: 1.0), lineWidth: 0.7, spacing: 3)
        stackView2.addSubview(rateView)
        backButton.layer.cornerRadius = backButton.frame.width/2
        
        distanceFromUserLocation()
        trialHelper = TrialHelper(viewController: self)
    }
    
    override func viewWillAppear(animated: Bool) {
        //TODO: Implement tags
        //TODO: If Image isn't loaded yet, show activity indicator
        if restaurant != nil {
            restName.text = restaurant.name
            restCuisine.text = restaurant.cuisine
            restScen.text = restaurant.scenario
            restOrder.text = restaurant.order
            restPrice.text = restaurant.price
            restAddre.text = restaurant.address
            //TODO: Only show time today
            
            // If phone or time is Empty, then show "無此資訊"
            restPhone.text = restaurant.phone ?? "無此資訊"
            restTime.text = restaurant.time ?? "無此資訊"
            
            if let imageData = restaurant.photo {
                restImage.image = UIImage(data: imageData)
            }else {
                if let image_id = restaurant.image_id {
                    restImage.sd_setImageWithURL(NSURL(string:"http://api-server.jqemsuerdm.ap-northeast-1.elasticbeanstalk.com/images/\(image_id)"), placeholderImage: UIImage(named:"imagePlaceHolder"))
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
        let likeSticker = UIImageView(state: "like")
        likeSticker.center.x = self.restImage.frame.width/2
        likeSticker.center.y = self.restImage.frame.height/2
        self.view.addSubview(likeSticker)
        
        if user.objectForKey(trialHelper.likeDidTappedBefore) as! Bool == true {
            if let restaurantDeletedBlock = self.restaurantWillDeleted {
                restaurantDeletedBlock(self.restaurant, "like")
            }
            likeSticker.startAppearing({
                self.dismissViewControllerAnimated(false, completion: nil)
            })
            return
        }
        
        trialHelper.likeBtnDidTapped { (action) in
            if action == true {
                if let restaurantDeletedBlock = self.restaurantWillDeleted {
                    restaurantDeletedBlock(self.restaurant, "like")
                }
                likeSticker.startAppearing {
                    self.dismissViewControllerAnimated(false, completion: nil)
                }
            }else {
                likeSticker.removeFromSuperview()
            }
        }
    }
    
    func takeFromMain() {
        let takeSticker = UIImageView(state: "take")
        takeSticker.center.x = self.restImage.frame.width/2
        takeSticker.center.y = self.restImage.frame.height/2
        self.view.addSubview(takeSticker)
        
        if user.objectForKey(trialHelper.takeDidTappedBefore) as! Bool == true {
            if let restaurantDeletedBlock = self.restaurantWillDeleted {
                restaurantDeletedBlock(self.restaurant, "take")
            }
            takeSticker.startAppearing({
                self.dismissViewControllerAnimated(false, completion: nil)
            })
            return
        }
        
        trialHelper.takeBtnDidTapped { (action) in
            if action == true {
                if let restaurantDeletedBlock = self.restaurantWillDeleted {
                    restaurantDeletedBlock(self.restaurant, "take")
                }
                takeSticker.startAppearing {
                    self.dismissViewControllerAnimated(false, completion: nil)
                }
            }else {
                takeSticker.removeFromSuperview()
            }
        }
    }
    
    func dislike() {
        let nopeSticker = UIImageView(state: "nope")
        nopeSticker.center.x = self.restImage.frame.width/2
        nopeSticker.center.y = self.restImage.frame.height/2
        self.view.addSubview(nopeSticker)
        
        if user.objectForKey(trialHelper.nopeDidTappedBefore) as! Bool == true {
            if let restaurantDeletedBlock = self.restaurantWillDeleted {
                restaurantDeletedBlock(self.restaurant, "nope")
            }
            nopeSticker.startAppearing({
                self.dismissViewControllerAnimated(false, completion: nil)
            })
            return
        }
        
        trialHelper.nopeBtnDidTapped { (action) in
            if action == true {
                if let restaurantDeletedBlock = self.restaurantWillDeleted {
                    restaurantDeletedBlock(self.restaurant, "nope")
                }
                nopeSticker.startAppearing {
                    self.dismissViewControllerAnimated(false, completion: nil)
                }
            }else {
                nopeSticker.removeFromSuperview()
            }
        }
    }
    
    func remove() {
        RealmHelper.deleteRestaurant(restaurant)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func take() {
        RealmHelper.addRestaurantBeenTime(restaurant)
        RealmHelper.updateRestaurant(restaurant, status: 2)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func isFromMain() {
        
        let dislikeBtn = UIButton(frame: CGRectMake(0, 0, 55, 55))
        dislikeBtn.setImage(UIImage(named: "Cancel"), forState: .Normal)
        dislikeBtn.frame.origin.y = self.view.frame.height-70
        dislikeBtn.center.x = self.view.frame.width/4
        dislikeBtn.addTarget(self, action: #selector(DetailRestaurantViewController.dislike), forControlEvents: .TouchUpInside)
        
        let likeBtn = UIButton(frame: CGRectMake(0, 0, 55, 55))
        likeBtn.setImage(UIImage(named: "Collect"), forState: .Normal)
        likeBtn.frame.origin.y = self.view.frame.height-70
        likeBtn.center.x = self.view.frame.width/4*3
        likeBtn.addTarget(self, action: #selector(DetailRestaurantViewController.like), forControlEvents: .TouchUpInside)
        
        let takeBtn = UIButton(frame: CGRectMake(0, 0, 55, 55))
        takeBtn.setImage(UIImage(named: "Take"), forState: .Normal)
        takeBtn.frame.origin.y = self.view.frame.height-70
        takeBtn.center.x = self.view.frame.width/2
        takeBtn.addTarget(self, action: #selector(DetailRestaurantViewController.takeFromMain), forControlEvents: .TouchUpInside)
        
        self.scrollView.addSubview(likeBtn)
        self.scrollView.addSubview(dislikeBtn)
        self.scrollView.addSubview(takeBtn)
    }
    
    func isFromLike() {
        let deleteBtn = UIButton(frame: CGRectMake(0, 0, 55, 55))
        deleteBtn.setImage(UIImage(named: "Delete"), forState: .Normal)
        deleteBtn.frame.origin.y = self.view.frame.height-70
        deleteBtn.center.x = self.view.frame.width/3
        deleteBtn.addTarget(self, action: #selector(DetailRestaurantViewController.remove), forControlEvents: .TouchUpInside)
        
        let takeBtn = UIButton(frame: CGRectMake(0, 0, 55, 55))
        takeBtn.setImage(UIImage(named: "Take"), forState: .Normal)
        takeBtn.frame.origin.y = self.view.frame.height-70
        takeBtn.center.x = self.view.frame.width/3*2
        takeBtn.addTarget(self, action: #selector(DetailRestaurantViewController.take), forControlEvents: .TouchUpInside)
        
        self.scrollView.addSubview(deleteBtn)
        self.scrollView.addSubview(takeBtn)
    }

    func isFromBeen() {
        let takeBtn = UIButton(frame: CGRectMake(0, 0, 55, 55))
        takeBtn.setImage(UIImage(named: "Take"), forState: .Normal)
        takeBtn.frame.origin.y = self.view.frame.height-70
        takeBtn.center.x = self.view.frame.width/2
        takeBtn.addTarget(self, action: #selector(DetailRestaurantViewController.take), forControlEvents: .TouchUpInside)
        
        self.scrollView.addSubview(takeBtn)
    }
    
    func onDeletion(deletionBlock: restaurantDeleted) {
        self.restaurantWillDeleted = deletionBlock
    }
    
    func distanceFromUserLocation() {
        let geocoder = CLGeocoder()
        var location: CLLocation!
        
        geocoder.geocodeAddressString(restaurant.address) { (placemarks, error) in
            if error != nil {
                print("Error: \(error)")
            }else {
                if let placemark = placemarks?.first {
                    location = placemark.location
                }
                var distanceInMeters: CLLocationDistance!
                distanceInMeters = location.distanceFromLocation(CLLocation(latitude: self.user.valueForKey("lat") as! Double, longitude: self.user.valueForKey("lng") as! Double))
                let distanceInKilometers: CLLocationDistance!
                distanceInKilometers = distanceInMeters/1000
                self.restDistance.text = String(format: "約%.2fkm", distanceInKilometers)
            }
        }
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


