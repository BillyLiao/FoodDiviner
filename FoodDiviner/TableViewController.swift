//
//  TableViewController.swift
//  FoodDiviner
//
//  Created by 廖慶麟 on 2016/5/28.
//  Copyright © 2016年 廖慶麟. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    var dataArray: [Restaurant]?
    var cellLayout: String!
    var segueIdentifier: String!
    var chosenIndex = 0
    
    init(style: UITableViewStyle, data: [Restaurant]?, cellLayout: String) {
        super.init(style: style)
        dataArray = data
        self.cellLayout = cellLayout
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 80
        let nib = UINib(nibName: cellLayout, bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "Cell")
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataArray!.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        if cellLayout == "CollectionTableViewCell" {
            let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! CollectionTableViewCell
            cell.rtImageView.image = UIImage(named: "RestaurantTest")
            cell.rtName.text = dataArray![indexPath.row].name
            cell.cltTime.text = "\(dataArray![indexPath.row].collectTime)"
            cell.setRating(dataArray![indexPath.row].avgRating as Float)
            // Configure the cell...
        }else if cellLayout == "BeenTableViewCell" {
            let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
                as! BeenTableViewCell
            cell.rtImageView.image = UIImage(named: "RestaurantTest")
            cell.rtName.text = dataArray![indexPath.row].name
            cell.beenDate.text = "7/23"
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //TODO: Pass the real data into the Controller
        //Warning: PresentViewController
        print(segueIdentifier)
        switch segueIdentifier {
        case "RatingViewController":
            let destinationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("RatingViewController") as! RatingViewController
            self.presentViewController(destinationController, animated: true, completion: nil)
        case "DetailRestaurantViewController":
            let destinationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("DetailRestaurantViewController") as! DetailRestaurantViewController
            if let restaurant = dataArray?[indexPath.row] {
                destinationController.restaurant2 = restaurant
            }
            self.presentViewController(destinationController, animated: true, completion: nil)
        default:
            print("Unvalid segue identifier")
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
