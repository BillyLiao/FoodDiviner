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
    
    var advance: Bool!
    var weather: String?
    var preferPrices: [Int]?
    var transport: String?
    let user = NSUserDefaults()
    let saveIndicator = NVActivityIndicatorView(frame: CGRectMake(0, 0, 90, 90), type: .SquareSpin, color: UIColor(red: 255.0/255.0, green: 106.0/255.0, blue: 79.0/255.0, alpha: 1.0))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initAdvanceView()
    }
    
    override func viewWillAppear(animated: Bool) {
        loadUserSettings()
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
        let optionHeight = (self.view.frame.height*2/3)/8
        let optionWidth = (self.view.frame.width-60)/4
        
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
        
        btnSubmit.center.x = self.view.center.x
        btnSubmit.layer.cornerRadius = 5
        btnSubmit.layer.borderWidth = 1
        btnSubmit.layer.borderColor = borderColor
        
        saveIndicator.center.x = self.view.center.x
        saveIndicator.center.y = self.view.center.y - 60
        self.view.addSubview(saveIndicator)
    }
    
    /*
    func initQuestionView(){
        /* Set QuestionView */
        QuestionView = UIView(frame: self.view.frame)
        
        // Set question label
        let qlRect = CGRect(x: 20, y: self.view.frame.height/5, width: self.view.frame.width-40, height: self.view.frame.height/4)
        QuestionLabel = UILabel(frame: qlRect)
        QuestionLabel.numberOfLines = 3
        QuestionLabel.font = UIFont(name: "Avenir Next", size: 25)
        QuestionLabel.text = "Seems you don't like our recommendation, use advanced search?"
        QuestionLabel.textColor = UIColor.whiteColor()
        QuestionLabel.textAlignment = .Center
        QuestionView.addSubview(QuestionLabel)
        
        // Set yes/no Button
        yesBtn = UIButton(frame: CGRect(x: self.view.frame.width/4-20, y: self.view.frame.height/5+qlRect.height, width: self.view.frame.width/4, height: 60))
        yesBtn.setTitle("Yes", forState: .Normal)
        yesBtn.titleLabel?.font = UIFont(name: "Avenir Next", size: 20)
        yesBtn.layer.cornerRadius = 5
        yesBtn.layer.borderWidth = 1
        yesBtn.layer.borderColor = UIColor.whiteColor().CGColor
        yesBtn.addTarget(self, action: "showAdvanceOptions", forControlEvents: .TouchUpInside)
        yesBtn.setTitleColor(UIColor(red: 255.0/255.0, green: 106.0/255.0, blue: 79.0/255.0, alpha: 1), forState: .Highlighted)
        QuestionView.addSubview(yesBtn)
        
        
        noBtn =  UIButton(frame: CGRect(x: self.view.frame.width/2+20, y: self.view.frame.height/5+qlRect.height, width: self.view.frame.width/4, height: 60))
        noBtn.setTitle("No", forState: .Normal)
        noBtn.titleLabel?.font = UIFont(name: "Avenir Next", size: 20)
        noBtn.layer.cornerRadius = 5
        noBtn.layer.borderWidth = 1
        noBtn.layer.borderColor = UIColor.whiteColor().CGColor
        noBtn.addTarget(self, action: "dismissController", forControlEvents: .TouchUpInside)
        noBtn.setTitleColor(UIColor(red: 255.0/255.0, green: 106.0/255.0, blue: 79.0/255.0, alpha: 1), forState: .Highlighted)

        QuestionView.addSubview(noBtn)
        
        // Question View Effect
        let scale = CGAffineTransformMakeScale(0.0, 0.0)
        let translate = CGAffineTransformMakeTranslation(0, 800)
        QuestionView.transform = CGAffineTransformConcat(scale, translate)
        
        self.view.addSubview(QuestionView)
    }
    */

    override func viewDidAppear(animated: Bool) {

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    func showAdvanceOptions(){
        UIView.animateWithDuration(0.7, delay: 0.0, options: [], animations: { () -> Void in
            self.advanceView.transform = CGAffineTransformMakeTranslation(0, 0)
            self.QuestionView.transform = CGAffineTransformMakeTranslation(0, -1400)
        }, completion: nil)
    }
    */
    
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
            if sender.titleLabel == "Rainy" {
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
        
        let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 2 * Int64(NSEC_PER_SEC))
        startActivityAnimating(CGSizeMake(70, 70), message: "Saving now", type: .SquareSpin, color: UIColor(red: 255.0/255.0, green: 106.0/255.0, blue: 79.0/255.0, alpha: 1.0))
        dispatch_after(time, dispatch_get_main_queue()) {
            self.stopActivityAnimating()
        }
        user.setObject(true, forKey: "advance")
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
