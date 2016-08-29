//
//  AppDelegate.swift
//  FoodDiviner
//
//  Created by 廖慶麟 on 2016/5/17.
//  Copyright © 2016年 廖慶麟. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import RealmSwift
import TETinderPageView

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var pageView: TETinderPageView?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    
        var fbLogin:Bool = FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        // If FBSDKAccessToken.currentAccessToken != nil, then skip the login view(set root view to ViewController)
        
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, gender, email, age_range"]).startWithCompletionHandler({ (connection, result, error) -> Void in
                if error == nil {
                    print(result)
                }
            })
            
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
            pageView.view.backgroundColor = UIColor.redColor()
            self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
            self.window?.rootViewController = pageView
            self.window?.makeKeyAndVisible()
        }else {
            self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
            self.window?.rootViewController = fbLoginViewController()
            self.window?.makeKeyAndVisible()
        }
        
        // Needed for FB Login
        return fbLogin
    }
    
    // Add this to automatically redirect from white web page to App & Access FBSDKAccessToken.currentAccessToken()
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
        
    }


    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        FBSDKAppEvents.activateApp()
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
    }

    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "csie.FoodDiviner" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()



}

