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
        //self.followeeTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
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
        cell.nameLabel?.text = nonfollower.name
        cell.screenNameLabel?.text = nonfollower.screenName
        //cell.button.addTarget(self, action: <#Selector#>, forControlEvents: <#UIControlEvents#>)
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
   

}
