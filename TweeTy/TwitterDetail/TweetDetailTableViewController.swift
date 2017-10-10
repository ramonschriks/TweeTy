//
//  TweetDetailTableViewCell.swift
//  TweeTy
//
//  Created by Ramon Schriks on 10-10-17.
//  Copyright © 2017 Ramon Schriks. All rights reserved.
//

import UIKit

class TweetDetailTableViewController: UITableViewController {
    var tweet: Tweet? { didSet { loadSections() }}
    var tweetSections: Dictionary<String, [Any]> = [:]
    
    
    // Note that the section key, is equal to the Cell identifier so that the cell can be retrieved dynamically in cellForRowAt
    private func loadSections() {
        if let hashtags = tweet?.hashtags {
            self.tweetSections["hashtags"] = hashtags
        }
        if let urls = tweet?.urls {
            self.tweetSections["urls"] = urls
        }
        if let users = tweet?.users {
            self.tweetSections["users"] = users
        }
        if let images = tweet?.images {
            self.tweetSections["images"] = images
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.tweetSections.count
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let key = Array(self.tweetSections.keys)[section]
        let tweetSection = tweetSections[key]
        if (tweetSection?.count == 0) {
            return 0.0
        }
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let key = Array(self.tweetSections.keys)[section]
        let tweetSection = tweetSections[key]
        return tweetSection?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Array(self.tweetSections.keys)[section]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = Array(self.tweetSections.keys)[indexPath.section]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        if let data = self.tweetSections[cellIdentifier]?[indexPath.row] {
            if let hashtagCell = cell as? HashtagTweetDetailTableViewCell {
                hashtagCell.hashtag.text = data as? String
            }
            
            if let userCell = cell as? UserTweetDetailTableViewCell {
                userCell.userScreenName.text = data as? String
            }
            
            if let urlCell = cell as? UrlTweetDetailTableViewCell {
                urlCell.urlLabel.text = data as? String
            }
            
            if let imageCell = cell as? ImageTweetDetailTableViewCell {
                imageCell.imageLabel = data as? UIImage
            }
        }
        return cell
    }
}
