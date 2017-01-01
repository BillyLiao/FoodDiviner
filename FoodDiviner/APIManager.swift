//
//  APIManager.swift
//  FoodDiviner
//
//  Created by 廖慶麟 on 2016/6/21.
//  Copyright © 2016年 廖慶麟. All rights reserved.
//

import Foundation
import AFNetworking
import SwiftyJSON

protocol WebServiceDelegate: class {
    func userRecomGetRequestDidFinished(r: [NSDictionary]?) -> Void
    func requestFailed(e: NSError?) -> Void
    func userDidSignUp(user_key: NSNumber?, success: Bool) -> Void
    func userSignedUpBefore(user_key: NSNumber?, success: Bool) -> Void
}

class APIManager: NSObject {
    
    weak var delegate: WebServiceDelegate?
    let baseURL = "http://api-server.jqemsuerdm.ap-northeast-1.elasticbeanstalk.com"
    let manager = AFHTTPSessionManager()
    let error = NSError(domain: "webService", code: 400, userInfo: [NSLocalizedDescriptionKey: "Empty responseObject"])
    let user = NSUserDefaults()
    
    override init(){
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFJSONResponseSerializer()
    }
    
    func getRestRecom(){
        if (self.user.valueForKey("user_key") == nil){
            return 
        }
        let url = "\(baseURL)/users/\(self.user.valueForKey("user_key") as! NSNumber)/recommendation"
        let params: NSDictionary?

        let preferPrices = self.user.valueForKey("preferPrices") as? [Int]
        let weather = self.user.valueForKey("weather") as? String
        let transport = self.user.valueForKey("transport") as? String
        let lat = self.user.valueForKey("lat") as? Double
        let lng = self.user.valueForKey("lng") as? Double
        
        if self.user.boolForKey("advance") == true  {
            params = NSDictionary(dictionary: ["advance": true, "prefer_prices": preferPrices!, "weather": weather!, "transport": transport!, "lat": lat!, "lng": lng!])
        }else {
            params = NSDictionary(dictionary: ["advance" : false])
        }
        
        print("Get restaurants recommendation params: \(params)")
        manager.POST(url, parameters: params, success: { (task, responseObject) in
            guard let data = responseObject else {
                self.delegate?.requestFailed(self.error)
                return
            }
            let result = data as! [NSDictionary]
            self.delegate?.userRecomGetRequestDidFinished(result)
        }) { (task, err) -> Void in
            self.delegate?.requestFailed(err)
            print("Get Recommendations Failed: \(err)")
        }

    }
    
    func postUserChoice(restaurant_id: NSNumber, decision: String, run: Int){
        let url = "\(baseURL)/user_choose"
        let params = NSDictionary(dictionary: ["user_id" : user.valueForKey("user_key") as! NSNumber, "restaurant_id" : restaurant_id, "decision" : "accept", "run" : run])
        manager.POST(url, parameters: params, success: { (task, resObject) in
                print("POST user choice succeed.")
            }) { (task, err) in
                print("POST user choice failed: \(err.localizedDescription)")
        }
    }
    
    func isUserSignedUpBefore(user_id: String){
        let url = "\(baseURL)/test"
        let params = NSDictionary(object: user_id, forKey: "user_key")
        print(params)
        manager.POST(url, parameters: params, success: { (task, resObject) in
                self.delegate?.userSignedUpBefore(resObject!["user_id"] as? NSNumber, success: true)
                print("Check signed up before succeed.")
            }) { (task, err) in
                print("Check signed up before failed: \(err.localizedDescription)")
                if err.localizedDescription == "Request failed: not found (404)"{
                    self.delegate?.userSignedUpBefore(nil, success: false)
                }else {
                    // If internal server error 500 occurs
                    self.delegate?.userSignedUpBefore(0, success: false)
                }
        }
    }
    
    func postUserRating(user_key: NSNumber, restaurant_id: NSNumber, rate: Int, tags: [String]?){
        let url = "\(baseURL)/users/\(user_key)/ratings"
        var params = NSDictionary()
        if let tags = tags {
            params = NSDictionary(dictionary: ["restaurant_id": restaurant_id, "rate": rate, "tags": tags])
        }else {
            params = NSDictionary(dictionary: ["restaurant_id": restaurant_id, "rate": rate, "tags": []])
        }
        manager.POST(url, parameters: params, success: { (task, resObject) in
                print("POST user rating succeed.")
            }) { (task, error) in
                print("POST user rating failed: \(error.localizedDescription)")
        }
    }
    
    func signUp(user_id: String!, user_trial: NSDictionary, name: String!, gender: String!) {
        let url = "\(baseURL)/signup"
        //TOFIX: Wait for backend exchange user_key & user_id
        let params = NSDictionary(dictionary: ["user_key" : user_id, "user_trial" : user_trial, "name" : name, "gender" : gender])
        manager.POST(url, parameters: params, success: { (task, resObject) in
                self.delegate?.userDidSignUp(resObject!["user_id"] as! NSNumber, success: true)
                print("Sign up succeed")
            }) { (task, err) in
                self.delegate?.userDidSignUp(nil, success: false)
                print("Sign up : \(err.localizedDescription)")
        }
    }
    
    
    func cleanCaches(user_key: NSNumber){
        let url = "\(baseURL)/users/\(user_key)/caches"
        manager.DELETE(url, parameters: nil, success: { (task, resObject) in
                print("Clean caches succeed.")
            }) { (task, error) in
                print("Clean caches failed.")
        }
    }
}
