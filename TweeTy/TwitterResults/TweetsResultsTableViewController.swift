//
//  TweetResultsTableViewController.swift
//  TweeTy
//
//  Created by Ramon Schriks on 04-10-17.
//  Copyright © 2017 Ramon Schriks. All rights reserved.
//

import UIKit
import CoreData

class TweetResultsTableViewController: CoreDataTableViewController {
    var searchText: String? { didSet{ updateUI() } }
    var managedObjectContext: NSManagedObjectContext? =
        (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private func updateUI() {
        self.title = searchText
        saveRecentSearch()
    }
    
    private func saveRecentSearch() {
        managedObjectContext?.perform {
            let recentSearch = O_RecentSearch(
                searchText: self.searchText!,
                date: Date(),
                resultCount: 1
            )
            _ = RecentSearch.addRecentSearch(with: recentSearch, inManagedObjectContext: self.managedObjectContext!)
            
            do {
                try self.managedObjectContext?.save()
            } catch let error {
                print("Core Data Error: \(error)")
            }
        }
        printDatabaseStatistics()
    }
    
    private func printDatabaseStatistics() {
        managedObjectContext?.perform {
            if let results = try? self.managedObjectContext!.fetch(NSFetchRequest(entityName: "RecentSearch")) {
                print("\(results.count) Recents")
            }
        }
    }
}

