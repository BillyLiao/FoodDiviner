//
//  TrialHelper.swift
//  FoodDiviner
//
//  Created by 廖慶麟 on 2016/10/5.
//  Copyright © 2016年 廖慶麟. All rights reserved.
//

import Foundation
import UIKit

class TrialHelper {
    
    let user = NSUserDefaults()
    weak var viewController: UIViewController?
    
    let likeDidTappedBefore = "likeDidTappedBefore"
    let takeDidTappedBefore = "takeDidTappedBefore"
    let nopeDidTappedBefore = "nopeDidTappedBefore"
    let cardViewDidSwipedLeftBefore = "cardViewDidSwipedLeftBefore"
    let cardViewDidSwipedRightBefore = "cardViewDidSwipedRightBefore"
    let cardViewDidSwipedUpBefore = "cardViewDidSwipedUpBefore"
    let didUseAdvanceSearchBefore = "didUserAdvancceSearchBefore"
    let didEnterCTVBefore = "didEnterCollectionTableViewBefore"
    let didEnterRTVBefore = "didEnterRatingTableViewBefore"
    let didEnterBTVBefore = "didEnterBeenTableViewBefore"
    let removeDidTappedBefore = "removeDidTappedBefore"
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    init() {
        
    }
    
    func likeBtnDidTapped(completionBlock: Bool -> ()) {
        if user.objectForKey(likeDidTappedBefore) as! Bool == false {
            user.setObject(true, forKey: likeDidTappedBefore)
            let alertViewController = UIAlertController(title: "讚?", message: "點一下愛心代表你對這家餐廳按讚。", preferredStyle: .Alert)
            let cancelAction = UIAlertAction.init(title: "取消", style: .Cancel, handler: { (cancelAction) in
                completionBlock(false)
            })
            alertViewController.addAction(cancelAction)
            let likeAction = UIAlertAction.init(title: "點讚", style: .Default, handler: { (likeAction) in
                completionBlock(true)
            })
            alertViewController.addAction(likeAction)
            
            self.viewController?.presentViewController(alertViewController, animated: true, completion: nil)
        }
    }
    
    func takeBtnDidTapped(completionBlock: Bool -> ()) {
        if user.objectForKey(takeDidTappedBefore) as! Bool == false {
            user.setObject(true, forKey: takeDidTappedBefore)
            let alertViewController = UIAlertController(title: "馬上去?", message: "點一下刀叉代表你現在就要出發去吃這家餐廳。", preferredStyle: .Alert)
            let cancelAction = UIAlertAction.init(title: "取消", style: .Cancel, handler: { (cancelAction) in
                completionBlock(false)
            })
            alertViewController.addAction(cancelAction)
            let likeAction = UIAlertAction.init(title: "出發", style: .Default, handler: { (likeAction) in
                completionBlock(true)
            })
            alertViewController.addAction(likeAction)
            
            self.viewController?.presentViewController(alertViewController, animated: true, completion: nil)
        }
    }
    
    func nopeBtnDidTapped(completionBlock: Bool -> ()) {
        if user.objectForKey(nopeDidTappedBefore) as! Bool == false {
            user.setObject(true, forKey: nopeDidTappedBefore)
            let alertViewController = UIAlertController(title: "沒興趣嗎?", message: "點一下 X 代表你對這家餐廳沒有興趣。", preferredStyle: .Alert)
            let cancelAction = UIAlertAction.init(title: "取消", style: .Cancel, handler: { (cancelAction) in
                completionBlock(false)
            })
            alertViewController.addAction(cancelAction)
            let likeAction = UIAlertAction.init(title: "沒興趣", style: .Default, handler: { (likeAction) in
                completionBlock(true)
            })
            alertViewController.addAction(likeAction)
            
            self.viewController?.presentViewController(alertViewController, animated: true, completion: nil)
        }
    }
    
    func removeBtnDidTapped(completionBlock: Bool -> ()){
        if user.objectForKey(removeDidTappedBefore) as! Bool == false {
            user.setObject(true, forKey: removeDidTappedBefore)
            let alertViewController = UIAlertController(title: "確定刪除？", message: "點一下垃圾桶代表你想將這家餐廳從列表中刪除。", preferredStyle: .Alert)
            let cancelAction = UIAlertAction.init(title: "取消", style: .Cancel, handler: { (cancelAction) in
                completionBlock(false)
            })
            alertViewController.addAction(cancelAction)
            let likeAction = UIAlertAction.init(title: "刪除", style: .Default, handler: { (likeAction) in
                completionBlock(true)
            })
            alertViewController.addAction(likeAction)
            
            self.viewController?.presentViewController(alertViewController, animated: true, completion: nil)
        }
    }

    
    func cardViewDidSwipedLeft(completionBlock: Bool -> ()) {
    }
    
    func cardViewDidSwipedRight(completionBlock: Bool -> ()) {

    }
    
    func cardViewDidSwipedUp(completionBlock: Bool -> ()) {
        
    }
    
    func didEnterAdvancedSearchViewController() {
        if user.objectForKey(didUseAdvanceSearchBefore) as! Bool == false {            
            user.setObject(true, forKey: didUseAdvanceSearchBefore)
            let alertViewController = UIAlertController(title: "進階搜尋", message: "幫助你更快搜尋到你的一餐^^", preferredStyle: .Alert)
            let yesAction = UIAlertAction.init(title: "確定", style: .Default, handler: nil)
            alertViewController.addAction(yesAction)
            self.viewController?.presentViewController(alertViewController, animated: true, completion: nil)
        }
    }
    
    func didEnterCollectTableView() {
        if user.objectForKey(didEnterCTVBefore) as! Bool == false {
            user.setObject(true, forKey: didEnterCTVBefore)
            let alertViewController = UIAlertController(title: "收藏區", message: "所有你點讚過的餐廳都在這裡！", preferredStyle: .Alert)
            let yesAction = UIAlertAction.init(title: "瞭解", style: .Default, handler: nil)
            alertViewController.addAction(yesAction)
            self.viewController?.presentViewController(alertViewController, animated: true, completion: nil)
        }
    }
    
    func didEnterRatingTableView() {
        if user.objectForKey(didEnterRTVBefore) as! Bool == false {
            user.setObject(true, forKey: didEnterRTVBefore)
            let alertViewController = UIAlertController(title: "尚未評分", message: "所有你去過但尚未評分的餐廳都在這裡！", preferredStyle: .Alert)
            let yesAction = UIAlertAction.init(title: "瞭解", style: .Default, handler: nil)
            alertViewController.addAction(yesAction)
            self.viewController?.presentViewController(alertViewController, animated: true, completion: nil)
        }
    }
    
    func didEnterBeenTableView() {
        if user.objectForKey(didEnterBTVBefore) as! Bool == false {
            user.setObject(true, forKey: didEnterBTVBefore)
            let alertViewController = UIAlertController(title: "收藏區", message: "所有你點讚過的餐廳都會出現在這裡！", preferredStyle: .Alert)
            let yesAction = UIAlertAction.init(title: "瞭解", style: .Default, handler: nil)
            alertViewController.addAction(yesAction)
            self.viewController?.presentViewController(alertViewController, animated: true, completion: nil)
        }
    }
}