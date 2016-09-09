//
//  APIManager.swift
//  FoodDiviner
//
//  Created by 廖慶麟 on 2016/6/21.
//  Copyright © 2016年 廖慶麟. All rights reserved.
//

import Foundation
import AFNetworking

protocol WebServiceDelegate: class {
    func userRecomGetRequestDidFinished(r: [NSDictionary]?) -> Void
    func requestFailed(e: NSError?) -> Void
    func userDidSignUp(user_id: NSNumber) -> Void
}
class APIManager: NSObject {
    
    weak var delegate: WebServiceDelegate?
    let baseURL = "http://flask-env.ansdqhgbnp.us-west-2.elasticbeanstalk.com"
    let manager = AFHTTPSessionManager()
    let error = NSError(domain: "webService", code: 400, userInfo: [NSLocalizedDescriptionKey: "Empty responseObject"])
    
    override init(){
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer = AFJSONResponseSerializer()
    }
    
    func getRestRecom(uid: NSNumber, advance: Bool, preferPrices: [Int]?, weather: String?, transport: String?, lat: Double?, lng: Double?){
        let url = "\(baseURL)/users/\(uid)/recommendation"
        let params: NSDictionary?
        
        if advance == true {
            params = NSDictionary(dictionary: ["advance": advance, "prefer_prices": preferPrices!, "weather": weather!, "transport": transport!, "lat": lat!, "lng": lng!])
        }else {
            params = nil
        }
        print("Get restaurants recommendation params: \(params)")
        manager.GET(url, parameters: params, success: { (task, responseObject) in
                guard let data = responseObject else {
                    self.delegate?.requestFailed(self.error)
                    return
                }
                let result = data as! [NSDictionary]
                print(result)
                self.delegate?.userRecomGetRequestDidFinished(result)
            }) { (task, err) -> Void in
                self.delegate?.requestFailed(err)
                print("Get Recommendations Failed: \(err)")
        }
        
    }
    
    
    func postUserChoice(user_id: NSNumber, restaurant_id: NSNumber, decision: String, run: Int){
        let url = "\(baseURL)/user_choose"
        let params = NSDictionary(dictionary: ["user_id" : user_id, "restaurant_id" : restaurant_id, "decision" : "accept", "run" : run])
        manager.POST(url, parameters: params, success: { (task, resObject) in
                print("POST user choice succeed.")
            }) { (task, err) in
                print("POST user choice failed: \(err.localizedDescription)")
        }
    }
    
    func postUserRating(user_id: NSNumber, restaurant_id: NSNumber, rate: Int, tags: [String]?){
        let url = "\(baseURL)/users/\(user_id)/ratings"
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
    
    func signUp(fb_id: String!, user_trial: NSDictionary, name: String!, gender: String!) {
        let url = "\(baseURL)/signup"
        let params = NSDictionary(dictionary: ["fb_id" : fb_id, "user_trial" : user_trial, "name" : name, "gender" : gender])
        manager.POST(url, parameters: params, success: { (task, resObject) in
                self.delegate?.userDidSignUp(resObject!["user_id"] as! NSNumber)
                print("Sign up succeed")
            }) { (task, err) in
                print("Sign up : \(err.localizedDescription)")
        }
    }
    
    
    func cleanCaches(user_id: NSNumber){
        let url = "\(baseURL)/users/\(user_id)/caches"
        manager.DELETE(url, parameters: nil, success: { (task, resObject) in
                print("Clean caches succeed.")
            }) { (task, error) in
                print("Clean caches failed.")
        }
    }
    
    /*
    func getTrial(){
    }
    */
    
}