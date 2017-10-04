//
//  RecentSearchesTableViewController.swift
//  TweeTy
//
//  Created by Ramon Schriks on 04-10-17.
//  Copyright © 2017 Ramon Schriks. All rights reserved.
//

import UIKit
import CoreData

class RecentSearchesTableViewController: CoreDataTableViewController, UISearchBarDelegate {
    var managedObjectContext: NSManagedObjectContext? =
        (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    /**
     * OUTLETS
     **/
    @IBOutlet weak var tweetySearchBar: UISearchBar! {
        didSet { tweetySearchBar.delegate = self}
    }
    
    // MARK: View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadRecentSearches()
    }
    
    private func loadRecentSearches() {
        if let context = managedObjectContext {
            let request = NSFetchRequest<RecentSearch>(entityName: "RecentSearch")
            request.sortDescriptors = [NSSortDescriptor(key: "searchText", ascending: true)]
            fetchedResultsController = NSFetchedResultsController(
                fetchRequest: request,
                managedObjectContext: context,
                sectionNameKeyPath: nil,
                cacheName: nil
                ) as? NSFetchedResultsController<NSFetchRequestResult>
        } else {
            fetchedResultsController = nil
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecentSearchesCell", for: indexPath)
        
        if let recentsCell = cell as? RecentSearchesTableViewCell {
            if let recentSearch = fetchedResultsController?.object(at: indexPath) as? RecentSearch {
                
                recentSearch.managedObjectContext?.performAndWait {
                    recentsCell.date?.text = String(describing: recentSearch.date)
                    recentsCell.resultCount?.text = String(recentSearch.resultCount)
                    recentsCell.searchText?.text = recentSearch.searchText
                }
            }
        }
        return cell
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if (tweetySearchBar.text?.isEmpty)! {
            return false
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "search" {
            let tweetySearchText = tweetySearchBar.text
            print(segue.destination.contents)
            if let tweetsVC = segue.destination.contents as? TweetResultsTableViewController {
                tweetsVC.managedObjectContext = self.managedObjectContext
                tweetsVC.searchText = tweetySearchText
            }
        }
    }
}

extension UIViewController {
    var contents: UIViewController {
        if let navcon = self as? UINavigationController {
            return navcon.visibleViewController ?? self
        }
        return self
    }
}



