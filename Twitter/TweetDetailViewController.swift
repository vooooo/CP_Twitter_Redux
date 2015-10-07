//
//  TweetDetailViewController.swift
//  Twitter
//
//  Created by vu on 10/2/15.
//  Copyright © 2015 CodePath. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {

    var tweet: Tweet!
    var composeType: String?
    

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    
    @IBOutlet weak var retweetsLabel: UILabel!
    @IBOutlet weak var favoritesLabel: UILabel!
    @IBOutlet weak var countSubview: UIView!
    
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    
    @IBAction func doReply(sender: AnyObject) {
        composeType = "TweetReply"
        performSegueWithIdentifier("tweetCompose", sender: tweet)
    }
    @IBAction func doRetweet(sender: AnyObject) {
        TwitterClient.sharedInstance.retweetWithId(tweet.tweetId!) { [weak self] (tweets, error) -> () in
            if error == nil {
                self!.retweetButton.setImage(UIImage(named: "retweet_on.png"), forState: UIControlState.Normal)
            } else {
                print("ERROR: \(error)")
            }
        }
    }
    @IBAction func doFavorite(sender: AnyObject) {
        TwitterClient.sharedInstance.favoritesCreate(tweet.tweetId!) { [weak self] (tweets, error) -> () in
            if error == nil {
                self!.favoriteButton.setImage(UIImage(named: "favorite_on.png"), forState: UIControlState.Normal)
            } else {
                print("ERROR: \(error)")
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameLabel.text = tweet.user!.name
        profileImageView.setImageWithURL(NSURL(string: tweet.user!.profileImageUrl!))
        screennameLabel.text = "@\(tweet.user!.screenname!)"

        tweetLabel.text = tweet.text
        createdAtLabel.text = tweet.createdAtDetail
        
        retweetsLabel.text = tweet.retweets!
        favoritesLabel.text = tweet.favorites!
        
        if (tweet.favorited == true) {
            favoriteButton.setImage(UIImage(named: "favorite_on.png"), forState: UIControlState.Normal)
        }
        
        if (tweet.retweeted == true) {
            retweetButton.setImage(UIImage(named: "retweet_on.png"), forState: UIControlState.Normal)
        }

        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "tweetCompose" {
            let vc = segue.destinationViewController as! TweetComposeViewController
            vc.navigationItem.title = "Compose"
            
            if composeType == "TweetReply" {
                vc.navigationItem.title = "Reply"
            } else if composeType == "TweetRetweet" {
                vc.navigationItem.title = "Retweet"
            }
            navigationItem.title = "Cancel"
            
            if sender != nil {
//                let cell = sender as! UITableViewController
                
                let tweet: Tweet
                tweet = self.tweet
                
                vc.tweet = tweet
            }
        }
    }

}
