//
//  MenuViewController.swift
//  Twitter
//
//  Created by vu on 10/6/15.
//  Copyright © 2015 CodePath. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    private var tweetsNavigationController: UIViewController!
    private var profileNavigationController: UIViewController!
    
    var viewControllers: [UIViewController] = []
    
    var hamburgerViewController: HamburgerViewController!
    let menuTitles = ["Tweets","Profile","Logout"]


    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        tweetsNavigationController = storyboard.instantiateViewControllerWithIdentifier("TweetsNavigationController")
        profileNavigationController = storyboard.instantiateViewControllerWithIdentifier("ProfileNavigationController")
        
        viewControllers.append(tweetsNavigationController)
        viewControllers.append(profileNavigationController)
        
        hamburgerViewController.contentViewController = tweetsNavigationController
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MenuCell", forIndexPath: indexPath) as! MenuCell
//        let titles = ["Tweets","Profile","Logout"]
        
        cell.menuLabel.text = menuTitles[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuTitles.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        hamburgerViewController.contentViewController = viewControllers[indexPath.row]
        
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
