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
    
    func likeBtnDidTapped() -> Bool{
        if user.objectForKey(likeDidTappedBefore) != nil {
            // Nothing happened.
        }else {
            let alertViewController = UIAlertController(title: "讚?", message: "將圖片拖曳至右側代表你對這家餐廳按讚。", preferredStyle: .Alert)
            let cancelAction = UIAlertAction.init(title: "取消", style: .Cancel, handler: { (cancelAction) in
                return false
            })
            alertViewController.addAction(cancelAction)

            let likeAction = UIAlertAction.init(title: "點讚", style: .Default, handler: { (likeAction) in
                return true
            })
            alertViewController.addAction(likeAction)
            self.viewController?.presentViewController(alertViewController, animated: true, completion: nil)
        }
        
        return false
    }
    
    func takeBtnDidTapped() {
        
    }
    
    func nopeBtnDidTapped() {
        
    }
    
    func cardViewDidSwipedLeft() {
        
    }
    
    func cardViewDidSwipedRight() {
        
    }
    
    func cardViewDidSwipedUp() {
        
    }
    
    func didEnterAdvancedSearchViewController() {
        
    }
    
    func didEnterCollectTableView() {
        
    }
    
    func didEnterRatingTableView() {
        
    }
    
    func didEnterBeenTableView() {
        
    }
}