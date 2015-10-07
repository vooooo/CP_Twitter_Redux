//
//  Tweet.swift
//  Twitter
//
//  Created by vu on 9/30/15.
//  Copyright © 2015 CodePath. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var user: User?
    var text: String?
    var createdAtString: String?
    var createdAt: NSDate?
    var createdAtAgo: String?
    var createdAtDetail: String?
    var retweets: String?
    var favorites: String?
    var retweeted: Bool?
    var favorited: Bool?
    var tweetId: String?
    
    init(dictionary: NSDictionary) {
        super.init()
        user = User(dictionary: dictionary["user"] as! NSDictionary)
        text = dictionary["text"] as? String
        createdAtString = dictionary["created_at"] as? String
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        createdAt = formatter.dateFromString(createdAtString!)
        createdAtAgo = self.formatTimeElapsed(createdAt!)
        createdAtDetail = self.formatTimeDetail(createdAt!)
        
        let retweetsInt : Int = dictionary["retweet_count"] as! Int
        retweets = String(retweetsInt)
        let favoritesInt : Int = dictionary["favorite_count"] as! Int
        favorites = String(favoritesInt)
        
        let tweetIdInt : Int = dictionary["id"] as! Int
        self.tweetId = String(tweetIdInt)

        let faved : Int = dictionary["favorited"] as! Int
        if faved == 1 {
            favorited = true
        } else {
            favorited = false
        }
        
        let reeted : Int = dictionary["retweeted"] as! Int
        if reeted == 1 {
            retweeted = true
        } else {
            retweeted = false
        }

    }
    
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in array {
            tweets.append(Tweet(dictionary: dictionary))
        }
        
        return tweets
    }

    func formatTimeDetail(date: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "M/d/yy, h:mm a"
        let str = dateFormatter.stringFromDate(date)
        return str
    }
    
    func formatTimeElapsed(sinceDate: NSDate) -> String {
        let formatter = NSDateComponentsFormatter()
        formatter.unitsStyle = NSDateComponentsFormatterUnitsStyle.Abbreviated
        formatter.collapsesLargestUnit = true
        formatter.maximumUnitCount = 1
        let interval = NSDate().timeIntervalSinceDate(sinceDate)
        return formatter.stringFromTimeInterval(interval)!
    }

}
