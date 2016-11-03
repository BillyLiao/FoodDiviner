//
//  AdavanceSearchViewController.swift
//  FoodDiviner
//
//  Created by 廖慶麟 on 2016/5/30.
//  Copyright © 2016年 廖慶麟. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class AdavanceSearchViewController: UIViewController, NVActivityIndicatorViewable{

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var btn0: UIButton!
    @IBOutlet weak var btn100: UIButton!
    @IBOutlet weak var btn200: UIButton!
    @IBOutlet weak var btn300: UIButton!
    @IBOutlet weak var btn500: UIButton!

    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var btnSunny: UIButton!
    @IBOutlet weak var btnRainy: UIButton!
    
    @IBOutlet weak var transLabel: UILabel!
    @IBOutlet weak var btnWalk: UIButton!
    @IBOutlet weak var btnMRT: UIButton!
    @IBOutlet weak var btnBus: UIButton!
    @IBOutlet weak var btnUbike: UIButton!
    @IBOutlet weak var btnScooter: UIButton!
    
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var btnClear: UIButton!
    
    var advance: Bool!
    var weather: String?
    var preferPrices: [Int]?
    var transport: String?
    let user = NSUserDefaults()
    let saveIndicator = NVActivityIndicatorView(frame: CGRectMake(0, 0, 90, 90), type: .SquareSpin, color: UIColor(red: 255.0/255.0, green: 106.0/255.0, blue: 79.0/255.0, alpha: 1.0))
    let deviceHelper = DeviceHelper()
    var trialHelper: TrialHelper!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initAdvanceView()
        trialHelper = TrialHelper(viewController: self)
    }
    
    override func viewWillAppear(animated: Bool) {
        loadUserSettings()
        trialHelper.didEnterAdvancedSearchViewController()
    }
    
    func loadUserSettings(){
        if let weather = user.valueForKey("weather") {
            switch weather as! String{
            case "sunny":
                btnSunny.selected = true
                btnToggle(btnSunny)
            case "rainy":
                btnRainy.selected = true
                btnToggle(btnRainy)
            default:
                break
            }
        }
        
        if let preferPrices = user.valueForKey("preferPrices") as? [Int]{
            if preferPrices[0] == 1 {
                btn0.selected = true
                btnToggle(btn0)
            }
            if preferPrices[1] == 1 {
                btn100.selected = true
                btnToggle(btn100)
            }
            if preferPrices[2] == 1 {
                btn200.selected = true
                btnToggle(btn200)
            }
            if preferPrices[3] == 1 {
                btn300.selected = true
                btnToggle(btn300)
            }
            if preferPrices[4] == 1 {
                btn500.selected = true
                btnToggle(btn500)
            }
        }
        
        if let transportation = user.valueForKey("transport") {
            switch transportation as! String {
            case "bus":
                btnBus.selected = true
                btnToggle(btnBus)
            case "MRT":
                btnMRT.selected = true
                btnToggle(btnMRT)
            case "walk":
                btnWalk.selected = true
                btnToggle(btnWalk)
            case "ubike":
                btnUbike.selected = true
                btnToggle(btnUbike)
            case "scooter":
                btnScooter.selected = true
                btnToggle(btnScooter)
            default:
                break
            }
        }
    }
    
    func initAdvanceView(){
        /* Set Advanced Options View */
        let borderColor = UIColor(red: 255.0/255.0, green: 106.0/255.0, blue: 79.0/255.0, alpha: 1.0).CGColor
        
        btn0.layer.cornerRadius = 5
        btn0.layer.borderWidth = 1
        btn0.layer.borderColor = borderColor
        
        btn100.layer.cornerRadius = 5
        btn100.layer.borderWidth = 1
        btn100.layer.borderColor = borderColor
        
        btn200.layer.cornerRadius = 5
        btn200.layer.borderWidth = 1
        btn200.layer.borderColor = borderColor

        btn300.layer.cornerRadius = 5
        btn300.layer.borderWidth = 1
        btn300.layer.borderColor = borderColor
        
        btn500.layer.cornerRadius = 5
        btn500.layer.borderWidth = 1
        btn500.layer.borderColor = borderColor
        
        btnRainy.layer.cornerRadius = 5
        btnRainy.layer.borderWidth = 1
        btnRainy.layer.borderColor = borderColor
        
        btnSunny.layer.cornerRadius = 5
        btnSunny.layer.borderWidth = 1
        btnSunny.layer.borderColor = borderColor
        
        btnWalk.layer.cornerRadius = 5
        btnWalk.layer.borderWidth = 1
        btnWalk.layer.borderColor = borderColor
        
        btnMRT.layer.cornerRadius = 5
        btnMRT.layer.borderWidth = 1
        btnMRT.layer.borderColor = borderColor

        btnBus.layer.cornerRadius = 5
        btnBus.layer.borderWidth = 1
        btnBus.layer.borderColor = borderColor
        
        btnUbike.layer.cornerRadius = 5
        btnUbike.layer.borderWidth = 1
        btnUbike.layer.borderColor = borderColor
        
        btnScooter.layer.cornerRadius = 5
        btnScooter.layer.borderWidth = 1
        btnScooter.layer.borderColor = borderColor
        
        btnSubmit.layer.cornerRadius = 5
        btnSubmit.layer.borderWidth = 1
        btnSubmit.layer.borderColor = borderColor
        
        btnClear.layer.cornerRadius = 5
        btnClear.layer.borderWidth = 1
        btnClear.layer.borderColor = borderColor
        
        switch deviceHelper.checkSize() {
        case "iphone4Family":
            priceLabel.font = UIFont.systemFontOfSize(18)
            weatherLabel.font = UIFont.systemFontOfSize(18)
            transLabel.font = UIFont.systemFontOfSize(18)
            btn0.titleLabel?.font = UIFont.systemFontOfSize(14)
            btn100.titleLabel?.font = UIFont.systemFontOfSize(14)
            btn200.titleLabel?.font = UIFont.systemFontOfSize(14)
            btn300.titleLabel?.font = UIFont.systemFontOfSize(14)
            btn500.titleLabel?.font = UIFont.systemFontOfSize(14)
            btnRainy.titleLabel?.font = UIFont.systemFontOfSize(14)
            btnSunny.titleLabel?.font = UIFont.systemFontOfSize(14)
            btnWalk.titleLabel?.font = UIFont.systemFontOfSize(14)
            btnMRT.titleLabel?.font = UIFont.systemFontOfSize(14)
            btnBus.titleLabel?.font = UIFont.systemFontOfSize(14)
            btnUbike.titleLabel?.font = UIFont.systemFontOfSize(14)
            btnScooter.titleLabel?.font = UIFont.systemFontOfSize(14)
            btnSubmit.titleLabel?.font = UIFont.systemFontOfSize(14)
            btnClear.titleLabel?.font = UIFont.systemFontOfSize(14)
        case "iphone5Family":
            priceLabel.font = UIFont.systemFontOfSize(20)
            weatherLabel.font = UIFont.systemFontOfSize(20)
            transLabel.font = UIFont.systemFontOfSize(20)
            btn0.titleLabel?.font = UIFont.systemFontOfSize(16)
            btn100.titleLabel?.font = UIFont.systemFontOfSize(16)
            btn200.titleLabel?.font = UIFont.systemFontOfSize(16)
            btn300.titleLabel?.font = UIFont.systemFontOfSize(16)
            btn500.titleLabel?.font = UIFont.systemFontOfSize(16)
            btnRainy.titleLabel?.font = UIFont.systemFontOfSize(16)
            btnSunny.titleLabel?.font = UIFont.systemFontOfSize(16)
            btnWalk.titleLabel?.font = UIFont.systemFontOfSize(16)
            btnMRT.titleLabel?.font = UIFont.systemFontOfSize(16)
            btnBus.titleLabel?.font = UIFont.systemFontOfSize(16)
            btnUbike.titleLabel?.font = UIFont.systemFontOfSize(16)
            btnScooter.titleLabel?.font = UIFont.systemFontOfSize(16)
            btnSubmit.titleLabel?.font = UIFont.systemFontOfSize(16)
            btnClear.titleLabel?.font = UIFont.systemFontOfSize(16)
        case "iphone6Family":
            priceLabel.font = UIFont.systemFontOfSize(24)
            weatherLabel.font = UIFont.systemFontOfSize(24)
            transLabel.font = UIFont.systemFontOfSize(24)
            btn0.titleLabel?.font = UIFont.systemFontOfSize(19)
            btn100.titleLabel?.font = UIFont.systemFontOfSize(19)
            btn200.titleLabel?.font = UIFont.systemFontOfSize(19)
            btn300.titleLabel?.font = UIFont.systemFontOfSize(19)
            btn500.titleLabel?.font = UIFont.systemFontOfSize(19)
            btnRainy.titleLabel?.font = UIFont.systemFontOfSize(19)
            btnSunny.titleLabel?.font = UIFont.systemFontOfSize(19)
            btnWalk.titleLabel?.font = UIFont.systemFontOfSize(19)
            btnMRT.titleLabel?.font = UIFont.systemFontOfSize(19)
            btnBus.titleLabel?.font = UIFont.systemFontOfSize(19)
            btnUbike.titleLabel?.font = UIFont.systemFontOfSize(19)
            btnScooter.titleLabel?.font = UIFont.systemFontOfSize(19)
            btnSubmit.titleLabel?.font = UIFont.systemFontOfSize(19)
            btnClear.titleLabel?.font = UIFont.systemFontOfSize(19)
        default:
            break
        }
    }

    override func viewDidAppear(animated: Bool) {

    }
    
    override func viewWillDisappear(animated: Bool) {
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        btn0.selected = false
        btn100.selected = false
        btn200.selected = false
        btn300.selected = false
        btn500.selected = false
        btnRainy.selected = false
        btnSunny.selected = false
        btnWalk.selected = false
        btnMRT.selected = false
        btnBus.selected = false
        btnUbike.selected = false
        btnScooter.selected = false
        
        btnToggle(btn0)
        btnToggle(btn100)
        btnToggle(btn200)
        btnToggle(btn300)
        btnToggle(btn500)
        btnToggle(btnRainy)
        btnToggle(btnSunny)
        btnToggle(btnWalk)
        btnToggle(btnMRT)
        btnToggle(btnBus)
        btnToggle(btnUbike)
        btnToggle(btnScooter)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissController(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func priceOption(sender: UIButton) {
        sender.selected = !sender.selected
        btnToggle(sender)
    }

    @IBAction func weatherOption(sender: UIButton) {
        sender.selected = !sender.selected
        print("sender: \(sender.titleLabel?.text), sender selected: \(sender.selected)")
        if sender.selected == true {
            if sender.titleLabel!.text == "Rainy" {
                print("Rainy selected\n")
                btnToggle(sender)
                self.btnSunny.selected = false
                btnToggle(self.btnSunny)
            }else {
                print("Sunny selected\n")
                btnToggle(sender)
                self.btnRainy.selected = false
                btnToggle(self.btnRainy)
            }
        }else {
            if sender.titleLabel!.text == "Rainy" {
                print("Rainy unselected\n")
                btnToggle(sender)
                self.btnSunny.selected = true
                btnToggle(self.btnSunny)
            }else {
                print("Sunny unselected\n")
                btnToggle(sender)
                self.btnRainy.selected = true
                btnToggle(self.btnRainy)
            }
        }
    }
    
    @IBAction func transOption(sender: UIButton) {
        sender.selected = true
        
        switch sender.titleLabel!.text! {
        case "MRT":
            btnWalk.selected = false
            btnBus.selected = false
            btnUbike.selected = false
            btnScooter.selected = false
        case "Walk":
            btnMRT.selected = false
            btnBus.selected = false
            btnUbike.selected = false
            btnScooter.selected = false
        case "Bus":
            btnMRT.selected = false
            btnWalk.selected = false
            btnScooter.selected = false
            btnUbike.selected = false
        case "U-bike":
            btnMRT.selected = false
            btnWalk.selected = false
            btnBus.selected = false
            btnScooter.selected = false
        case "Scooter":
            btnMRT.selected = false
            btnWalk.selected = false
            btnBus.selected = false
            btnUbike.selected = false
        default:
            break
        }
        
        btnToggle(btnMRT)
        btnToggle(btnWalk)
        btnToggle(btnBus)
        btnToggle(btnUbike)
        btnToggle(btnScooter)
    }
    
    @IBAction func savrFormResult(sender: AnyObject) {
        preferPrices = [Int](count:5, repeatedValue: 0)
        
        // If info not completed, then show alert
        if !((btn0.selected == true || btn100.selected == true || btn200.selected == true || btn300.selected == true || btn500.selected == true) && (btnSunny.selected == true || btnRainy.selected == true) && (btnBus.selected == true || btnMRT.selected == true || btnSunny.selected == true || btnWalk.selected == true || btnUbike.selected == true)){
            
            self.stopActivityAnimating()
            let alertController = UIAlertController(title: "似乎有些選項尚未填完呢!", message: "選項未填完的話，進階搜尋就不會生效哦！", preferredStyle: .Alert)
            let cancelAction = UIAlertAction(title: "填完選項", style: .Cancel, handler: { (result) in
                return
            })
            alertController.addAction(cancelAction)
            self.presentViewController(alertController, animated: true, completion: nil)
            user.setObject(false, forKey: "advance")
        }else {
            
            saveIndicator.center.x = self.view.center.x
            saveIndicator.center.y = self.view.center.y - 60
            self.view.addSubview(saveIndicator)
            
            // perferPrices
            if btn0.selected == true {
                preferPrices![0] = 1
            }
            if btn100.selected == true {
                preferPrices![1] = 1
            }
            if btn200.selected == true {
                preferPrices![2] = 1
            }
            if btn300.selected == true {
                preferPrices![3] = 1
            }
            if btn500.selected == true {
                preferPrices![4] = 1
            }
            
            // weather
            if btnSunny.selected == true {
                weather = "sunny"
            }else if btnRainy.selected == true {
                weather = "rainy"
            }
            
            // transport
            if btnBus.selected == true {
                transport = "bus"
            }else if btnMRT.selected == true {
                transport = "MRT"
            }else if btnWalk.selected == true {
                transport = "walk"
            }else if btnScooter.selected == true {
                transport = "scooter"
            }else if btnUbike.selected == true {
                transport = "ubike"
            }
            
            user.setObject(weather, forKey: "weather")
            user.setObject(preferPrices, forKey: "preferPrices")
            user.setObject(transport, forKey: "transport")
            user.setObject(true, forKey: "advance")

            let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 2 * Int64(NSEC_PER_SEC))
            startActivityAnimating(CGSizeMake(70, 70), message: "Saving...", type: .SquareSpin, color: UIColor(red: 255.0/255.0, green: 106.0/255.0, blue: 79.0/255.0, alpha: 1.0))
            dispatch_after(time, dispatch_get_main_queue()) {
                self.stopActivityAnimating()
                self.saveIndicator.removeFromSuperview()
            }
        }
    }
    
    @IBAction func clear(sender: AnyObject) {
        btn0.selected = false
        btn100.selected = false
        btn200.selected = false
        btn300.selected = false
        btn500.selected = false
        btnRainy.selected = false
        btnSunny.selected = false
        btnWalk.selected = false
        btnMRT.selected = false
        btnBus.selected = false
        btnUbike.selected = false
        btnScooter.selected = false
        
        btnToggle(btn0)
        btnToggle(btn100)
        btnToggle(btn200)
        btnToggle(btn300)
        btnToggle(btn500)
        btnToggle(btnRainy)
        btnToggle(btnSunny)
        btnToggle(btnWalk)
        btnToggle(btnMRT)
        btnToggle(btnBus)
        btnToggle(btnUbike)
        btnToggle(btnScooter)
        
        user.setObject(nil, forKey: "weather")
        user.setObject(nil, forKey: "preferPrices")
        user.setObject(nil, forKey: "transport")
        user.setObject(false, forKey: "advance")
    }
    
    func btnToggle(sender: UIButton){
        if sender.selected == true{
            sender.backgroundColor = UIColor(red: 255.0/255.0, green: 106.0/255.0, blue: 79.0/255.0, alpha: 1)
            sender.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        }else {
            sender.setTitleColor(UIColor(red: 255.0/255.0, green: 106.0/255.0, blue: 79.0/255.0, alpha: 1.0), forState: .Normal)
            sender.backgroundColor = UIColor.whiteColor()
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
