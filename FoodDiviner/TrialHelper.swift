//
//  TrialHelper.swift
//  FoodDiviner
//
//  Created by 廖慶麟 on 2016/10/5.
//  Copyright © 2016年 廖慶麟. All rights reserved.
//

import Foundation
import ZLSwipeableViewSwift
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
            let takeAction = UIAlertAction.init(title: "出發", style: .Default, handler: { (takeAction) in
                completionBlock(true)
            })
            alertViewController.addAction(takeAction)
            
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
            let dislikeAction = UIAlertAction.init(title: "沒興趣", style: .Default, handler: { (action) in
                completionBlock(true)
            })
            alertViewController.addAction(dislikeAction)
            
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

    func ifSwipedNeedTrial(inDirection direction: Direction) -> Bool{
        switch direction {
        case Direction.Left:
            return user.boolForKey(cardViewDidSwipedLeftBefore)
        case Direction.Right:
            return user.boolForKey(cardViewDidSwipedRightBefore)
        case Direction.Up:
            return user.boolForKey(cardViewDidSwipedUpBefore)
        default:
            break
        }
        return false
    }
    
    func cardViewDidSwiped(inDirection inDirection: Direction,completionBlock: Bool -> ()) {
        switch inDirection {
        case Direction.Left:
            if user.boolForKey(cardViewDidSwipedLeftBefore) == false {
                user.setBool(true, forKey: cardViewDidSwipedLeftBefore)
                let alertViewController = UIAlertController(title: "沒興趣嗎    ？", message: "將圖片拖曳至左側代表你對這家餐廳沒有興趣。", preferredStyle: .Alert)
                let cancelAction = UIAlertAction.init(title: "取消", style: .Cancel, handler: { (cancelAction) in
                    completionBlock(false)
                })
                alertViewController.addAction(cancelAction)
                let dislikeAction = UIAlertAction.init(title: "沒興趣", style: .Default, handler: { (dislikeAction) in
                    completionBlock(true)
                })
                alertViewController.addAction(dislikeAction)
                
                self.viewController?.presentViewController(alertViewController, animated: true, completion: nil)
            }
            
        case Direction.Right:
            if user.boolForKey(cardViewDidSwipedRightBefore) == false {
                user.setBool(true, forKey: cardViewDidSwipedRightBefore)
                let alertViewController = UIAlertController(title: "讚?", message: "將圖片拖曳至右側代表你對這家餐廳按讚。", preferredStyle: .Alert)
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
        case Direction.Up:
            if user.boolForKey(cardViewDidSwipedUpBefore) == false {
                user.setBool(true, forKey: cardViewDidSwipedUpBefore)
                let alertViewController = UIAlertController(title: "馬上去?", message: "將圖片拖曳至上方代表你現在就要出發去吃這家餐廳。", preferredStyle: .Alert)
                let cancelAction = UIAlertAction.init(title: "取消", style: .Cancel, handler: { (cancelAction) in
                    completionBlock(false)
                })
                alertViewController.addAction(cancelAction)
                let takeAction = UIAlertAction.init(title: "出發", style: .Default, handler: { (takeAction) in
                    completionBlock(true)
                })
                alertViewController.addAction(takeAction)
                
                self.viewController?.presentViewController(alertViewController, animated: true, completion: nil)
            }
        default:
            break
        }
    }
    
    func didEnterAdvancedSearchViewController() {
        if user.boolForKey(didUseAdvanceSearchBefore) == false {
            user.setBool(true, forKey: didUseAdvanceSearchBefore)
            let alertViewController = UIAlertController(title: "進階搜尋", message: "幫助你更快搜尋到你的一餐^^", preferredStyle: .Alert)
            let yesAction = UIAlertAction.init(title: "確定", style: .Default, handler: nil)
            alertViewController.addAction(yesAction)
            self.viewController?.presentViewController(alertViewController, animated: true, completion: nil)
        }
    }
    
    func didEnterCollectTableView() {
        if user.boolForKey(didEnterCTVBefore) == false {
            user.setBool(true, forKey: didEnterCTVBefore)
            let alertViewController = UIAlertController(title: "收藏區", message: "所有你點讚過的餐廳都在這裡！", preferredStyle: .Alert)
            let yesAction = UIAlertAction.init(title: "瞭解", style: .Default, handler: nil)
            alertViewController.addAction(yesAction)
            self.viewController?.presentViewController(alertViewController, animated: true, completion: nil)
        }
    }
    
    func didEnterRatingTableView() {
        if user.boolForKey(didEnterRTVBefore) == false {
            user.setBool(true, forKey: didEnterRTVBefore)
            let alertViewController = UIAlertController(title: "尚未評分", message: "所有你去過但尚未評分的餐廳都在這裡！", preferredStyle: .Alert)
            let yesAction = UIAlertAction.init(title: "瞭解", style: .Default, handler: nil)
            alertViewController.addAction(yesAction)
            self.viewController?.presentViewController(alertViewController, animated: true, completion: nil)
        }
    }
    
    func didEnterBeenTableView() {
        if user.boolForKey(didEnterBTVBefore) == false {
            user.setBool(true, forKey: didEnterBTVBefore)
            let alertViewController = UIAlertController(title: "評分完畢", message: "所有你評分過的餐廳都在這裡！", preferredStyle: .Alert)
            let yesAction = UIAlertAction.init(title: "瞭解", style: .Default, handler: nil)
            alertViewController.addAction(yesAction)
            self.viewController?.presentViewController(alertViewController, animated: true, completion: nil)
        }
    }
}
