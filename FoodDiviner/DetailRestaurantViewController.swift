//
//  DetailRestaurantViewController.swift
//  FoodDiviner
//
//  Created by 廖慶麟 on 2016/6/21.
//  Copyright © 2016年 廖慶麟. All rights reserved.
//

import UIKit
import FDRatingView

class DetailRestaurantViewController: UIViewController {
    
    var restaurant: tempRestaurant! = nil
    var restaurant2: Restaurant! = nil
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var stackView2: UIStackView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var restImage: UIImageView!
    @IBOutlet weak var restName: UILabel! 
    @IBOutlet weak var starView: FDRatingView!
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
        
        let rateView = FDRatingView(frame: CGRectMake(0, 0, starView.frame.width, starView.frame.height), style: .Star, numberOfElements: 5, fillValue: self.restaurant.avgRating, color: UIColor(red: 255.0/255.0, green: 106.0/255.0, blue: 79.0/255.0, alpha: 1.0), lineWidth: 0.7, spacing: 3)
        rateView.heightAnchor.constraintEqualToConstant(starView.frame.height).active = true
        rateView.widthAnchor.constraintEqualToConstant(starView.frame.width).active = true
        stackView2.addSubview(rateView)
        
        backButton.layer.cornerRadius = backButton.frame.width/2
    }
    
    override func viewWillAppear(animated: Bool) {
        //TODO: Implement distance, tags, rating, image
        //TODO: If Image isn't loaded yet, show default image and activity indicator
        if restaurant != nil {
            restName.text = restaurant.name
            restCuisine.text = restaurant.cuisine
            restScen.text = restaurant.scenario
            restOrder.text = restaurant.order
            restPrice.text = restaurant.price
            //TODO: Only show time today
            restTime.text = restaurant.time
            restAddre.text = restaurant.address
        }else {
            restName.text = restaurant2.name
            restCuisine.text = restaurant2.cuisine
            restScen.text = restaurant2.scenario
            restOrder.text = restaurant2.order
            restPrice.text = restaurant2.price
            //TODO: Only show time today
            restTime.text = restaurant2.time
            restAddre.text = restaurant2.address
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


