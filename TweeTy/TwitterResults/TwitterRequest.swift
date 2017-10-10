//
//  TwitterRequest.swift
//  TweeTy
//
//  Created by Ramon Schriks on 10-10-17.
//  Copyright © 2017 Ramon Schriks. All rights reserved.
//

import Foundation
import TwitterKit
import SwiftyJSON

class TwitterRequest {
    
    public func getTweets(withQuery search: String, completionBlock: @escaping ([Tweet]) -> Void) {
        var query = "“\(search)”"
        if search.characters.first == "@" {
            query.append(" OR from:\(search.dropFirst())")
        }
    
        let client = TWTRAPIClient()
        let searchEndpoint = "https://api.twitter.com/1.1/search/tweets.json"
        let params = ["q": query, "tweet_mode": "extended", "count": "100"]
        var clientError : NSError?
        
        let request = client.urlRequest(withMethod: "GET", url: searchEndpoint, parameters: params, error: &clientError)
        
        client.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: [])
                if let JSONTweets = json as? [String: Any] {
                    if let tweets = JSONTweets["statuses"]{
                        
                        // Parse the tweets
                        var parsedTweets: [Tweet] = []
                        for (_ ,tweet) in JSON(tweets) {
                            parsedTweets.append(Tweet(sourceTweet: tweet, searchText: search))
                        }
                        completionBlock(parsedTweets)
                    }
                }
            } catch let jsonError as NSError {
                print("json error: \(jsonError.localizedDescription)")
            }
        }
    }
}
