//
//  User.swift
//  Twitter
//
//  Created by vu on 9/30/15.
//  Copyright © 2015 CodePath. All rights reserved.
//

import UIKit

var _currentUser: User?
let currentUserKey = "kCurrentUserKey"
let userDidLoginNotification = "userDidLoginNotification"
let userDidLogoutNotification = "userDidLogoutNotification"

class User: NSObject {
    var name: String?
    var screenname: String?
    var profileImageUrl: String?
    var tagline: String?
    var tweettext: String?
//    var coverImageUrl: String?
    
    var dictionary: NSDictionary
    
    init(dictionary: NSDictionary) {
//        print("User: \(dictionary)")
        
        self.dictionary = dictionary
        
        name = dictionary["name"] as? String
        screenname = dictionary["screen_name"] as? String
        profileImageUrl = dictionary["profile_image_url_https"] as? String
        tagline = dictionary["description"] as? String
        tweettext = dictionary["text"] as? String
//        coverImageUrl = dictionary["profile_banner_url"] as? String
    }
    
    func logout() {
        User.currentUser = nil
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        
        NSNotificationCenter.defaultCenter().postNotificationName(userDidLogoutNotification, object: nil)
    }
    
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                let data = NSUserDefaults.standardUserDefaults().objectForKey(currentUserKey) as? NSData
                if data != nil {
                    do {
                        let dictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! NSDictionary
                        _currentUser = User(dictionary: dictionary)
                    } catch {
                        print(error)
                        _currentUser = nil
                    }
                }
            }
            return _currentUser
        }
        set(user) {
            _currentUser = user
            
            if _currentUser != nil {
                do {
                    let data = try NSJSONSerialization.dataWithJSONObject((user!.dictionary), options: NSJSONWritingOptions())
                    NSUserDefaults.standardUserDefaults().setObject(data, forKey: currentUserKey)
                } catch {
                    print(error)
                    NSUserDefaults.standardUserDefaults().setObject(nil, forKey: currentUserKey)
                }
            } else {
                NSUserDefaults.standardUserDefaults().setObject(nil, forKey: currentUserKey)
            }
            NSUserDefaults.standardUserDefaults().synchronize()

        }
    }
}
