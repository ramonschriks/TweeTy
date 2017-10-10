//
//  File.swift
//  TweeTy
//
//  Created by Ramon Schriks on 09-10-17.
//  Copyright © 2017 Ramon Schriks. All rights reserved.
//

import Foundation
import TwitterKit
import TwitterCore
import SwiftyJSON

class Tweet {
    let sourceTweet: JSON
    let searchText: String
    
    var authorName: String?
    var created: String?
    var text: String?
    var profileImage: UIImage?
    var images: [UIImage]?
    var hashtags: [String]?
    var urls: [URL]?
    var users: [String]?
    
    init(sourceTweet: JSON, searchText: String) {
        self.sourceTweet = sourceTweet
        self.searchText = searchText
    }
    
    public func parseTweet(completionHandler:@escaping (Tweet) -> ()) {
        self.parseProfileImage()
        if let screenName = self.sourceTweet["user"]["screen_name"].string {
            self.authorName = screenName
        }
        if let created = self.sourceTweet["created_at"].string {
            self.created = created
        }
        if let text = self.sourceTweet["full_text"].string {
            self.text = text
        }
        
        print(self.sourceTweet)
        
//        --PARSE THE OTHER DATA--
//        tweet.parseImages(with: mentions)
//        tweet.parseHashtags(with: mentions)
//        tweet.parseUsers(with: mentions)
//        tweet.parseUrls(with: mentions)
        
        completionHandler(self)
        
    }
    
    private func parseProfileImage() {
        var imageUrl: String = ""
        if let url = self.sourceTweet["user"]["profile_image_url_https"].string {
            imageUrl = url
        } else if let url = self.sourceTweet["user"]["profile_image_url"].string {
            imageUrl = url
        }
        
        self.loadImage(withStringUrl: imageUrl) { [weak self] image in
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

//    private func parseImages(with mentions: [String]) {
//        var images: [UIImage] = []
//        if let mediaEntities = self.sourceTweet.value(forKey: "media") as? NSArray {
//            for mediaEntity in mediaEntities{
//                print(mediaEntity)
//            }
//        }
//    }

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
