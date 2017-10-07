//
//  TwitterClient.swift
//  TweeTy
//
//  Created by Ramon Schriks on 06-10-17.
//  Copyright © 2017 Ramon Schriks. All rights reserved.
//

import Foundation
import TwitterKit

class TwitterClient: TWTRTimelineViewController {
    let client = TWTRAPIClient()
    
    func searchTweet(with query: String, completionBlock: @escaping ([String]) -> Void) -> Void {
        let client = TWTRAPIClient()
        let searchEndpoint = "https://api.twitter.com/1.1/search/tweets.json"
        let params = ["q": query]
        var clientError : NSError?
        
        self.dataSource = TWTRListTimelineDataSource(listSlug: "surfing", listOwnerScreenName: "stevenhepting", apiClient: TWTRAPIClient())
        
//
//
//
//        let request = client.urlRequest(withMethod: "GET", url: searchEndpoint, parameters: params, error: &clientError)
//
//        client.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
//            if connectionError != nil {
//                print("Error: \(String(describing: connectionError))")
//            }
//
//            do {
//                let json = try JSONSerialization.jsonObject(with: data!, options: [])
//                if let JSONTweets = json as? [String: Any] {
//                    if let tweets = JSONTweets["statuses"] {
//                        let tweets = tweets as! [Any]
//                        print(tweets)
//                        let list = TWTRTweet.tweets(withJSONArray: tweets as! [Any])
//                    }
//                }
//
////                completionBlock(tweets)
//
//            } catch let jsonError as NSError {
//                print("json error: \(jsonError.localizedDescription)")
//            }
//        }
    }
}
