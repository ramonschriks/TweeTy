//
//  TweetResultsTableViewController.swift
//  TweeTy
//
//  Created by Ramon Schriks on 04-10-17.
//  Copyright © 2017 Ramon Schriks. All rights reserved.
//

import UIKit
import CoreData
import TwitterKit

class TweetResultsTableViewController: UITableViewController {
    var searchText: String? { didSet{ updateUI() } }
    var managedObjectContext: NSManagedObjectContext? =
        (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    

    private var lastTwitterRequest: TwitterRequest?
    private var twitterRequest: TwitterRequest? {
        if lastTwitterRequest == nil {
            if self.searchText != nil {
                return TwitterRequest()
            }
        }
        return lastTwitterRequest
    }
    
    private var tweets: [Tweet]? {
        didSet { tableView.reloadData()}}
    
    private func updateUI() {
        self.title = searchText
        if !(searchText?.isEmpty)! {
            saveRecentSearch()
            loadTimeline()
        }
    }
    
    private func loadTimeline() {
        if let request = twitterRequest {
            lastTwitterRequest = request
            request.getTweets(withQuery: searchText!) { [weak weakSelf = self ] tweets in
                DispatchQueue.global(qos: .userInitiated).async {
                    var parsed: [Tweet] = []
                    for tweet in tweets {
                        tweet.parseTweet() { parsedTweet in     // Parse tweets on background
                            parsed.append(parsedTweet)
                        }
                    }
                    DispatchQueue.main.async {                  // Set the tweets back on the main queue
                        weakSelf?.tweets = parsed
                    }
                }
            }
        }
    }

    private func saveRecentSearch() {
        managedObjectContext?.perform {
            let recentSearch = O_RecentSearch(
                searchText: self.searchText!,
                date: Date(),
                resultCount: 1 // Not used atm
            )
            _ = RecentSearch.addRecentSearch(with: recentSearch, inManagedObjectContext: self.managedObjectContext!)
            
            do {
                try self.managedObjectContext?.save()
            } catch let error {
                print("Core Data Error: \(error)")
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tweets = self.tweets {
            return tweets.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweet", for: indexPath)
        
        if let sourceTweet = self.tweets?[indexPath.row] {
            if let tweetCell = cell as? TweetResultsTableViewCell {
                tweetCell.tweet = sourceTweet
            }
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let tweetCell = sender as? TweetResultsTableViewCell {
            if let tweetDetailVC = segue.destination.contents as? TweetDetailTableViewController {
                tweetDetailVC.tweet = tweetCell.tweet
            }
        }
    }
}
