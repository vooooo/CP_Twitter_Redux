//
//  TwitterClient.swift
//  Twitter
//
//  Created by vu on 9/29/15.
//  Copyright © 2015 CodePath. All rights reserved.
//

import UIKit

let twitterConsumerKey = "7PkdtLJIRbaXZ6inNyhU38JdG"
let twitterConsumerSecret = "p7uXTdU7Oo14RycCkOBUArNDkRxkZd7oRijZ5LyyAk118UKucL"
let twitterBaseURL = NSURL(string: "https://api.twitter.com")

class TwitterClient: BDBOAuth1RequestOperationManager {
    var loginCompletion: ((user: User?, error: NSError?) -> ())?
    
    static let sharedInstance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
    
    func tweetStatus(tweet: String, in_reply_to_status_id: String, completion: (tweet: Tweet?, error: NSError?) -> ()) {
        let escapedTweet = tweet.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
        var url = "1.1/statuses/update.json?status=\(escapedTweet!)"
        
        if in_reply_to_status_id != "" {
            let escapedReplyId = in_reply_to_status_id.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
            url = "\(url)&in_reply_to_status_id=\(escapedReplyId!)"
        }
        
        POST(url, parameters: nil,
            success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                
                print("tweetStatus: \(response)")
                let tweet = Tweet(dictionary: response as! NSDictionary)
                completion(tweet: tweet, error: nil)
                
            },
            failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                print("Error favorites Create")
                completion(tweet: nil, error: error)
        })
    }

    func homeTimelineWithParams(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        GET("1.1/statuses/home_timeline.json", parameters: params,
            success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
//                print("home_timeline: \(response)")
                print("home_timeline")
                
                let tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
                completion(tweets: tweets, error: nil)
                
            },
            failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                print("Error getting home timeline")
                completion(tweets: nil, error: error)
        })
    }
    func mentionsTimelineWithParams(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        GET("1.1/statuses/mentions_timeline.json", parameters: params,
            success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                print("mentions_timeline")
                
                let tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
                completion(tweets: tweets, error: nil)
                
            },
            failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                print("Error getting mentions timeline")
                completion(tweets: nil, error: error)
        })
    }

    func userTimelineWithParams(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        GET("1.1/statuses/user_timeline.json", parameters: params,
            success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
//                print("user_timeline: \(response)")
                print("user_timeline")
                
                let tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
                completion(tweets: tweets, error: nil)
                
            },
            failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                print("Error getting user timeline")
                completion(tweets: nil, error: error)
        })
    }

    func favoritesCreate(id: String, completion: (tweet: Tweet?, error: NSError?) -> ()) {
        
        let url = "1.1/favorites/create.json?id=\(id)"
        POST(url, parameters: nil,
            success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                
                print("favoritesCreate: \(response)")
                let tweet = Tweet(dictionary: response as! NSDictionary)
                completion(tweet: tweet, error: nil)
                
            },
            failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                print("Error favorites Create")
                completion(tweet: nil, error: error)
        })
    }
    
    func retweetWithId(id: String, completion: (tweet: Tweet?, error: NSError?) -> ()) {
        
        let url = "1.1/statuses/retweet/\(id).json"
        POST(url, parameters: nil,
            success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                
                print("retweetWithId: \(response)")
                let tweet = Tweet(dictionary: response as! NSDictionary)
                completion(tweet: tweet, error: nil)
                
            },
            failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                print("Error attempting retweet")
                completion(tweet: nil, error: error)
        })
    }

    func loginWithCompletion(completion: (user: User?, error: NSError?) -> ()) {
        loginCompletion = completion
        
        // Fetch request token and redirect to  auth page
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "cptwitterdemo://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
                print("Got the request token")
                let authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)" )
                UIApplication.sharedApplication().openURL(authURL!)
            },
            failure: { (error: NSError!) -> Void in
                print("Failed to get the request token: \(error)")
                self.loginCompletion?(user: nil, error: error)
            })
    }
    
    func openURL(url: NSURL) {
        
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query),
            success: { (accessToken: BDBOAuth1Credential!) -> Void in
                print("Got access token")
                TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
                
                
                TwitterClient.sharedInstance.GET("1.1/account/verify_credentials.json", parameters: nil,
                    success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                        //print("user: \(response)")
                        
                        let user = User(dictionary: response as! NSDictionary)
                        print("user: \(user.name)")
                        User.currentUser = user
                        self.loginCompletion?(user: user, error: nil)
                        NSNotificationCenter.defaultCenter().postNotificationName(userDidLoginNotification, object: nil)

                    },
                    failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                        print("Error verifying credentials: \(error)")
                    })
            },
            failure: { (error: NSError!) -> Void in
                print("Failed to receive access token")
                self.loginCompletion?(user: nil, error: error)

            })

    }
}
