//
//  TweetComposeViewController.swift
//  Twitter
//
//  Created by vu on 10/2/15.
//  Copyright © 2015 CodePath. All rights reserved.
//

import UIKit

class TweetComposeViewController: UIViewController, UITextViewDelegate {

    var tweet: Tweet!

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var charCountLabel: UILabel!
    @IBOutlet weak var tweetTextView: UITextView!
    
    @IBAction func doTweet(sender: UIBarButtonItem) {
        let status = tweetTextView.text as String
        print("Submitting Tweet: \(status)")
        
        var in_reply_to_status_id = ""
        if tweet != nil {
            in_reply_to_status_id = tweet.tweetId!
        }
        
        TwitterClient.sharedInstance.tweetStatus(status, in_reply_to_status_id: in_reply_to_status_id) { [weak self] (tweets, error) -> () in
            if error == nil {
                self!.view.endEditing(true)
                self!.navigationController?.popViewControllerAnimated(true)
            } else {
                print("ERROR: \(error)")
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tweetTextView.delegate = self
        tweetTextView.becomeFirstResponder();

        if tweet != nil {
            print(tweet.user!.screenname!)
            
            tweetTextView.text = "@\(tweet.user!.screenname!)  "
            
        } else {
            tweetTextView.text = ""
        }

        let tweetcount = tweetTextView.text!.characters.count
        charCountLabel.text = String(tweetcount)

        nameLabel.text = User.currentUser?.name
        profileImageView.setImageWithURL(NSURL(string: User.currentUser!.profileImageUrl!))
        screennameLabel.text = "@\(User.currentUser!.screenname!)"
        
    }
    
    func textViewDidChange(textView: UITextView) {
        let tweetcount = textView.text.characters.count
        charCountLabel.text = String(tweetcount)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
