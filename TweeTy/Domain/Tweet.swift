//
//  File.swift
//  TweeTy
//
//  Created by Ramon Schriks on 09-10-17.
//  Copyright © 2017 Ramon Schriks. All rights reserved.
//

import Foundation
import TwitterKit

class Tweet {
    let sourceTweet: TWTRTweet
    let searchText: String
    
    var profileImage: UIImage?
    var images: [UIImage]?
    var hashtags: [String]?
    var urls: [URL]?
    var users: [String]?
    
    private init(_ sourceTweet: TWTRTweet, _ searchText: String) {
        self.sourceTweet = sourceTweet
        self.searchText = searchText
    }
    
    public static func parseTweet(withSourceTweet: TWTRTweet, searchText: String, completionHandler:@escaping (Tweet) -> ()) {
        let tweet = Tweet(withSourceTweet, searchText)
        let mentions = tweet.sourceTweet.text.components(separatedBy: " ")
        tweet.parseProfileImage(with: tweet.sourceTweet.author.profileImageURL)
       
        DispatchQueue.main.async {
            //tweet.parseImages(with: mentions)
            tweet.parseHashtags(with: mentions)
            tweet.parseUsers(with: mentions)
            tweet.parseUrls(with: mentions)
        }
        completionHandler(tweet)
    }
    
    private func parseProfileImage(with profileImageUrl: String) {
        self.loadImage(withStringUrl: profileImageUrl) { [weak self] image in
            self?.profileImage = image
        }
    }
    
    private func parseHashtags(with mentions: [String]) {
        var hashtags: [String] = []
        for mention in mentions {
            if mention.characters.first == "#" {
                hashtags.append(mention)
            }
        }
        self.hashtags = hashtags
    }
    
    private func parseUsers(with mentions: [String]) {
        var users: [String] = []
        for mention in mentions {
            if mention.characters.first == "@" {
                users.append(mention)
            }
        }
        self.users = users
    }
    
    private func parseImages(with mentions: [String]) {
        var images: [UIImage] = []
        for mention in mentions {
            if mention.contains("https://t.co") {
                loadImage(withStringUrl: mention) { image in
                    images.append(image)
                }
            }
        }
        self.images = images
    }

    private func parseUrls(with mentions: [String]) {
        var urls: [URL] = []
        for mention in mentions {
            if mention.contains("https://") || mention.contains("www"){
                urls.append(URL(fileURLWithPath: mention))
            }
        }
        self.urls = urls
    }
    
    private func loadImage(withStringUrl: String, completionHandler:@escaping (UIImage) -> ()) {
        if let url = URL(string: withStringUrl) {
            if let imageData = NSData.init(contentsOf: url) {
                completionHandler(UIImage(data: imageData as Data)!)
            }
        }
    }
}
