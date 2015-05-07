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
    var followerIDs = NSMutableArray()
    var followeeIDs = NSMutableArray()
    var nonfollowerIDs = NSMutableArray()
    
    init(session: TWTRSession) {
        self.session = session
        self.loadFolloweeIDs()
    }
    
    private func getFolloweesThatAreNotFollowers() {
        for followee in self.followeeIDs {
            if !self.followerIDs.containsObject(followee) {
                self.nonfollowerIDs.addObject(followee)
            }
        }
    }
    
    private func loadFollowerIDs() {
        let resourceURL = "https://api.twitter.com/1.1/followers/ids.json"
        let request = self.getRequest(resourceURL)
        if request != nil {
            Twitter.sharedInstance().APIClient.sendTwitterRequest(request) {
                (response, data, connectionError) -> Void in
                if (connectionError == nil) {
                    var jsonError : NSError?
                    let jsonDict = self.parseJSON(data)
                    self.followerIDs = self.getIDsFromParsedJSONDictionary(jsonDict)
                    self.getFolloweesThatAreNotFollowers()
                    
                    NSNotificationCenter.defaultCenter().postNotificationName("RetrievedNonfollowers", object: nil)
                }
            }
        }
    }
    
    private func loadFolloweeIDs() {
        let resourceURL = "https://api.twitter.com/1.1/friends/ids.json"
        let request = self.getRequest(resourceURL)
        if request != nil {
            Twitter.sharedInstance().APIClient.sendTwitterRequest(request) {
                (response, data, connectionError) -> Void in
                if (connectionError == nil) {
                    var jsonError : NSError?
                    let jsonDict = self.parseJSON(data)
                    self.followeeIDs = self.getIDsFromParsedJSONDictionary(jsonDict)
                    self.loadFollowerIDs()
                }
            }
        }
    }
    
    private func getIDsFromParsedJSONDictionary(dictionary: NSDictionary) -> NSMutableArray {
        var ids = NSMutableArray(array: dictionary["ids"] as! NSArray)
        return ids
    }
    
    private func getRequest(resourceURL: String) -> NSURLRequest? {
        let params = ["id": session.userID]
        var clientError : NSError?
        return Twitter.sharedInstance().APIClient.URLRequestWithMethod("GET", URL: resourceURL, parameters: params,error: &clientError)
    }

    private func parseJSON(inputData: NSData) -> NSDictionary {
        var error: NSError?
        var boardsDictionary: NSDictionary = NSJSONSerialization.JSONObjectWithData(inputData, options: NSJSONReadingOptions.MutableContainers, error: &error)as! NSDictionary
        return boardsDictionary
    }
    
    
}