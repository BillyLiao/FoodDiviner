//
//  AdavanceSearchViewController.swift
//  FoodDiviner
//
//  Created by 廖慶麟 on 2016/5/30.
//  Copyright © 2016年 廖慶麟. All rights reserved.
//

import UIKit

class AdavanceSearchViewController: UIViewController{

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var btn0: CustomizedButton!
    @IBOutlet weak var btn100: CustomizedButton!
    @IBOutlet weak var btn200: CustomizedButton!
    @IBOutlet weak var btn300: CustomizedButton!
    @IBOutlet weak var btn500: CustomizedButton!

    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var btnSunny: UIButton!
    @IBOutlet weak var btnRainy: UIButton!
    
    @IBOutlet weak var transLabel: UILabel!
    @IBOutlet weak var btnWalk: CustomizedButton!
    @IBOutlet weak var btnMRT: CustomizedButton!
    @IBOutlet weak var btnBus: CustomizedButton!
    @IBOutlet weak var btnUbike: CustomizedButton!
    @IBOutlet weak var btnScooter: CustomizedButton!
    
    @IBOutlet weak var btnClear: UIButton!
    
    var advance: Bool!
    var weather: String?
    var preferPrices: [Int]?
    var transport: String?
    let user = NSUserDefaults()
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
            case "rainy":
                btnRainy.selected = true
            default:
                break
            }
        }
        
        if let preferPrices = user.valueForKey("preferPrices") as? [Int]{
            if preferPrices[0] == 1 {
                btn0.selected = true
            }
            if preferPrices[1] == 1 {
                btn100.selected = true
            }
            if preferPrices[2] == 1 {
                btn200.selected = true
            }
            if preferPrices[3] == 1 {
                btn300.selected = true
            }
            if preferPrices[4] == 1 {
                btn500.selected = true
            }
        }
        
        if let transportation = user.valueForKey("transport") {
            switch transportation as! String {
            case "bus":
                btnBus.selected = true
            case "MRT":
                btnMRT.selected = true
            case "walk":
                btnWalk.selected = true
            case "ubike":
                btnUbike.selected = true
            case "scooter":
                btnScooter.selected = true
            default:
                break
            }
        }
    }
    
    func initAdvanceView(){
        /* Set Advanced Options View */
        btnClear.layer.cornerRadius = 5
        btnClear.layer.borderWidth = 1
        btnClear.layer.borderColor = CustomizedButton.borderColor
        
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
            btnClear.titleLabel?.font = UIFont.systemFontOfSize(19)
        default:
            break
        }
    }

    override func viewDidAppear(animated: Bool) {

    }
    
    override func viewWillDisappear(animated: Bool) {
        saveFormResult()
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func priceOption(sender: UIButton) {
        sender.selected = !sender.selected
    }

    @IBAction func weatherOption(sender: UIButton) {
        sender.selected = !sender.selected
        if sender.selected == true {
            if sender.titleLabel!.text == "Rainy" {
                print("Rainy selected\n")
                self.btnSunny.selected = false
            }else {
                print("Sunny selected\n")
                self.btnRainy.selected = false
            }
        }else {
            if sender.titleLabel!.text == "Rainy" {
                print("Rainy unselected\n")
                self.btnSunny.selected = true
            }else {
                print("Sunny unselected\n")
                self.btnRainy.selected = true
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
    }
    
    func saveFormResult() {
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
        
        if anyBtnSelected() == true {
            user.setValue(true, forKey: "advance")
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
    
        user.setObject(nil, forKey: "weather")
        user.setObject(nil, forKey: "preferPrices")
        user.setObject(nil, forKey: "transport")
        user.setObject(false, forKey: "advance")
    }
    
    func anyBtnSelected() -> Bool {
        if btn100.selected == true || btn200.selected == true || btn300.selected == true || btn500.selected == true || btnRainy.selected == true || btnSunny.selected == true || btnWalk.selected == true || btnMRT.selected == true || btnBus.selected == true || btnUbike.selected == true || btnScooter.selected == true {
            return true
        }
        return false
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
