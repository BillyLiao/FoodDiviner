//
//  ViewController.swift
//  FoodDiviner
//
//  Created by 廖慶麟 on 2016/5/17.
//  Copyright © 2016年 廖慶麟. All rights reserved.
//

import UIKit
import SPTinderView
import RealmSwift
import SwiftyJSON
import NVActivityIndicatorView
import CoreLocation
import SDWebImage

class ViewController: UIViewController, WebServiceDelegate, CLLocationManagerDelegate{
    
    var restaurantView: SPTinderView!
    let cellIdentifier = "restaurantCell"
    let loadIndicator: NVActivityIndicatorView = NVActivityIndicatorView(frame: CGRectMake(0, 0, 90, 90), type: .BallScaleMultiple, color: UIColor(red: 255.0/255.0, green: 106.0/255.0, blue: 79.0/255.0, alpha: 1.0))
    var run: Int = 1
    
    @IBOutlet weak var dislikeButton: UIButton!
    @IBOutlet weak var reloadButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var takeButton: UIButton!
    
    enum state {
        case beforetrial
        case afterTrial
    }
    
    var manager: APIManager!
    var restaurants: [Restaurant]? = []
    let user = NSUserDefaults()
    var stateNow = state.beforetrial
    var user_trial = NSMutableDictionary()
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager = APIManager()
        manager.delegate = self
        restaurantView = SPTinderView()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()

        if user.valueForKey("user_id") == nil {
            stateNow = state.beforetrial
        }else {
            stateNow = state.afterTrial
        }
        
        switch stateNow {
        case .beforetrial:
            print("Before Trial.")
            setTrial()
        case .afterTrial:
            print("After Trial.")
            loadIndicator.startAnimation()
            lockButtons(true)
            manager.getRestRecom(user.valueForKey("user_id") as! NSNumber, advance: user.valueForKey("advance") as! Bool, preferPrices: user.valueForKey("preferPrices") as? [Int], weather: user.valueForKey("weather") as? String, transport: user.valueForKey("transport") as? String, lat: user.valueForKey("lat") as? Double, lng: user.valueForKey("lng") as? Double)
        default:
            break
        }
        
