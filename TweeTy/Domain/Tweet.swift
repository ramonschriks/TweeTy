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
    
    // Attributes
    var authorName: String?
    var created: String?
    var text: String?
    var profileImage: UIImage?
    
    // Mentions
    var images: [UIImage]?
    var hashtags: [String]?
    var urls: [String]?
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
        
        // Parse the rest of the data async
        DispatchQueue.global().async {
            self.parseHashtags()
            self.parseUsers()
            self.parseUrls()
            self.parseImages()
        }
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
    
    private func parseHashtags() {
        if let hashtags = self.sourceTweet["entities"]["hashtags"].array {
            self.hashtags = []
            for hashtag in hashtags {
                if let hashtagText = hashtag["text"].string {
                    self.hashtags?.append(hashtagText)
                }
            }
        }
    }
    
    private func parseUsers() {
        if let users = self.sourceTweet["entities"]["user_mentions"].array {
            self.users = []
            for user in users {
                if let userScreenName = user["screen_name"].string {
                    self.users?.append(userScreenName)
                }
            }
        }
    }
    
    private func parseUrls() {
        if let urls = self.sourceTweet["entities"]["urls"].array {
            self.urls = []
            for url in urls {
                if let urlText = url["url"].string {
                    self.urls?.append(urlText)
                }
            }
        }
    }

    private func parseImages() {
        if let images = self.sourceTweet["entities"]["media"].array {
            self.images = []
            for image in images {
                if let imageUrl = image["media_url_https"].string {
                    self.loadImage(withStringUrl: imageUrl) { image in
                        self.images?.append(image)
                    }
                }
            }
        }
    }
    
    private func loadImage(withStringUrl: String, completionHandler:@escaping (UIImage) -> ()) {
        if let url = URL(string: withStringUrl) {
            if let imageData = NSData.init(contentsOf: url) {
                completionHandler(UIImage(data: imageData as Data)!)
            }
        }
    }
}
