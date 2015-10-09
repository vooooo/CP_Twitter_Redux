//
//  UserTweetCell.swift
//  Twitter
//
//  Created by vu on 10/7/15.
//  Copyright © 2015 CodePath. All rights reserved.
//

import UIKit
@objc protocol UserTweetCellDelegate {
    optional func userTweetCell(userTweetCell: UserTweetCell, tweetAction value: String)
}

class UserTweetCell: UITableViewCell {

    weak var delegate: UserTweetCellDelegate?

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
        TwitterClient.sharedInstance.retweetWithId(tweet.tweetId!) { [weak self] (tweets, error) -> () in
            if error == nil {
                self!.onRetweetButton.setImage(UIImage(named: "retweet_on.png"), forState: UIControlState.Normal)
            } else {
                print("ERROR: \(error)")
            }
        }
    }
    
    @IBAction func onFavorite(sender: UIButton) {
        TwitterClient.sharedInstance.favoritesCreate(tweet.tweetId!) { [weak self] (tweets, error) -> () in
            if error == nil {
                self!.onFavoriteButton.setImage(UIImage(named: "favorite_on.png"), forState: UIControlState.Normal)
            } else {
                print("ERROR: \(error)")
            }
        }
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

    func tweetActionClicked(action: String) {
        delegate?.userTweetCell!(self, tweetAction: action)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageView.layer.cornerRadius = 3
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