        restaurantView.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height-180)
        restaurantView.registerClass(RestaurantCell.self, forCellReuseIdentifier: cellIdentifier)
        restaurantView.dataSource = self
        restaurantView.delegate = self
        
        self.loadIndicator.center = self.view.center
        self.loadIndicator.center.y -= 60
        
        self.view.addSubview(self.loadIndicator)
        self.view.addSubview(restaurantView)
    }
    
    override func viewDidAppear(animated: Bool) {
        run = 1
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setTrial(){
        if let path = NSBundle.mainBundle().pathForResource("trialRestaurant", ofType: "json") {
            do {
                let data = try NSData(contentsOfURL: NSURL(fileURLWithPath: path), options: .DataReadingMapped)
                let jsonObj = JSON(data: data)
                if jsonObj != JSON.null {
                    for i in 0..<jsonObj.count {
                        var restaurant = Restaurant()
                        restaurant.restaurant_id = jsonObj[i]["restaurant_id"].int
                        restaurant.name = jsonObj[i]["name"].string
                        restaurant.address = jsonObj[i]["address"].string
                        restaurant.price = jsonObj[i]["price"].string
                        restaurant.phone = jsonObj[i]["phone"].string
                        restaurant.photo = UIImageJPEGRepresentation(UIImage(named: "\(restaurant.name)")!, 0.6)
                        restaurant.time = jsonObj[i]["time"].string
                        restaurant.avgRating = jsonObj[i]["avgRating"].float
                        //TODO: Update data model
                        restaurant.order = jsonObj[i]["order"][0].string
                        restaurant.cuisine = jsonObj[i]["cuisine"][0].string
                        restaurant.scenario = jsonObj[i]["scenario"][0].string
                        restaurant.tags = jsonObj[i]["tags"][0].string
                        
                        // If more than 1 data, append it to the restaurant attributes
                        if jsonObj[i]["order"].count > 1 {
                            for j in 1..<jsonObj[i]["order"].count{
                                restaurant.order = restaurant.order + ", \(jsonObj[i]["order"][j].string!)"
                            }
                        }
                        if jsonObj[i]["cuisine"].count > 1 {
                            for j in 1..<jsonObj[i]["cuisine"].count{
                                restaurant.cuisine = restaurant.cuisine + ", \(jsonObj[i]["cuisine"][j].string!)"
                            }
                        }
                        if jsonObj[i]["scenario"].count > 1 {
                            for j in 1..<jsonObj[i]["scenario"].count{
                                restaurant.scenario = restaurant.scenario + ", \(jsonObj[i]["scenario"][j].string!)"
                            }
                        }
                        if jsonObj[i]["tags"].count > 1 {
                            for j in 1..<jsonObj[i]["tags"].count{
                                restaurant.tags = restaurant.tags + ", \(jsonObj[i]["tags"][j].string!)"
                            }
                        }
                        restaurants?.append(restaurant)
                    }
                }else {
                    print("Couldn't get json from file, make sure that file contains valid json.")
                }
            } catch let err as NSError {
                print(err.localizedDescription)
            }
        } else {
            print("Invalid filename/path")
        }
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.restaurantView.reloadData()
        })
  
    }
    
    func requestFailed(e: NSError?) {
        let alertController = UIAlertController(title: "嗯...嗯...", message: "真是個大凶兆，讓我再仔細占卜一番?我想確認確認..", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "再算一次", style: .Default) { (result) in
            self.manager.getRestRecom(self.user.valueForKey("user_id") as! NSNumber, advance: self.user.valueForKey("advance") as! Bool, preferPrices: self.user.valueForKey("preferPrices") as? [Int], weather: self.user.valueForKey("weather") as? String, transport: self.user.valueForKey("transport") as? String, lat: self.user.valueForKey("lat") as? Double, lng: self.user.valueForKey("lng") as? Double)
        }
        let cancelAction = UIAlertAction(title: "根本神棍", style: .Cancel) { (result) in
            self.loadIndicator.stopAnimation()
        }
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func userRecomGetRequestDidFinished(r: [NSDictionary]?) {
        loadIndicator.stopAnimation()
        lockButtons(false)
        // Clean the temRestaurant array.
        restaurants = []
        if let data = r {
            for element in data {
                let jsonObj = JSON(element)
                
                let restaurant = Restaurant()
                restaurant.address = jsonObj["address"].string
                restaurant.cuisine = jsonObj["cuisine"][0].string
                restaurant.time = jsonObj["hours"].string
                restaurant.name = jsonObj["name"].string
                restaurant.order = jsonObj["ordering"][0].string
                restaurant.phone = jsonObj["phone"].string
                restaurant.price = jsonObj["price"].string
                restaurant.restaurant_id = jsonObj["restaurant_id"].int
                restaurant.scenario = jsonObj["scenario"][0].string
                restaurant.tags = jsonObj["tags"][0].string
                restaurant.image_id = jsonObj["image"][0].string
                restaurant.avgRating = 4
                
                if jsonObj["cuisine"].count > 1 {
                    for j in 1..<jsonObj["cuisine"].count {
                        restaurant.cuisine = restaurant.cuisine + ", \(jsonObj["cuisine"][j].string!)"
                    }
                }
                
                if jsonObj["scenario"].count > 1 {
                    for j in 1..<jsonObj["scenario"].count {
                        restaurant.scenario = restaurant.scenario + ", \(jsonObj["scenario"][j].string!)"
                    }
                }
                
                if jsonObj["tags"].count > 1 {
                    for j in 1..<jsonObj["tags"].count {
                        restaurant.tags = restaurant.tags + ", \(jsonObj["tags"][j].string!)"
                    }
                }
                
                if jsonObj["ordering"].count > 1 {
                    for j in 1..<jsonObj["ordering"].count {
                        restaurant.order = restaurant.order + ", \(jsonObj["ordering"][j].string!)"
                    }
                }
                restaurants?.append(restaurant)
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.restaurantView.reloadData()
        })
    }
    
    func userDidSignUp(user_id: NSNumber) {
        user.setValue(user_id, forKey: "user_id")
        manager.getRestRecom(user.valueForKey("user_id") as! NSNumber, advance: user.valueForKey("advance") as! Bool, preferPrices: user.valueForKey("preferPrices") as? [Int], weather: user.valueForKey("weather") as? String, transport: user.valueForKey("transport") as? String, lat: user.valueForKey("lat") as? Double, lng: user.valueForKey("lng") as? Double)
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        var userLocation:CLLocation = locations[0] 
        user.setObject(userLocation.coordinate.latitude, forKey: "lat")
        user.setObject(userLocation.coordinate.longitude, forKey: "lng")
    }
}

extension ViewController: SPTinderViewDataSource, SPTinderViewDelegate{
    func numberOfItemsInTinderView(view: SPTinderView) -> Int {
        if let restaurants = restaurants {
            return restaurants.count
        }
        return 0
    }
    
