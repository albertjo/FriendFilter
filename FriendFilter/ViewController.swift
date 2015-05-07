//
//  ViewController.swift
//  FriendFilter
//
//  Created by Albert Jo on 5/6/15.
//  Copyright (c) 2015 Albert Jo. All rights reserved.
//

import UIKit
import TwitterKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func navigateToTwitterSessionScreen() {
        self.performSegueWithIdentifier("ShowTwitterSession", sender: self)
    }

    @IBAction func signInWithTwitter(sender: AnyObject) {
        Twitter.sharedInstance().logInWithCompletion { (session: TWTRSession!, error: NSError!) -> Void in
            if session != nil {
                self.navigateToTwitterSessionScreen()
            }
        }
    }

}

