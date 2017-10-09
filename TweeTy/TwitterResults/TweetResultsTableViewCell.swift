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
        
        if let tweet = self.tweet {
            tweetUserLabel?.text = "@\(tweet.sourceTweet.author.screenName)"
            tweetImage?.image = tweet.profileImage
            loadDate(date: tweet.sourceTweet.createdAt)
            
        
            let range = (tweet.sourceTweet.text.lowercased() as NSString).range(of: tweet.searchText.lowercased())
            let attributedString = NSMutableAttributedString(string: tweet.sourceTweet.text)
            attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.blue, range: range)
            tweetTextLabel?.attributedText = attributedString
        }
    }
    
    private func loadDate(date: Date) {
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.short
        formatter.timeStyle = DateFormatter.Style.short
        tweetDateLabel?.text = formatter.string(from: date)
    }
}
