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

   
    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var twitterSignInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.backgroundView.backgroundColor = UIColor(red: 0.098, green: 0.71, blue: 0.996, alpha: 1)
        self.twitterSignInButton.layer.borderWidth = 1
        self.twitterSignInButton.layer.borderColor = UIColor.whiteColor().CGColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func navigateToTwitterSessionScreen(session: TWTRSession) {
        self.performSegueWithIdentifier("ShowTwitterSession", sender: session)
    }

    @IBAction func signInWithTwitter(sender: AnyObject) {
        Twitter.sharedInstance().logInWithCompletion { (session: TWTRSession!, error: NSError!) -> Void in
            if session != nil {
                self.navigateToTwitterSessionScreen(session)
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowTwitterSession" {
            let vc = segue.destinationViewController as! TwitterSessionViewController
            vc.session = sender as! TWTRSession
        }
    }
}

