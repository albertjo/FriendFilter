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
    var nonfollowers = NSMutableArray()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userSession = TwitterSession(session: self.session)
        
        
        self.followeeTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "receivedNotification:", name:"RetrievedNonfollowers", object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.nonfollowers.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
        let row = indexPath.row
        let nonfollower = self.nonfollowers[row] as! TwitterUser
        
        cell.textLabel?.text = nonfollower.userID
        return cell
    
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func receivedNotification(notification: NSNotification){
        self.aggregateNonfollowers()
        self.updateView()
    }
    
    func updateView() {

        self.followeeTableView.reloadData()
    }
    
    private func aggregateNonfollowers() {
        for id in userSession!.nonfollowerIDs {
            let user = TwitterUser(session: self.session, userID: "\(id)")
            self.nonfollowers.addObject(user)
        }
    }
   
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    /*override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print(sender)
    }*/
}
