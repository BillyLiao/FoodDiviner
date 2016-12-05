//
//  LoginViewController.swift
//  FoodDiviner
//
//  Created by 廖慶麟 on 2016/6/22.
//  Copyright © 2016年 廖慶麟. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import AVKit
import AVFoundation
import TETinderPageView
import RealmSwift
import AFNetworking
import Firebase

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate{

    var loginImageView: UIImageView!
    let baseURL = "http://api-server.jqemsuerdm.ap-northeast-1.elasticbeanstalk.com/"
    let manager = AFHTTPSessionManager()
    let user = NSUserDefaults.standardUserDefaults()
    let authIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        authIndicator.center = self.view.center
        self.view.addSubview(authIndicator)
        
        loginImageView = UIImageView(frame: self.view.frame)
        loginImageView.image = UIImage(named: "loginBG.jpg")
        loginImageView.contentMode = .ScaleAspectFill
        self.view.addSubview(loginImageView)

        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.bounds
        blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        view.addSubview(blurEffectView)

        let welcomeLabel = UILabel(frame: CGRectMake(0, 100, self.view.bounds.size.width, 100))
        welcomeLabel.text = "Food Diviner"
        welcomeLabel.textColor = UIColor.whiteColor()
        welcomeLabel.font = UIFont.systemFontOfSize(40)
        welcomeLabel.textAlignment = NSTextAlignment.Center
        self.view.addSubview(welcomeLabel)
        
        let emailTextField = TextField(frame: CGRectMake(0, 0, 240, 40))
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSForegroundColorAttributeName : UIColor.whiteColor()])
        emailTextField.layer.borderWidth = 1
        emailTextField.layer.borderColor = UIColor.whiteColor().CGColor
        emailTextField.center.x = self.view.center.x
        emailTextField.center.y = self.view.center.y - 40
        self.view.addSubview(emailTextField)
        
        let passwordTextField = TextField(frame: CGRectMake(0, 0, 240, 40))
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName : UIColor.whiteColor()])
        passwordTextField.layer.borderWidth = 1
        passwordTextField.layer.borderColor = UIColor.whiteColor().CGColor
        passwordTextField.center.x = self.view.center.x
        passwordTextField.center.y = self.view.center.y + 8
        self.view.addSubview(passwordTextField)
        
        let fbLoginBtn = FBSDKLoginButton(frame: CGRectMake(0, 0, 240, 40))
        fbLoginBtn.readPermissions = ["public_profile", "email", "user_friends"]
        fbLoginBtn.delegate = self
        fbLoginBtn.center.x = self.view.center.x
        fbLoginBtn.center.y = self.view.center.y + 83
        fbLoginBtn.layer.borderColor = UIColor.whiteColor().CGColor
        fbLoginBtn.layer.borderWidth = 2
        fbLoginBtn.titleLabel!.font = UIFont.systemFontOfSize(24)
        fbLoginBtn.tintColor = UIColor.whiteColor()
        fbLoginBtn.setTitle("Fuck you ", forState: UIControlState.Normal)
        self.view.addSubview(fbLoginBtn)
        
        let loginBtn = UIButton(frame: CGRectMake(0, 0, 240, 40))
        loginBtn.center.x = self.view.center.x
        loginBtn.center.y = self.view.center.y + 131
        loginBtn.layer.borderColor = UIColor.lightGrayColor().CGColor
        loginBtn.layer.borderWidth = 2
        loginBtn.titleLabel!.font = UIFont.systemFontOfSize(24)
        loginBtn.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        loginBtn.setTitle("Login", forState: .Normal)
        self.view.addSubview(loginBtn)
        
        let signupBtn = UIButton(frame: CGRectMake(0, 0, 240, 40))
        signupBtn.center.x = self.view.center.x
        signupBtn.center.y = self.view.center.y + 179
        signupBtn.layer.borderColor = UIColor.lightGrayColor().CGColor
        signupBtn.layer.borderWidth = 2
        signupBtn.titleLabel!.font = UIFont.systemFontOfSize(24)
        signupBtn.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        signupBtn.setTitle("Signup", forState: .Normal)
        self.view.addSubview(signupBtn)

        // Do any additional setup after loading the view.
    }


    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Facebook login
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if error == nil {
            print("Login Complete.")
            self.authIndicator.startAnimating()
            //First time login or relogin on the device.
            setUserData()
        }else{
            print(error.localizedDescription)
        }
    }
    
    func showPageView(){
        let mainView = UIStoryboard(name: "Main", bundle: nil)
        let choosingPage = mainView.instantiateViewControllerWithIdentifier("ViewController")
        let collectionPage = mainView.instantiateViewControllerWithIdentifier("CollectionViewController")
        let advanceSearchPage = mainView.instantiateViewControllerWithIdentifier("advanceSearchViewController")
        
        let viewControllers = NSArray(array: [advanceSearchPage, choosingPage, collectionPage])
        
        let pageView = TETinderPageView(viewControllers: viewControllers as [AnyObject], buttonImages: [UIImage(named: "Setting")!, UIImage(named: "Restaurant")!, UIImage(named: "Collection")!])
        
        // side icons
        pageView.offscreenLeftButtonSpecifics.color = UIColor(red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0)
        pageView.offscreenRightButtonSpecifics.color = UIColor(red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0)
        pageView.rightButtonSpecifics.color = UIColor(red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0)
        pageView.leftButtonSpecifics.color = UIColor(red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0)
        
        // center icon
        pageView.centerButtonSpecifics.color = UIColor(red: 255.0/255.0, green: 106.0/255.0, blue: 79.0/255.0, alpha: 1.0)
        pageView.centerButtonSpecifics.size = CGSize(width: 35.0, height: 35.0)
        pageView.selectedIndex = 1
        
        self.presentViewController(pageView, animated: true, completion: nil)
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        FBSDKAccessToken.setCurrentAccessToken(nil)
        FBSDKProfile.setCurrentProfile(nil)
        print("User logged out...")
    }
    
    func setUserData(){
        FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, gender, email, picture.type(large)"]).startWithCompletionHandler({ (connection, results, error) -> Void in
            if error == nil {
                //Save the user data
                self.user.setObject(results.objectForKey("id"), forKey: "fb_id")
                self.user.setObject(results.objectForKey("name"), forKey: "name")
                if results.objectForKey("gender") as! String == "male" {
                    self.user.setObject("M", forKey: "gender")
                }else if results.objectForKey("gender") as! String == "female" {
                    self.user.setObject("F", forKey: "gender")
                }else {
                    self.user.setObject("", forKey: "gender")
                }
                self.user.setObject(results.objectForKey("email"), forKey: "email")
                self.user.setObject(nil, forKey: "user_id")
                self.user.setObject(false, forKey: "advance")
                if let imageURL = results.objectForKey("picture")?.valueForKey("data")?.valueForKey("url") as? String {
                    let data = NSData.init(contentsOfURL: NSURL(string: imageURL)!)
                    self.user.setObject(data, forKey: "picture")
                }
                self.userAuth()
            }
        })

    }
    
    // Check if user register before or not.
    func userAuth(){
        let url = "\(baseURL)/test"
        manager.responseSerializer = AFJSONResponseSerializer()
        manager.requestSerializer = AFJSONRequestSerializer()
        let params = NSDictionary(dictionary: ["fb_id" : user.objectForKey("fb_id") as! String])
        manager.POST(url, parameters: params, success: { (task, resObject) in
                self.user.setObject(resObject?.objectForKey("user_id"), forKey: "user_id")
                print("Auth Succeed: User_id : \(resObject?.objectForKey("user_id"))")
                //Only show page view after knowing user register before or not.
                self.showPageView()
                self.authIndicator.stopAnimating()
            }) { (task, err) in
                print("Auth Failed: \(err.localizedDescription)")
                self.user.setObject(nil, forKey: "user_id")
                //Only show page view after knowing user register before or not.
                self.showPageView()
                self.authIndicator.stopAnimating()
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


