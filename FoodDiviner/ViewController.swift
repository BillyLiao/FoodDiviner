//
//  ViewController.swift
//  FoodDiviner
//
//  Created by 廖慶麟 on 2016/5/17.
//  Copyright © 2016年 廖慶麟. All rights reserved.
//

import UIKit
import RealmSwift
import SwiftyJSON
import NVActivityIndicatorView
import CoreLocation
import SDWebImage
import ZLSwipeableViewSwift

class ViewController: UIViewController, WebServiceDelegate, CLLocationManagerDelegate{
    
    let cellIdentifier = "restaurantCell"
    let loadIndicator: NVActivityIndicatorView = NVActivityIndicatorView(frame: CGRectMake(0, 0, 90, 90), type: .BallScaleMultiple, color: UIColor(red: 255.0/255.0, green: 106.0/255.0, blue: 79.0/255.0, alpha: 1.0))
    var run: Int = 1
    
    @IBOutlet weak var dislikeButton: UIButton!
    @IBOutlet weak var reloadButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var takeButton: UIButton!
    
    enum state {
        case beforeTrial
        case afterTrial
    }
    var restaurants: [Restaurant]? {
        didSet{
            restaurantIndex = 0
            restaurantView.loadViews()
        }
    }
    
    let user = NSUserDefaults()
    var stateNow = state.beforeTrial
    var user_trial = NSMutableDictionary()
    var locationManager: CLLocationManager!
    var manager: APIManager!
    var trialHelper: TrialHelper!
    var restaurantView: ZLSwipeableView!
    var restaurantIndex = 0
    var currentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager = APIManager()
        manager.delegate = self
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        trialHelper = TrialHelper.init(viewController: self)

        if user.valueForKey("user_id") == nil {
            stateNow = state.beforeTrial
        }else {
            stateNow = state.afterTrial
        }
        
        switch stateNow {
        case .beforeTrial:
            print("Before Trial.")
            setTrial()
        case .afterTrial:
            print("After Trial.")
            loadIndicator.startAnimation()
            lockButtons(true)
            manager.getRestRecom()
        default:
            break
        }
        
        restaurantView = ZLSwipeableView()
        restaurantView.frame = CGRect(origin: CGPointZero, size: CGSize(width: UIScreen.mainScreen().bounds.width - 16 , height: UIScreen.mainScreen().bounds.height * (2/3)))
        restaurantView.center.x = self.view.frame.width/2
        restaurantView.frame.origin.y = 15
        restaurantView.allowedDirection = [.Left, .Right, .Up]
        restaurantView.numberOfActiveView = UInt(5)
        restaurantView.numberOfHistoryItem = UInt(1)
        self.view.addSubview(restaurantView)
        
        self.loadIndicator.center = self.view.center
        self.loadIndicator.center.y -= 60
        self.view.addSubview(self.loadIndicator)
        
