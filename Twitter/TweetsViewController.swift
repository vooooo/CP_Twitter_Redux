//
//  TweetsViewController.swift
//  Twitter
//
//  Created by vu on 9/30/15.
//  Copyright © 2015 CodePath. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TweetCellDelegate {
    
    var tweets: [Tweet]?
    var refreshControl: UIRefreshControl!
    var composeType: String?
    var menuTitle = "Tweets"
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func onLogout(sender: AnyObject) {
        //
        // Was going to update the logout to just trigger the hamburger menu and have logout there
        // but with the occasional back button, it was just too inconsistent.  So I left logout in 
        // both places.
        //
        User.currentUser?.logout()
        print("Logout button tapped")
    }
    
    @IBAction func onNew(sender: AnyObject) {
        composeType = "Compose"
        performSegueWithIdentifier("tweetCompose", sender: nil)
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "loadTweets", forControlEvents: UIControlEvents.ValueChanged)
        
        let dummyTableVC = UITableViewController()
        dummyTableVC.tableView = tableView
        dummyTableVC.refreshControl = refreshControl
        
        loadTweets()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        if menuTitle == "Mentions" {
            navigationItem.title = "Mentions"
        } else {
            navigationItem.title = "Home"
        }
    }
    
    func loadTweets() {
        if menuTitle == "Mentions" {
            TwitterClient.sharedInstance.mentionsTimelineWithParams(nil) { (tweets, error) -> () in
                if error == nil {
                    self.tweets = tweets
                    self.tableView.reloadData()
                    self.refreshControl.endRefreshing()
                } else {
                    print("ERROR: \(error)")
                }
            }

        } else {
            TwitterClient.sharedInstance.homeTimelineWithParams(nil) { (tweets, error) -> () in
                if error == nil {
                    self.tweets = tweets
                    self.tableView.reloadData()
                    self.refreshControl.endRefreshing()
                } else {
                    print("ERROR: \(error)")
                }
            }
        }
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tweets != nil {
            return tweets!.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetCell

        cell.tweet = tweets?[indexPath.row]
        cell.delegate = self

        return cell
    }

    //
    // Delegate to handle replies and profile taps
    //
    func tweetCell(tweetCell: TweetCell, tweetAction value: String) {
        
        if value == "TweetReply" {
            composeType = "TweetReply"
            performSegueWithIdentifier("tweetCompose", sender: tweetCell)
        } else if value == "ProfileTap" {
            performSegueWithIdentifier("profileView", sender: tweetCell)
        }
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        print(segue.identifier)

        navigationItem.title = nil
        
        if segue.identifier == "tweetDetail"{
            let vc = segue.destinationViewController as! TweetDetailViewController
            vc.navigationItem.title = "Tweet"
            navigationItem.title = "Back"
            
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPathForCell(cell)
    
            let tweet: Tweet
            tweet = tweets![indexPath!.row]
    
            vc.tweet = tweet

        }
        if segue.identifier == "tweetCompose" {
            let vc = segue.destinationViewController as! TweetComposeViewController
            vc.navigationItem.title = "Compose"
            
            if composeType == "TweetReply" {
                vc.navigationItem.title = "Reply"
            }
            navigationItem.title = "Cancel"

            if sender != nil {
                let cell = sender as! UITableViewCell
                let indexPath = tableView.indexPathForCell(cell)
    
                let tweet: Tweet
                tweet = tweets![indexPath!.row]
                
                vc.tweet = tweet
            }
        }
        if segue.identifier == "profileView" {
            let vc = segue.destinationViewController as! ProfileViewController
            if sender != nil {
                let cell = sender as! UITableViewCell
                let indexPath = tableView.indexPathForCell(cell)
                
                let tweet: Tweet
                tweet = tweets![indexPath!.row]
                let user = tweet.user
                
                vc.user = user
            }

            
        }
    
    }

}
