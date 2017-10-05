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
    override func viewDidAppear(_ animated: Bool) {
        loadRecentSearches()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    private func loadRecentSearches() {
        if let context = managedObjectContext {
            let request = NSFetchRequest<RecentSearch>(entityName: "RecentSearch")
            request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
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
                    recentsCell.date?.text = formatDate(with: recentSearch.date!)
                    recentsCell.searchText?.text = recentSearch.searchText
                }
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            if let recentSearch = fetchedResultsController?.object(at: indexPath) as? RecentSearch {
                managedObjectContext?.delete(recentSearch)

                do {
                    try self.managedObjectContext?.save()
                } catch let error {
                    print("Core Data Error: \(error)")
                }
            }
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "search", (tweetySearchBar.text?.isEmpty)! {
            return false
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let tweetsVC = segue.destination.contents as? TweetResultsTableViewController {
            switch segue.identifier {
            case .some("recent"):
                if let cell = sender as? RecentSearchesTableViewCell {
                    tweetsVC.searchText = cell.searchText.text
                }
            case .some("search"):
                tweetsVC.searchText = tweetySearchBar.text
            default:
                tweetsVC.searchText = ""
            }
            tweetsVC.managedObjectContext = self.managedObjectContext
            tweetySearchBar.text = ""
        }
    }
    
    private func formatDate(with date: Date) -> String {
       let formatter = DateFormatter()
        formatter.dateFormat = "E, d MMM yyyy HH:mm:ss"
        return formatter.string(from: date)
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