        restaurantView.didSwipe = {cardView, inDirection, directionVector in
            let view = cardView as! RestaurantView
            let restaurant = view.restaurant
            
            switch inDirection {
            case Direction.Left:
                if self.user.objectForKey(self.trialHelper.cardViewDidSwipedLeftBefore) as! Bool == true {
                    self.manager.postUserChoice(restaurant.restaurant_id, decision: "decline", run: self.run)
                    
                    // Request new data when last restaurants did swipe.
                    if restaurant.restaurant_id == self.restaurants?.last?.restaurant_id {
                        self.loadIndicator.startAnimation()
                        self.lockButtons(true)
                        if self.user.valueForKey("user_id") == nil {
                            self.manager.signUp(self.user.valueForKey("fb_id") as! String, user_trial: self.user_trial, name: self.user.valueForKey("name") as! String, gender: self.user.valueForKey("gender") as! String)
                        }
                        self.stateNow = state.afterTrial
                    }
                    return
                }
            case Direction.Right:
                if self.user.objectForKey(self.trialHelper.cardViewDidSwipedRightBefore) as! Bool == true {
                    self.manager.postUserChoice(restaurant.restaurant_id, decision: "accept", run: self.run)
                    
                    if RealmHelper.isRestaurantExist(restaurant) {
                        print("Right, update restaurant")
                        RealmHelper.addRestaurantCollectionTime(restaurant)
                    }else {
                        print("Right, add restaurant")
                        restaurant.status = 1
                        restaurant.collectTime = 1
                        RealmHelper.addRestaurant(restaurant)
                    }
                    
                    // Request new data when last restaurants did swipe.
                    if restaurant.restaurant_id == self.restaurants?.last?.restaurant_id {
                        self.loadIndicator.startAnimation()
                        self.lockButtons(true)
                        if self.user.valueForKey("user_id") == nil {
                            self.manager.signUp(self.user.valueForKey("fb_id") as! String, user_trial: self.user_trial, name: self.user.valueForKey("name") as! String, gender: self.user.valueForKey("gender") as! String)
                        }
                        self.stateNow = state.afterTrial
                    }
                    return
                }
            case Direction.Up:
                if self.user.objectForKey(self.trialHelper.cardViewDidSwipedUpBefore) as! Bool == true {
                    self.manager.postUserChoice(restaurant.restaurant_id, decision: "accept", run: self.run)
                    
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
                    
                    // Request new data when last restaurants did swipe.
                    if restaurant.restaurant_id == self.restaurants?.last?.restaurant_id {
                        self.loadIndicator.startAnimation()
                        self.lockButtons(true)
                        if self.user.valueForKey("user_id") == nil {
                            self.manager.signUp(self.user.valueForKey("fb_id") as! String, user_trial: self.user_trial, name: self.user.valueForKey("name") as! String, gender: self.user.valueForKey("gender") as! String)
                        }
                        self.stateNow = state.afterTrial
                    }
                    return
                }
            default:
                break
            }
            
            self.trialHelper.cardViewDidSwiped(inDirection: inDirection, completionBlock: { (action) in
                if action == true {
                    switch self.stateNow {
                    case .afterTrial:
                        switch inDirection {
                        case Direction.Right:
                            self.manager.postUserChoice(restaurant.restaurant_id, decision: "accept", run: self.run)
                            
                            if RealmHelper.isRestaurantExist(restaurant) {
                                print("Right, update restaurant")
                                RealmHelper.addRestaurantCollectionTime(restaurant)
                            }else {
                                print("Right, add restaurant")
                                restaurant.status = 1
                                restaurant.collectTime = 1
                                RealmHelper.addRestaurant(restaurant)
                            }
                            
                        case Direction.Left:
                            self.manager.postUserChoice(restaurant.restaurant_id, decision: "decline", run: self.run)
                            
                        case Direction.Up:
                            self.manager.postUserChoice(restaurant.restaurant_id, decision: "accept", run: self.run)
                            
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
                        
                        // Request new data when last restaurants did swipe.
                        if restaurant.restaurant_id == self.restaurants?.last?.restaurant_id {
                            self.run = self.run + 1
                            self.loadIndicator.startAnimation()
                            self.lockButtons(true)
                            self.manager.getRestRecom()
                        }
                    case .beforeTrial:
                        switch inDirection {
                        case Direction.Right:
                            self.user_trial.setObject(true, forKey: "\(restaurant.restaurant_id)")
                        case Direction.Left:
                            self.user_trial.setObject(false, forKey: "\(restaurant.restaurant_id)")
                        case Direction.Up:
                            self.user_trial.setObject(false, forKey: "\(restaurant.restaurant_id)")
                        default:
                            break
                        }
                        
                        // Request new data when last restaurants did swipe.
                        if restaurant.restaurant_id == self.restaurants?.last?.restaurant_id {
                            self.loadIndicator.startAnimation()
                            self.lockButtons(true)
                            if self.user.valueForKey("user_id") == nil {
                                self.manager.signUp(self.user.valueForKey("fb_id") as! String, user_trial: self.user_trial, name: self.user.valueForKey("name") as! String, gender: self.user.valueForKey("gender") as! String)
                            }
                            self.stateNow = state.afterTrial
                        }
                    }
                } else {
                    print("------")
                    print(self.restaurantView.numberOfActiveView)
                    print(self.restaurantView.activeViews().count)
                    self.restaurantView.rewind()
                    print("------")
                    print(self.restaurantView.numberOfActiveView)
                    print(self.restaurantView.activeViews().count)
                }
            })
        }
        
        restaurantView.didTap = {view, atLocation in
            let destinationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("DetailRestaurantViewController") as! DetailRestaurantViewController
            guard let restaurant = (view as! RestaurantView).restaurant else { return }
            
            destinationController.restaurant = restaurant
            destinationController.isFromMain()
            destinationController.onDeletion { (restaurant: Restaurant, takeOrNot: String) in
                switch takeOrNot {
                case "like":
                    self.restaurantView.swipeTopView(inDirection: .Right)
                case "nope":
                    self.restaurantView.swipeTopView(inDirection: .Left)
                case "take":
                    self.restaurantView.swipeTopView(inDirection: .Up)
                default:
                    break
                }
            }
            
            self.presentViewController(destinationController, animated: true, completion: nil)
        }
        
        restaurantView.swiping = {view, atLocation, translation in
            let restaurantView = view as! RestaurantView
            restaurantView.respondToTranslation(translation)
        }
        restaurantView.didEnd = {view, atLocation in
            let restaurantView = view as! RestaurantView
            restaurantView.clearStickers()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        restaurantView.nextView = {
            return self.nextCardView()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        run = 1
    }
    
    func nextCardView() -> UIView? {
        if restaurants?.count == 0 {
            return nil
        }
        
        if restaurantIndex >= restaurants?.count {
            return nil
        }
        
        let cardView = RestaurantView(frame: restaurantView.bounds ,restaurant: restaurants![restaurantIndex])
        cardView.setRatingView(restaurants![restaurantIndex].avgRating as! Float)
        restaurantIndex += 1
        
        return cardView
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
                var tempRestaurants: [Restaurant] = []
                if jsonObj != JSON.null {
                    for i in 0..<jsonObj.count {
                        var restaurant = Restaurant(json: jsonObj[i])
                        tempRestaurants.append(restaurant)
                    }
                    restaurants = tempRestaurants
                }else {
                    print("Couldn't get json from file, make sure that file contains valid json.")
                }
            } catch let err as NSError {
                print(err.localizedDescription)
            }
        } else {
            print("Invalid filename/path")
        }
    }
    
