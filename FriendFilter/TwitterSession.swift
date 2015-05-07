//
//  TwitterSession.swift
//  FriendFilter
//
//  Created by Albert Jo on 5/6/15.
//  Copyright (c) 2015 Albert Jo. All rights reserved.
//

import Foundation
import TwitterKit

class TwitterSession {
    var session: TWTRSession!
    var followers = NSMutableArray()
    var followees = NSMutableArray()
    var nonfollowers = NSMutableArray()
    
    init(session: TWTRSession) {
        self.session = session
        self.loadFollowees()
    }
    
    private func getNonfollowers() {
        for followee in followees {
            if !followers.containsObject(followee) {
               let followeeDict = followee as! NSDictionary
               let screenName = followeeDict["screen_name"]! as! String
               let name = followeeDict["name"] as! String
               let id = followeeDict["id"] as! NSNumber
               let user = TwitterUser(session: self.session, userID: "\(id)", screenName: "@\(screenName)", name: name)
                
               self.nonfollowers.addObject(user)
            }
        }
    }
    
    private func loadFollowers() {
        let resourceURL = "https://api.twitter.com/1.1/followers/list.json"
        let request = self.getRequest(resourceURL)
        if request != nil {
            Twitter.sharedInstance().APIClient.sendTwitterRequest(request) {
                (response, data, connectionError) -> Void in
                if (connectionError == nil) {
                    var jsonError : NSError?
                    let jsonDict = self.parseJSON(data)
                    self.followers = NSMutableArray(array: jsonDict["users"] as! NSArray)
                    self.getNonfollowers()
                    NSNotificationCenter.defaultCenter().postNotificationName("RetrievedNonfollowers", object: nil)
                }
            }
        }
    }
    
    private func loadFollowees() {
        let resourceURL = "https://api.twitter.com/1.1/friends/list.json"
        let request = self.getRequest(resourceURL)
        if request != nil {
            Twitter.sharedInstance().APIClient.sendTwitterRequest(request) {
                (response, data, connectionError) -> Void in
                if (connectionError == nil) {
                    var jsonError : NSError?
                    let jsonDict = self.parseJSON(data)
                    self.followees = NSMutableArray(array: jsonDict["users"] as! NSArray)
                    self.loadFollowers()
                }
            }
        }
    }
    
    private func getIDsFromParsedJSONDictionary(dictionary: NSDictionary) -> NSMutableArray {
        var ids = NSMutableArray(array: dictionary["ids"] as! NSArray)
        return ids
    }
    
    private func getRequest(resourceURL: String) -> NSURLRequest? {
        let params = ["id": session.userID, "count": "200", "skip_status": "true"]
        var clientError : NSError?
        return Twitter.sharedInstance().APIClient.URLRequestWithMethod("GET", URL: resourceURL, parameters: params,error: &clientError)
    }

    private func parseJSON(inputData: NSData) -> NSDictionary {
        var error: NSError?
        var boardsDictionary: NSDictionary = NSJSONSerialization.JSONObjectWithData(inputData, options: NSJSONReadingOptions.MutableContainers, error: &error)as! NSDictionary
        return boardsDictionary
    }
    
    
}