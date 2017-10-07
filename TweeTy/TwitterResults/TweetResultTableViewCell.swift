//
//  TweetResultTableViewCell.swift
//  TweeTy
//
//  Created by Ramon Schriks on 05-10-17.
//  Copyright © 2017 Ramon Schriks. All rights reserved.
//

import UIKit

class TweetResultTableViewCell: UITableViewCell {
    @IBOutlet weak var tweeter: UILabel!
    @IBOutlet weak var tweetText: UILabel!
    @IBOutlet weak var tweetDate: UILabel!
    @IBOutlet weak var tweetProfileImage: UIImageView!
    
    var JSONTweet: (String, Any)? {
        didSet {
            fetchJSONTweet();
        }
    }
    
    private func fetchJSONTweet() {
        
    }
}
