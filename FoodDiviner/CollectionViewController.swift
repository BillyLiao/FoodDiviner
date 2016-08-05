//
//  CollectionViewController.swift
//  FoodDiviner
//
//  Created by 廖慶麟 on 2016/5/27.
//  Copyright © 2016年 廖慶麟. All rights reserved.
//

import UIKit
import CoreData

class CollectionViewController: UIViewController, UIScrollViewDelegate {
    
    var dataArrayA: [Restaurant] = []
    var dataArrayB: [Restaurant] = []
    var dataArrayC: [Restaurant] = []
    
    var CollectTVC: TableViewController?
    var JudgeTVC: TableViewController?
    var BeenTVC: TableViewController?
    
    var scrollView: UIScrollView?
    var scroller: UIView!
    var page: Int = 0
    
    var switchToCollectBtn: UIButton!
    var switchToJudgeBtn: UIButton!
    var switchToBeenBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        
        CollectTVC = TableViewController(style: .Plain, data: dataArrayA, cellLayout: "CollectionTableViewCell")
        CollectTVC?.tableView.tableFooterView = UIView()
        CollectTVC?.segueIdentifier = "DetailRestaurantViewController"
            
        JudgeTVC = TableViewController(style: .Plain, data: dataArrayB, cellLayout: "CollectionTableViewCell")
        JudgeTVC?.tableView.tableFooterView = UIView()
        JudgeTVC?.segueIdentifier = "RatingViewController"
        
        BeenTVC = TableViewController(style: .Plain, data: dataArrayC, cellLayout: "BeenTableViewCell")
        BeenTVC?.tableView.tableFooterView = UIView()
        BeenTVC?.segueIdentifier = "DetailRestaurantViewController"
        
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 45, width: self.view.frame.width, height: self.view.frame.height))
        self.view.addSubview(scrollView!)
        
        var rectCollect = CGRectMake(0, 10, CollectTVC!.view.frame.width, CollectTVC!.view.frame.height-90)
        CollectTVC!.view.frame = rectCollect
        scrollView?.addSubview(CollectTVC!.view)
        
        var rectJudge = CGRectMake(0, 10, JudgeTVC!.view.frame.width, JudgeTVC!.view.frame.height-90)
        rectJudge.origin.x += rectJudge.size.width
        JudgeTVC!.view.frame = rectJudge
        scrollView?.addSubview(JudgeTVC!.view)
        
        var rectBeen = CGRectMake(0, 10, BeenTVC!.view.frame.width, BeenTVC!.view.frame.height-90)
        rectBeen.origin.x += rectBeen.size.width*2
        BeenTVC!.view.frame = rectBeen
        scrollView?.addSubview(BeenTVC!.view)
        
        scrollView?.contentSize = CGSize(width: rectBeen.size.width*3, height: rectBeen.height)
        scrollView?.pagingEnabled = true
        scrollView?.delegate = self
        
        /* Set three button below the navigation bar */
        switchToCollectBtn = UIButton(frame: CGRect(x: 0, y: 0, width: self.view.frame.width/3, height: 50))
        switchToCollectBtn.setTitle("收藏", forState: .Normal)
        switchToCollectBtn.setTitleColor(UIColor(red: 255.0/255.0, green: 106.0/255.0, blue: 79.0/255.0, alpha: 1), forState: .Normal)
        self.view.addSubview(switchToCollectBtn)
        switchToCollectBtn.addTarget(self, action: "showCollectTable", forControlEvents: .TouchUpInside)
        
        switchToJudgeBtn = UIButton(frame: CGRect(x: self.view.frame.width/3, y: 0, width: self.view.frame.width/3, height: 50))
        switchToJudgeBtn.setTitle("未評分", forState: .Normal)
        switchToJudgeBtn.setTitleColor(UIColor(red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1), forState: .Normal)
        self.view.addSubview(switchToJudgeBtn)
        switchToJudgeBtn.addTarget(self, action: "showJudgeTable", forControlEvents: .TouchUpInside)
        
        switchToBeenBtn = UIButton(frame: CGRect(x: self.view.frame.width*2/3, y: 0, width: self.view.frame.width/3, height: 50))
        switchToBeenBtn.setTitle("曾經去過", forState: .Normal)
        switchToBeenBtn.setTitleColor(UIColor(red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1), forState: .Normal)
        self.view.addSubview(switchToBeenBtn)
        switchToBeenBtn.addTarget(self, action: "showBeenTable", forControlEvents: .TouchUpInside)
        
        /*Set the scoller*/
        let scrollerRect = CGRect(x: 0, y: 50, width: self.view.frame.width/3, height: 1)
        scroller = UIView(frame: scrollerRect)
        scroller.backgroundColor = UIColor(red: 255.0/255.0, green: 106.0/255.0, blue: 79.0/255.0, alpha: 1)
        self.view.addSubview(scroller)
    }
    
    override func viewWillAppear(animated: Bool) {
    }
    
    override func viewDidAppear(animated: Bool) {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadData(){
        let moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let restaurantFetch = NSFetchRequest(entityName: "Restaurant")
        do {
            let fetchedRestaurants = try moc.executeFetchRequest(restaurantFetch) as! [Restaurant]
        
            for restaurant in fetchedRestaurants {
                switch restaurant.status {
                case 1:
                    dataArrayA.append(restaurant)
                case 2:
                    dataArrayB.append(restaurant)
                case 3:
                    dataArrayC.append(restaurant)
                default:
                    break
                }
            }
            
        } catch {
            fatalError("Failed to fetch restaurant: \(error)")
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let ratio = scrollView.contentOffset.x / scrollView.contentSize.width
        let scrollRect = CGRect(x: ratio * self.view.frame.width, y: 50, width: self.view.frame.width/3, height: 1)
        scroller.frame = scrollRect
        if ratio<0.25 {
            page = 0
            changeButtonState()
        }else if ratio>0.25 && ratio<0.5{
            page = 1
            changeButtonState()
        }else {
            page = 2
            changeButtonState()
        }
    }
 
    func showCollectTable(){
        scrollView?.scrollRectToVisible(self.CollectTVC!.view.frame, animated: true)
        page = 0
    }
    
    func showJudgeTable(){
        scrollView?.scrollRectToVisible(self.JudgeTVC!.view.frame, animated: true)
        page = 1
    }
    
    func showBeenTable(){
        scrollView?.scrollRectToVisible(self.BeenTVC!.view.frame, animated: true)
        page = 2
    }
    
    func changeButtonState(){
        if page == 0 {
            switchToCollectBtn.setTitleColor(UIColor(red: 255.0/255.0, green: 106.0/255.0, blue: 79.0/255.0, alpha: 1), forState: .Normal)
            switchToJudgeBtn.setTitleColor(UIColor(red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1), forState: .Normal)
            switchToBeenBtn.setTitleColor(UIColor(red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1), forState: .Normal)
        }else if page == 1 {
            switchToCollectBtn.setTitleColor(UIColor(red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1), forState: .Normal)
            switchToJudgeBtn.setTitleColor(UIColor(red: 255.0/255.0, green: 106.0/255.0, blue: 79.0/255.0, alpha: 1), forState: .Normal)
            switchToBeenBtn.setTitleColor(UIColor(red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1), forState: .Normal)
        }else {
            switchToCollectBtn.setTitleColor(UIColor(red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1), forState: .Normal)
            switchToJudgeBtn.setTitleColor(UIColor(red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1), forState: .Normal)
            switchToBeenBtn.setTitleColor(UIColor(red: 255.0/255.0, green: 106.0/255.0, blue: 79.0/255.0, alpha: 1), forState: .Normal)
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
