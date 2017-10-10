//
//  TweetResultsTableViewCell.swift
//  TweeTy
//
//  Created by Ramon Schriks on 07-10-17.
//  Copyright © 2017 Ramon Schriks. All rights reserved.
//

import UIKit
import TwitterKit

class TweetResultsTableViewCell: UITableViewCell {
    @IBOutlet weak var tweetImage: UIImageView!
    @IBOutlet weak var tweetDateLabel: UILabel!
    @IBOutlet weak var tweetUserLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    
    var tweet: Tweet? { didSet { loadUI() } }

    private func loadUI() {
        // reset any existing tweet information
        tweetTextLabel?.attributedText = nil
        tweetUserLabel?.text = nil
        tweetImage?.image = nil
        tweetDateLabel?.text = nil

        if let tweet = self.tweet { // Force unwrap because we know at this point the values are parsed
            
            if let screenName = tweet.authorName {
                tweetUserLabel?.text = "@\(screenName)"
            }
            
            if let profileImage = tweet.profileImage {
                tweetImage?.image = profileImage
            }

            if let created = tweet.created {
                loadDate(date: created)
            }

            if let text = tweet.text {
                let range = (text.lowercased() as NSString).range(of: tweet.searchText.lowercased())
                let attributedString = NSMutableAttributedString(string: text)
                attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.blue, range: range)
                tweetTextLabel?.attributedText = attributedString
            }
        }
    }
    
    private func loadDate(date: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE MMM dd HH:mm:ss Z yyyy"
        
        if let date = formatter.date(from: date) {
            formatter.dateStyle = DateFormatter.Style.short
            formatter.timeStyle = DateFormatter.Style.short
            tweetDateLabel?.text = formatter.string(from: date)
        }
    }
}
