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
    var username: String
    var name : String
    var user_id: Int

    init(session: TWTRSession!, username: String, name: String, id: Int) {
        self.session = session
        self.username = username
        self.name = name
        self.user_id = id
    }
    
    func unfollow() {

        
        /*let statusesShowEndpoint = "https://api.twitter.com/1.1/statuses/show.json"
        let params = ["id": "20"]
        var clientError : NSError?
        
        let request = Twitter.sharedInstance().APIClient.
            URLRequestWithMethod(
                "GET", URL: statusesShowEndpoint, parameters: params,
                error: &clientError)
        
        if request != nil {
            Twitter.sharedInstance().APIClient.
                sendTwitterRequest(request) {
                    (response, data, connectionError) -> Void in
                    if (connectionError == nil) {
                        var jsonError : NSError?
                        let json : AnyObject? =
                        NSJSONSerialization.JSONObjectWithData(data,
                            options: nil,
                            error: &jsonError)
                    }
                    else {
                        println("Error: \(connectionError)")
                    }
            }
        }
        else {
            println("Error: \(clientError)")
        }*/
        
    }
}
