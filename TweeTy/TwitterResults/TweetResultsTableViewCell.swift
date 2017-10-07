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
    
    var tweet: TWTRTweet? { didSet { loadUI() } }
    
    private func loadUI() {
        // reset any existing tweet information
        tweetTextLabel?.attributedText = nil
        tweetUserLabel?.text = nil
        tweetImage?.image = nil
        tweetDateLabel?.text = nil
        
        if let tweet = self.tweet {
            tweetTextLabel?.text = tweet.text
            tweetUserLabel?.text = "@\(tweet.author.screenName)"
           
            loadImage(with: tweet.author.profileImageURL)
            loadDate(date: tweet.createdAt)
        }
    }
    private func loadDate(date: Date) {
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.short
        formatter.timeStyle = DateFormatter.Style.short
        tweetDateLabel?.text = formatter.string(from: date)
    }
    
    private func loadImage(with stringURL: String) {
        if let url = URL(string: stringURL) {
            DispatchQueue.main.async() { [weak self] in
                if let imageData = NSData.init(contentsOf: url) {
                    self?.tweetImage?.image = UIImage(data: imageData as Data)
                }
            }
        }
    }
}