    func tinderView(view: SPTinderView, cellAt index: Int) -> SPTinderViewCell? {
        if let cell = restaurantView.dequeueReusableCellWithIdentifier(cellIdentifier) as? RestaurantCell {
            if let restaurant = restaurants?[index] {
                cell.nameLabel.text = restaurant.name
                cell.infoLabel.text = "\(restaurant.cuisine), \(restaurant.price)"
                cell.setRatingView(restaurant.avgRating as! Float
                )
                // Use pod:SDWebImage to download the image from backend
                if let image_id = restaurant.image_id {
                    cell.imageView.sd_setImageWithURL(NSURL(string:"http://api-server.jqemsuerdm.ap-northeast-1.elasticbeanstalk.com/images/\(image_id)"), placeholderImage: UIImage(named:"imagePlaceHolder"), completed: { (image, error, cacheType, url) in
                        restaurant.photo = UIImageJPEGRepresentation(image, 0.6)
                    })
                }else {
                    if let photo = restaurants?[index].photo {
                        cell.imageView.image = UIImage(data: photo)
                    }else {
                        cell.imageView.image = UIImage(named: "imagePlaceHolder")
                    }
                }
                return cell
            }
        }
        return nil
    }
    
    func tinderView(view: SPTinderView, didMoveCellAt index: Int, towards direction: SPTinderViewCellMovement) {
        guard let restaurant = restaurants?[index] else {return}
        restaurant.photo = nil
        switch stateNow{
        case .afterTrial:
            switch direction{
            case .Left:
                manager.postUserChoice(user.valueForKey("user_id") as! NSNumber, restaurant_id: restaurants![index].restaurant_id, decision: "decline", run: run)
            case .Right:
                manager.postUserChoice(user.valueForKey("user_id") as! NSNumber, restaurant_id: restaurants![index].restaurant_id, decision: "accept", run: run)
                if RealmHelper.isRestaurantExist(restaurant) {
                    print("Right, update restaurant")
                    RealmHelper.addRestaurantCollectionTime(restaurant)
                }else {
                    print("Right, add restaurant")
                    restaurant.status = 1
                    restaurant.collectTime = 1
                    RealmHelper.addRestaurant(restaurant)
                }
            case .Top:
                manager.postUserChoice(user.valueForKey("user_id") as! NSNumber, restaurant_id: restaurants![index].restaurant_id, decision: "accept", run: run)
                if RealmHelper.isRestaurantExist(restaurant) {
                    print("Up, update restaurant")
                    RealmHelper.updateRestaurant(restaurant, status: 2)
                    RealmHelper.addRestaurantBeenTime(restaurant)
                }else{
                    print("Up, add restaurant")
                    restaurant.status = 2
                    restaurant.beenTime = 1
                    RealmHelper.addRestaurant(restaurant)
                }
            default:
                break
            }
            // If running out of the cells, then ask for recommendations again!
            if index == 9 {
                run = run + 1
                loadIndicator.startAnimation()
                lockButtons(true)
                manager.getRestRecom(user.valueForKey("user_id") as! NSNumber, advance: user.valueForKey("advance") as! Bool, preferPrices: user.valueForKey("preferPrices") as? [Int], weather: user.valueForKey("weather") as? String, transport: user.valueForKey("transport") as? String, lat: user.valueForKey("lat") as? Double, lng: user.valueForKey("lng") as? Double)
            }
        case .beforetrial:
            switch direction{
            case .Left:
                print("Swipe Left")
                user_trial.setObject(false, forKey: "\(restaurants![index].restaurant_id)")
            case .Right:
                print("Swipe Right")
                user_trial.setObject(true, forKey: "\(restaurants![index].restaurant_id)")
            case .Top:
                print("Swipe Top")
                user_trial.setObject(true, forKey: "\(restaurants![index].restaurant_id)")
            default:
                break
            }
            // If finish the trial, then sign up!
            if index == 4 {
                loadIndicator.startAnimation()
                lockButtons(true)
                if user.valueForKey("user_id") == nil {
                    manager.signUp(user.valueForKey("fb_id") as! String, user_trial: user_trial, name: user.valueForKey("name") as! String, gender: user.valueForKey("gender") as! String)
                }
                stateNow = state.afterTrial
            }
        default:
            break
        }
    }
    
    func tinderView(view: SPTinderView, didTappedCellAt index: Int) {
        let destinationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("DetailRestaurantViewController") as! DetailRestaurantViewController
        //TODO: Pass the data to destinationController
        if let restaurant = restaurants?[index] {
            destinationController.restaurant = restaurant
        }
        destinationController.isFromMain()
        self.presentViewController(destinationController, animated: true, completion: nil)
    }
    
