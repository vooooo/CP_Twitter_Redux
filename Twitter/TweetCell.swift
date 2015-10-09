//
//  TweetCell.swift
//  Twitter
//
//  Created by vu on 9/30/15.
//  Copyright © 2015 CodePath. All rights reserved.
//

import UIKit

//
// Delegate to handle reply and profile tap
//
@objc protocol TweetCellDelegate {
    optional func tweetCell(tweetCell: TweetCell, tweetAction value: String)
}

class TweetCell: UITableViewCell {

    weak var delegate: TweetCellDelegate?
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    
    @IBOutlet weak var onFavoriteButton: UIButton!
    @IBOutlet weak var onRetweetButton: UIButton!
    
    @IBAction func onReply(sender: AnyObject) {
        tweetActionClicked("TweetReply")
    }
    
    @IBAction func onRetweet(sender: AnyObject) {
        TwitterClient.sharedInstance.retweetWithId(tweet.tweetId!) { [weak self] (tweets, error) -> () in
            if error == nil {
                self!.onRetweetButton.setImage(UIImage(named: "retweet_on.png"), forState: UIControlState.Normal)
            } else {
                print("ERROR: \(error)")
            }
        }
    }
    
    @IBAction func onFavorite(sender: AnyObject) {
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

    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageView.layer.cornerRadius = 3

        //
        // Setup gesture recognizer on profile image
        //
        let singleTap = UITapGestureRecognizer(target: self, action: Selector("onProfileTap"))
        singleTap.numberOfTapsRequired = 1
        
        profileImageView.userInteractionEnabled = true
        profileImageView.addGestureRecognizer(singleTap)
    }
    
    //
    //
    //  Detect tap on profile image and call delegate, which will segue to profile view
    //
    func onProfileTap() {
        tweetActionClicked("ProfileTap")
    }

    //
    //
    //  Method that calls delegate
    //
    func tweetActionClicked(action: String) {
        delegate?.tweetCell!(self, tweetAction: action)
    }
    

    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