    func requestFailed(e: NSError?) {
        let alertController = UIAlertController(title: "嗯...嗯...", message: "真是個大凶兆，讓我再仔細占卜一番?我想確認確認..", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "再算一次", style: .Default) { (result) in
            self.manager.getRestRecom()
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
        var tempRestaurnts: [Restaurant] = []
        if let data = r {
            for element in data {
                let jsonObj = JSON(element)
                let restaurant = Restaurant(json: jsonObj)
                tempRestaurnts.append(restaurant)
            }
        }
        self.restaurants = tempRestaurnts
    }
    
    func userDidSignUp(user_id: NSNumber) {
        user.setValue(user_id, forKey: "user_id")
        manager.getRestRecom()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        var userLocation:CLLocation = locations[0]
        user.setObject(userLocation.coordinate.latitude, forKey: "lat")
        user.setObject(userLocation.coordinate.longitude, forKey: "lng")
    }
    
    // Take the restaurant
    @IBAction func take(sender: AnyObject) {
        let takeSticker = UIImageView(state: "take")
        takeSticker.center.x = self.view.frame.width/2
        takeSticker.center.y = self.view.frame.height/3
        self.view.addSubview(takeSticker)
        
        if user.objectForKey(trialHelper.takeDidTappedBefore) as! Bool == true {
            takeSticker.startAppearing({
                self.restaurantView.swipeTopView(inDirection: .Up)
            })
            return
        }
        
        trialHelper.takeBtnDidTapped { (action) in
            if action == true {
                takeSticker.startAppearing {
                    self.restaurantView.swipeTopView(inDirection: .Up)
                }
            }else{
                takeSticker.removeFromSuperview()
            }
        }
    }
    
    // Collect the restaurant
    @IBAction func like(sender: AnyObject) {
        let likeSticker = UIImageView(state: "like")
        likeSticker.center.x = self.view.frame.width/2
        likeSticker.center.y = self.view.frame.height/3
        self.view.addSubview(likeSticker)
        
        if user.objectForKey(trialHelper.likeDidTappedBefore) as! Bool == true {
            likeSticker.startAppearing({ 
                self.restaurantView.swipeTopView(inDirection: .Right)
            })
            return
        }
        
        trialHelper.likeBtnDidTapped { (action) in
            if action == true {
                likeSticker.startAppearing {
                    self.restaurantView.swipeTopView(inDirection: .Right)
                }
            }else {
                likeSticker.removeFromSuperview()
            }
        }
    }
    
    // Dismiss the restaurant
    @IBAction func dislike(sender: AnyObject) {
        let nopeSticker = UIImageView(state: "nope")
        nopeSticker.center.x = self.view.frame.width/2
        nopeSticker.center.y = self.view.frame.height/3
        self.view.addSubview(nopeSticker)
        
        if user.objectForKey(trialHelper.nopeDidTappedBefore) as! Bool == true {
            nopeSticker.startAppearing({ 
                self.restaurantView.swipeTopView(inDirection: .Left)
            })
            return
        }
        
        trialHelper.nopeBtnDidTapped { (action) in
            if action == true {
                nopeSticker.startAppearing {
                    self.restaurantView.swipeTopView(inDirection: .Left)
                }
            }else {
                nopeSticker.removeFromSuperview()
            }
        }
    }
    
    // Reload the data from internet
    @IBAction func reload(sender: AnyObject) {
        //Clear the screen first
        restaurantView.discardViews()
        self.manager.getRestRecom()
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

extension UIImage {
    public func imageRotatedByDegrees(degrees: CGFloat, flip: Bool) -> UIImage {
        let radiansToDegrees: (CGFloat) -> CGFloat = {
            return $0 * (180.0 / CGFloat(M_PI))
        }
        
        let degreesToRadians: (CGFloat) -> CGFloat = {
            return $0 / 180.0 * CGFloat(M_PI)
        }
        
        // calculate the size of the rotated view's containing box for our drawing space
        let rotatedViewBox = UIView(frame: CGRect(origin: CGPointZero, size: size))
        let t = CGAffineTransformMakeRotation(degreesToRadians(degrees))
        rotatedViewBox.transform = t
        let rotatedSize = rotatedViewBox.frame.size
        
        // Create the bitmap context
        UIGraphicsBeginImageContext(rotatedSize)
        let bitmap = UIGraphicsGetCurrentContext()
        
        // Move the origin to the middle of the image so we will rotate and scale around the center
        CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2)
        
        // Rotate the image context
        CGContextRotateCTM(bitmap, degreesToRadians(degrees))
        
        // Now, draw the rotated/scaled image into the context
        var yFlip: CGFloat
        
        if(flip){
            yFlip = CGFloat(-1.0)
        }else {
            yFlip = CGFloat(1.0)
        }
        
        CGContextScaleCTM(bitmap, yFlip, -1.0)
        CGContextDrawImage(bitmap, CGRectMake(-size.width / 2, -size.height / 2, size.width, size.height), CGImage)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}

extension UIImageView {
    public convenience init(state: String){
        self.init(frame: CGRectMake(0, 0, 250, 0))
        
        self.alpha = 0
        self.contentMode = .ScaleAspectFill
        
        switch  state {
        case "like":
            self.image = UIImage(named: "likeSticker")?.imageRotatedByDegrees(-20, flip: false)
        case "nope":
            self.image = UIImage(named: "nopeSticker")?.imageRotatedByDegrees(20, flip: false)
        case "take":
            self.image = UIImage(named: "takeSticker")?.imageRotatedByDegrees(-20, flip: false)
        default:
            break
        }
    }
    
    public func startAppearing(completion: () -> Void) {
        UIView.animateWithDuration(0.1, animations: {
            self.alpha = 1
        }) { (success) in
            completion()
            self.appearingDidEnd()
        }
    }
    
    private func appearingDidEnd() {
        self.removeFromSuperview()
    }
}