    // Take the restaurant
    @IBAction func take(sender: AnyObject) {
        let firstRestaurant = self.restaurants![0]
        manager.postUserChoice(user.valueForKey("user_id") as! NSNumber, restaurant_id: firstRestaurant.restaurant_id, decision: "accept", run: run)
        if RealmHelper.isRestaurantExist(firstRestaurant) {
            print("Up, update restaurant")
            RealmHelper.updateRestaurant(firstRestaurant, status: 2)
            RealmHelper.addRestaurantBeenTime(firstRestaurant)
        }else{
            print("Up, add restaurant")
            firstRestaurant.status = 2
            firstRestaurant.beenTime = 1
            RealmHelper.addRestaurant(firstRestaurant)
        }
        
        self.restaurants!.removeFirst()
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.restaurantView.reloadData()
        })

        if self.restaurants?.count == 0 {
            run = run + 1
            loadIndicator.startAnimation()
            lockButtons(true)
            manager.getRestRecom(user.valueForKey("user_id") as! NSNumber, advance: user.valueForKey("advance") as! Bool, preferPrices: user.valueForKey("preferPrices") as? [Int], weather: user.valueForKey("weather") as? String, transport: user.valueForKey("transport") as? String, lat: user.valueForKey("lat") as? Double, lng: user.valueForKey("lng") as? Double)
        }
    }
    
    // Collect the restaurant
    @IBAction func like(sender: AnyObject) {
        let firstRestaurant = self.restaurants![0]
        manager.postUserChoice(user.valueForKey("user_id") as! NSNumber, restaurant_id: firstRestaurant.restaurant_id, decision: "accept", run: run)
        
        if RealmHelper.isRestaurantExist(firstRestaurant) {
            print("Right, update restaurant")
            RealmHelper.addRestaurantCollectionTime(firstRestaurant)
        }else {
            print("Right, add restaurant")
            firstRestaurant.status = 1
            firstRestaurant.collectTime = 1
            RealmHelper.addRestaurant(firstRestaurant)
        }
        
        self.restaurants!.removeFirst()
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.restaurantView.reloadData()
        })
        
        if self.restaurants?.count == 0 {
            run = run + 1
            loadIndicator.startAnimation()
            lockButtons(true)
            manager.getRestRecom(user.valueForKey("user_id") as! NSNumber, advance: user.valueForKey("advance") as! Bool, preferPrices: user.valueForKey("preferPrices") as? [Int], weather: user.valueForKey("weather") as? String, transport: user.valueForKey("transport") as? String, lat: user.valueForKey("lat") as? Double, lng: user.valueForKey("lng") as? Double)
        }
    }
    
    // Dismiss the restaurant
    @IBAction func dislike(sender: AnyObject) {
        let firstRestaurant = self.restaurants![0]
        manager.postUserChoice(user.valueForKey("user_id") as! NSNumber, restaurant_id: firstRestaurant.restaurant_id, decision: "decline", run: run)

        self.restaurants!.removeFirst()
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.restaurantView.reloadData()
        })
        
        if self.restaurants?.count == 0 {
            run = run + 1
            loadIndicator.startAnimation()
            lockButtons(true)
            manager.getRestRecom(user.valueForKey("user_id") as! NSNumber, advance: user.valueForKey("advance") as! Bool, preferPrices: user.valueForKey("preferPrices") as? [Int], weather: user.valueForKey("weather") as? String, transport: user.valueForKey("transport") as? String, lat: user.valueForKey("lat") as? Double, lng: user.valueForKey("lng") as? Double)
        }
    }
    
    // Reload the data from internet
    @IBAction func reload(sender: AnyObject) {
        //Clear the screen first
        restaurants = []
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.restaurantView.reloadData()
        })
        
        self.manager.getRestRecom(self.user.valueForKey("user_id") as! NSNumber, advance: self.user.valueForKey("advance") as! Bool, preferPrices: self.user.valueForKey("preferPrices") as? [Int], weather: self.user.valueForKey("weather") as? String, transport: self.user.valueForKey("transport") as? String, lat: self.user.valueForKey("lat") as? Double, lng: self.user.valueForKey("lng") as? Double)
        self.loadIndicator.startAnimation()
        lockButtons(true)
    }
    
    // In case user the buttons when loading
    func lockButtons(lock: Bool){
        if lock == true {
            dislikeButton.enabled = false
            likeButton.enabled = false
            takeButton.enabled = false
            reloadButton.enabled = false
        }else {
            dislikeButton.enabled = true
            likeButton.enabled = true
            takeButton.enabled = true
            reloadButton.enabled = true
        }
    }
}

/*
extension NSLayoutConstraint {
    override public var description: String {
        let id = identifier ?? ""
        return "id: \(id), constant: \(constant)"
    }
}
*/