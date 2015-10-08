//
//  UserTweetCell.swift
//  Twitter
//
//  Created by vu on 10/7/15.
//  Copyright © 2015 CodePath. All rights reserved.
//

import UIKit

class UserTweetCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var screennameLabel: UILabel!
    
    @IBOutlet weak var tweetLabel: UILabel!
    
    @IBOutlet weak var createdAtLabel: UILabel!
    
    
    @IBOutlet weak var onRetweetButton: UIButton!
    
    @IBOutlet weak var onFavoriteButton: UIButton!
    
    @IBAction func onReply(sender: UIButton) {
        print("onReply")
    }
    
    @IBAction func onRetweet(sender: UIButton) {
        print("onRetweet")
    }
    
    @IBAction func onFavorite(sender: UIButton) {
        print("onFav")
    }
    
    var tweet: Tweet! {
        didSet {
            nameLabel.text = tweet.user!.name
            profileImageView.setImageWithURL(NSURL(string: tweet.user!.profileImageUrl!))
            screennameLabel.text = "@\(tweet.user!.screenname!)"
            tweetLabel.text = tweet.text
            createdAtLabel.text = tweet.createdAtAgo
            
            if (tweet.favorited == true) {
                onFavoriteButton.setImage(UIImage(named: "favorite_on.png"), forState: UIControlState.Normal)
            }
            
            
            if (tweet.retweeted == true) {
                onRetweetButton.setImage(UIImage(named: "retweet_on.png"), forState: UIControlState.Normal)
            }
            
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
