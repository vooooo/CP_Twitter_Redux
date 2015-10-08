//
//  ProfileViewController.swift
//  Twitter
//
//  Created by vu on 10/6/15.
//  Copyright © 2015 CodePath. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var tweets: [Tweet]?
    var user: User?
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
            
            return cell

            
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
