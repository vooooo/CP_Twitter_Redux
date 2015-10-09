//
//  ProfileHeaderCell.swift
//  Twitter
//
//  Created by vu on 10/6/15.
//  Copyright © 2015 CodePath. All rights reserved.
//

import UIKit

class ProfileHeaderCell: UITableViewCell {
    
    @IBOutlet weak var coverOpacityView: UIView!
    
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
        
    @IBOutlet weak var profileTweetsLabel: UILabel!
    @IBOutlet weak var profileFollowingLabel: UILabel!
    @IBOutlet weak var profileFollowersLabel: UILabel!
        
    override func awakeFromNib() {
        super.awakeFromNib()

        profileImageView.layer.cornerRadius = 5
        
        //
        // Notification as to when the user tried to refresh on the profile page.
        //
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "userDistortProfile", name: userDidDistortProfileNotification, object: nil)

    }
    
    //
    // Called when pull to refresh detected on profile view controller
    //
    func userDistortProfile() {

        //
        // Processing cover image
        //
        if coverImageView.image != nil {
            dispatch_async(dispatch_get_main_queue()) {
                
                //USING CORE GRAPHICS to scale images
                self.coverImageView.transform = CGAffineTransformMakeScale(2, 2)
                self.coverOpacityView.layer.opacity = self.coverOpacityView.layer.opacity - 0.5
                UIGraphicsEndImageContext()

                //USING CORE IMAGE to Blur
                //
                let context = CIContext(options: nil)
                let currentFilter = CIFilter(name: "CIGaussianBlur")
                let image = CIImage(image: self.coverImageView.image!)
                
                currentFilter!.setValue(image, forKey: kCIInputImageKey)
                let cgimg = context.createCGImage(currentFilter!.outputImage!, fromRect: currentFilter!.outputImage!.extent)
                
                let processedImage = UIImage(CGImage: cgimg)
                
                self.coverImageView.image = processedImage

            
            }
        } else {
            print("No cover Image available for profile")
        }
        
        //
        // Process profileimage
        //
        if profileImageView.image != nil {
            dispatch_async(dispatch_get_main_queue()) {
                self.profileImageView.transform = CGAffineTransformMakeScale(1.3, 1.3)
            }
        } else {
            print("No profile Image available")
        }

    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
