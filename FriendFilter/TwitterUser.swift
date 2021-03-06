//
//  TwitterUser.swift
//  FriendFilter
//
//  Created by Albert Jo on 5/6/15.
//  Copyright (c) 2015 Albert Jo. All rights reserved.
//

import Foundation
import TwitterKit

class TwitterUser {
    var session: TWTRSession!
    var userID: String
    var name: String
    var screenName: String
    var toUnfollow: Bool

    init(session: TWTRSession!, userID: String, screenName: String, name: String) {
        self.session = session
        self.userID = userID
        self.name = name
        self.screenName = screenName
        self.toUnfollow = false
    }
    
    func unfollow() {

        let resourceURL = "https://api.twitter.com/1.1/friendships/destroy.json"
        let params = ["id": self.userID]
        var clientError : NSError?
        
        let request = Twitter.sharedInstance().APIClient.URLRequestWithMethod("POST", URL: resourceURL, parameters: params, error: &clientError)
        
        if request != nil {
            Twitter.sharedInstance().APIClient.sendTwitterRequest(request) {
                (response, data, connectionError) -> Void in
                if (connectionError == nil) {
                    var jsonError : NSError?
                    let jsonDict = self.parseJSON(data)
                }
            }
        }
        
    }
    
    func follow() {
        let resourceURL = "https://api.twitter.com/1.1/friendships/create.json"
        let params = ["id": self.userID]
        var clientError : NSError?
        
        let request = Twitter.sharedInstance().APIClient.URLRequestWithMethod("POST", URL: resourceURL, parameters: params, error: &clientError)
        
        if request != nil {
            Twitter.sharedInstance().APIClient.sendTwitterRequest(request) {
                (response, data, connectionError) -> Void in
                if (connectionError == nil) {
                    var jsonError : NSError?
                    let jsonDict = self.parseJSON(data)
                }
            }
        }
    }
    
    private func parseJSON(inputData: NSData) -> NSDictionary {
        var error: NSError?
        var boardsDictionary: NSDictionary = NSJSONSerialization.JSONObjectWithData(inputData, options: NSJSONReadingOptions.MutableContainers, error: &error)as! NSDictionary
        return boardsDictionary
    }
}
