//
//  ProfileViewController.swift
//  Twitter
//
//  Created by vu on 10/6/15.
//  Copyright © 2015 CodePath. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UserTweetCellDelegate {

    @IBAction func onNew(sender: UIBarButtonItem) {
        performSegueWithIdentifier("profileCompose", sender: nil)
    }
    
    @IBOutlet weak var tableView: UITableView!
    var tweets: [Tweet]?
    var user: User?
    var composeType: String?
    var menuTitle: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        if user == nil {
            user = User.currentUser
        }
        
        loadTweets()
    }
    
    func loadTweets() {
        var params = [String:String]()
        params["screen_name"] = user!.screenname
        
        TwitterClient.sharedInstance.userTimelineWithParams(params) { (tweets, error) -> () in
            if error == nil {
                self.tweets = tweets
                self.tableView.reloadData()
            } else {
                print("ERROR: \(error)")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tweets != nil {
            return tweets!.count
        } else {
            return 1
            
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let pcell = tableView.dequeueReusableCellWithIdentifier("ProfileHeaderCell", forIndexPath: indexPath) as! ProfileHeaderCell
            
            pcell.nameLabel.text = user?.name
            pcell.screennameLabel.text = user?.screenname
            pcell.profileImageView.setImageWithURL(NSURL(string: (user?.profileImageUrl!)!))
            
            let coverimage = user?.dictionary["profile_banner_url"] as? String
            if coverimage != nil {
                pcell.coverImageView.setImageWithURL(NSURL(string: coverimage!))
            }
            
            let tweets : Int = user?.dictionary["statuses_count"] as! Int
            pcell.profileTweetsLabel.text = String(tweets)

            let followers : Int = user?.dictionary["followers_count"] as! Int
            pcell.profileFollowersLabel.text = String(followers)

            
            let following : Int = user?.dictionary["friends_count"] as! Int
            pcell.profileFollowingLabel.text = String(following)

            return pcell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("UserTweetCell", forIndexPath: indexPath) as! UserTweetCell
            
            cell.tweet = tweets?[indexPath.row]
            cell.delegate = self

            return cell

            
        }
    }
    
    func tweetCell(tweetCell: TweetCell, tweetAction value: String) {
        
        if value == "TweetReply" {
            composeType = "TweetReply"
            performSegueWithIdentifier("tweetCompose", sender: tweetCell)
        } else if value == "ProfileTap" {
            performSegueWithIdentifier("profileView", sender: tweetCell)
        }
        
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        navigationItem.title = nil
        
        if segue.identifier == "profileDetail"{
            let vc = segue.destinationViewController as! TweetDetailViewController
            vc.navigationItem.title = "Tweet"
            navigationItem.title = "Back"
            
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPathForCell(cell)
            
            let tweet: Tweet
            tweet = tweets![indexPath!.row]
            
            vc.tweet = tweet
            
        }
        if segue.identifier == "profileCompose" {
            let vc = segue.destinationViewController as! TweetComposeViewController
            vc.navigationItem.title = "Compose"
            navigationItem.title = "Cancel"
            
            if sender != nil {
                vc.tweet = nil
            }
        }
        
    }

}
