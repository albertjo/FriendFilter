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
  
    @IBOutlet weak var followeeTableView: UITableView!
    var session : TWTRSession!
    var userSession: TwitterSession?
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        cell.button.setTitle(nonfollower.following ? "unfollow" : "follow", forState: UIControlState.Normal)
        cell.button.addTarget(self, action: "twitterTableViewCellButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! TwitterTableViewCell
        cell.userInteractionEnabled = false
    }
    
    func receivedNotification(notification: NSNotification){
        self.updateView()
    }
    
    func updateView() {
        self.followeeTableView.reloadData()
    }
    
     func twitterTableViewCellButtonPressed(sender: UIButton!) {
        let row = sender.tag
        let nonfollower = self.userSession!.nonfollowers[row] as! TwitterUser
        if (nonfollower.following) {
            nonfollower.unfollow()
        } else {
            nonfollower.follow()
        }
        self.updateView()
    }
   

}
