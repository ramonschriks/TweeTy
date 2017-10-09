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

class TweetResultsTableViewController: TWTRTimelineViewController {
    var searchText: String? { didSet{ updateUI() } }
    var managedObjectContext: NSManagedObjectContext? =
        (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var searchRequest: TwitterSearchRequest?

    private func updateUI() {
        self.title = searchText
        if !(searchText?.isEmpty)! {
            saveRecentSearch()
            loadTimeline()
        }
    }
    
    private func loadTimeline() {
        if searchText != nil, let datasource = TwitterSearchRequest.doRequest(with: searchText!) {
            self.dataSource = datasource
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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweet", for: indexPath)
        
        let sourceTweet = self.tweet(at: indexPath.row)
        if let tweetCell = cell as? TweetResultsTableViewCell {
            Tweet.parseTweet(withSourceTweet: sourceTweet, searchText: self.searchText!) { tweet in
                tweetCell.tweet = tweet
            }
        }
        return cell
    }
}
