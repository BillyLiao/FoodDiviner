//
//  CollectionViewController.swift
//  FoodDiviner
//
//  Created by 廖慶麟 on 2016/5/27.
//  Copyright © 2016年 廖慶麟. All rights reserved.
//

import UIKit
import RealmSwift
import SDWebImage
class CollectionViewController: UIViewController, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource{

    var CollectTV: UITableView?
    var JudgeTV: UITableView?
    var BeenTV: UITableView?
    var trialHelper = TrialHelper.init()
    
    var collectRestaurants: Results<Restaurant>? {
        //Add observer to reload tableview
        didSet{
            CollectTV?.reloadData()
        }
    }
    var judgeRestaurants: Results<Restaurant>? {
        didSet{
            JudgeTV?.reloadData()
        }
    }
    var beenRestaurants: Results<Restaurant>? {
        didSet{
            BeenTV?.reloadData()
        }
    }
    
    var scrollView: UIScrollView?
    var scroller: UIView!
    var page: Int = 0{
        didSet {
            changeButtonState()
            switch page {
            case 0:
                trialHelper.didEnterCollectTableView()
            case 1:
                trialHelper.didEnterRatingTableView()
            case 2:
                trialHelper.didEnterBeenTableView()
            default:
                break
            }
        }
    }
    
    var switchToCollectBtn: UIButton!
    var switchToJudgeBtn: UIButton!
    var switchToBeenBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /* Set three buttons below the navigation bar */
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
        
        
        CollectTV = UITableView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height-120), style: .Plain)
        let collectNib = UINib(nibName: "CollectionTableViewCell", bundle: nil)
        CollectTV!.registerNib(collectNib, forCellReuseIdentifier: "Cell")
        CollectTV!.tableFooterView = UIView()
        CollectTV!.rowHeight = 80
        CollectTV!.dataSource = self
        CollectTV!.delegate = self
        
        JudgeTV = UITableView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height-120), style: .Plain)
        let judgeNib = UINib(nibName: "CollectionTableViewCell", bundle: nil)
        JudgeTV!.registerNib(judgeNib, forCellReuseIdentifier: "Cell")
        JudgeTV!.tableFooterView = UIView()
        JudgeTV!.frame.origin.x += JudgeTV!.frame.width
        JudgeTV!.rowHeight = 80
        JudgeTV!.dataSource = self
        JudgeTV!.delegate = self
        
        BeenTV = UITableView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height-120), style: .Plain)
        let beenNib = UINib(nibName: "BeenTableViewCell", bundle: nil)
        BeenTV!.registerNib(beenNib, forCellReuseIdentifier: "Cell")
        BeenTV!.tableFooterView = UIView()
        BeenTV!.frame.origin.x += BeenTV!.frame.width*2
        BeenTV!.rowHeight = 80
        BeenTV!.dataSource = self
        BeenTV!.delegate = self
    
        scrollView = UIScrollView(frame: CGRect(x: 0, y:55, width: self.view.frame.width, height: self.view.frame.height))
        
        scrollView!.addSubview(CollectTV!)
        scrollView!.addSubview(JudgeTV!)
        scrollView!.addSubview(BeenTV!)

        scrollView?.contentSize = CGSize(width: CollectTV!.frame.width*3, height: CollectTV!.frame.height)
        scrollView?.pagingEnabled = true
        scrollView?.delegate = self
        self.view.addSubview(scrollView!)
        
        /*Set the scoller*/
        let scrollerRect = CGRect(x: 0, y: 45, width: self.view.frame.width/3, height: 1)
        scroller = UIView(frame: scrollerRect)
        scroller.backgroundColor = UIColor(red: 255.0/255.0, green: 106.0/255.0, blue: 79.0/255.0, alpha: 1)
        self.view.addSubview(scroller)
        
        //Init trial helper
        trialHelper = TrialHelper.init(viewController: self)
    }
    
    override func viewWillAppear(animated: Bool) {
        collectRestaurants = RealmHelper.retriveRestaurantByStatus(1)
        judgeRestaurants = RealmHelper.retriveRestaurantByStatus(2)
        beenRestaurants = RealmHelper.retriveRestaurantByStatus(3)
        
        // Init pageIndex, in order to call the alertViewController successfully.
        page = 0
    }
    
    override func viewDidLayoutSubviews() {

    }
    
    override func viewDidAppear(animated: Bool) {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let ratio = scrollView.contentOffset.x / scrollView.contentSize.width
        if ratio == 0 {
            return 
        }
        let scrollRect = CGRect(x: ratio * self.view.frame.width, y: 50, width: self.view.frame.width/3, height: 1)
        scroller.frame = scrollRect
        if ratio<0.25{
            page = 0
        }else if ratio>0.25 && ratio<0.5{
            page = 1
        }else{
            page = 2
        }
    }
 
    func showCollectTable(){
        scrollView?.scrollRectToVisible(CollectTV!.frame, animated: true)
        page = 0
    }
    
    func showJudgeTable(){
        scrollView?.scrollRectToVisible(JudgeTV!.frame, animated: true)
        page = 1
    }
    
    func showBeenTable(){
        scrollView?.scrollRectToVisible(BeenTV!.frame, animated: true)
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
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView{
        case CollectTV!:
            return collectRestaurants!.count
        case JudgeTV!:
            return judgeRestaurants!.count
        case BeenTV!:
            return beenRestaurants!.count
        default:
            break
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch  tableView {
        case CollectTV!:
            let cell = CollectTV!.dequeueReusableCellWithIdentifier("Cell") as! CollectionTableViewCell
            cell.restaurant = collectRestaurants![indexPath.row]
            return cell
            
        case JudgeTV!:
            let cell = JudgeTV!.dequeueReusableCellWithIdentifier("Cell") as! CollectionTableViewCell
            cell.restaurant = judgeRestaurants![indexPath.row]
            return cell

        case BeenTV!:
            let cell = BeenTV!.dequeueReusableCellWithIdentifier("Cell") as! BeenTableViewCell
            cell.restaurant = beenRestaurants![indexPath.row]
            return cell
 
        default:
            break
        }
        return UITableViewCell()
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch tableView {
        case CollectTV!:
            let destinationController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("DetailRestaurantViewController") as! DetailRestaurantViewController
            destinationController.restaurant = collectRestaurants![indexPath.row]
            destinationController.isFromLike()
            self.presentViewController(destinationController, animated: true, completion: nil)
        case JudgeTV!:
            let destinationController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("RatingViewController") as! RatingViewController
            destinationController.restaurant = judgeRestaurants![indexPath.row]
            self.presentViewController(destinationController, animated: true, completion: nil)
        case BeenTV!:
            let destinationController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("DetailRestaurantViewController") as! DetailRestaurantViewController
            destinationController.restaurant = beenRestaurants![indexPath.row]
            destinationController.isFromBeen()
            self.presentViewController(destinationController, animated: true, completion: nil)
        default:
            break
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
