//
//  TwitterSessionViewController.swift
//  FriendFilter
//
//  Created by Albert Jo on 5/6/15.
//  Copyright (c) 2015 Albert Jo. All rights reserved.
//

import UIKit
import TwitterKit

class TwitterSessionViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {
  
    var session : TWTRSession!
    var userSession: TwitterSession?
    var unfollowedAll = false
    let redcolor = UIColor(red: 214/255, green: 69/255, blue: 65/255, alpha: 1) //214, 69, 65
    let bluecolor = UIColor(red: 25/255, green: 181/255, blue: 254/255, alpha: 1) //25, 181, 254
    
    @IBOutlet weak var unfollowAllButton: UIButton!
    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var followeeTableView: UITableView!
    @IBOutlet weak var statisticsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.statisticsLabel.text = "0 selected"
        self.backgroundView.backgroundColor = UIColor(red: 0.098, green: 0.71, blue: 0.996, alpha: 1)
        self.unfollowAllButton.layer.borderWidth = 1
        self.unfollowAllButton.layer.borderColor = UIColor.whiteColor().CGColor
        
        self.userSession = TwitterSession(session: self.session)
        
        // tableview related 
        var nib = UINib(nibName: "TwitterTableViewCell", bundle: nil)
        self.followeeTableView.registerNib(nib, forCellReuseIdentifier: "cell")
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "receivedNotification:", name:"RetrievedNonfollowers", object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userSession!.nonfollowers.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! TwitterTableViewCell
        let row = indexPath.row
        let nonfollower = self.userSession!.nonfollowers[row] as! TwitterUser
        
        // cell label config
        cell.nameLabel?.text = nonfollower.name
        cell.screenNameLabel?.text = nonfollower.screenName
        
        // button config
        cell.button.tag = row
        cell.button.setTitle(!nonfollower.toUnfollow ? "unfollow" : "follow", forState: UIControlState.Normal)
        cell.button.setTitleColor(!nonfollower.toUnfollow ? self.redcolor : self.bluecolor, forState: UIControlState.Normal)
        cell.button.addTarget(self, action: "twitterTableViewCellButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        
        return cell
    }
    
    func receivedNotification(notification: NSNotification){
        self.updateView()
    }
    
    func updateView() {
        self.followeeTableView.reloadData()
        self.unfollowAllButton.setTitle(self.unfollowedAll ? "Follow All" : "Unfollow All", forState: UIControlState.Normal)
        
        var count = 0
        for object in self.userSession!.nonfollowers {
            let nonfollower = object as! TwitterUser
            if (nonfollower.toUnfollow) {
                count++
            }
        }
        
        self.statisticsLabel.text = "\(self.userSession!.nonfollowers.count) | \(count)"
    }
    
     func twitterTableViewCellButtonPressed(sender: UIButton!) {
        let row = sender.tag
        let nonfollower = self.userSession!.nonfollowers[row] as! TwitterUser
        if (nonfollower.toUnfollow) {
            nonfollower.toUnfollow = false
        } else {
            nonfollower.toUnfollow = true
        }
        self.updateView()
    }
   
    @IBAction func unfollowAll(sender: AnyObject) {
        for object in self.userSession!.nonfollowers {
            let nonfollower = object as! TwitterUser
            if (!self.unfollowedAll) {
                nonfollower.toUnfollow = true
            } else {
                nonfollower.toUnfollow = false
            }
        }
        self.unfollowedAll = !self.unfollowedAll
        self.updateView()
    }

    @IBAction func clearUnfollowingUsers(sender: AnyObject) {
        for object in self.userSession!.nonfollowers {
            let nonfollower = object as! TwitterUser
            if (nonfollower.toUnfollow) {
                nonfollower.unfollow()
                self.userSession!.nonfollowers.removeObject(nonfollower)
            }
        }
        self.updateView()
    }
}
