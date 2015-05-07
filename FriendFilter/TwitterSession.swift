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
    var followerIDs: NSMutableArray?
    var followeeIDs: NSMutableArray?
    
    init(session: TWTRSession) {
        self.session = session
    }
    
    func loadFollowerIDs() {
        let resourceURL = "https://api.twitter.com/1.1/followers/ids.json"
        //requestFromURLAndGetUsers(resourceURL)
        let request = self.getRequest(resourceURL)
        if request != nil {
            Twitter.sharedInstance().APIClient.sendTwitterRequest(request) {
                (response, data, connectionError) -> Void in
                if (connectionError == nil) {
                    var jsonError : NSError?
                    let jsonDict = self.parseJSON(data)
                    self.followerIDs = self.getIDsFromParsedJSONDictionary(jsonDict)
                }
            }
        }
    }
    
    func loadFolloweesIDs() {
        let resourceURL = "https://api.twitter.com/1.1/friends/ids.json"
        //requestFromURLAndGetUsers(resourceURL)
        let request = self.getRequest(resourceURL)
        if request != nil {
            Twitter.sharedInstance().APIClient.sendTwitterRequest(request) {
                (response, data, connectionError) -> Void in
                if (connectionError == nil) {
                    var jsonError : NSError?
                    let jsonDict = self.parseJSON(data)
                    self.followeeIDs = self.getIDsFromParsedJSONDictionary(jsonDict)
                }
            }
        }
    }
    
    private func getIDsFromParsedJSONDictionary(dictionary: NSDictionary) -> NSMutableArray {
        return dictionary["ids"] as! NSMutableArray
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