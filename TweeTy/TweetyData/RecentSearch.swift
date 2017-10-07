//
//  RecentSearch.swift
//  TweeTy
//
//  Created by Ramon Schriks on 04-10-17.
//  Copyright © 2017 Ramon Schriks. All rights reserved.
//

import UIKit
import CoreData

class RecentSearch: NSManagedObject {
    static let entityName = "RecentSearch"
        
    class func addRecentSearch(with searchRequest: O_RecentSearch, inManagedObjectContext context: NSManagedObjectContext) -> RecentSearch? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: self.entityName)
        request.predicate = NSPredicate(format: "searchText = %@", searchRequest.searchText)
        
        if let recentSearch = (try? context.fetch(request))?.first as? RecentSearch {
            recentSearch.date = Date()
            recentSearch.resultCount = searchRequest.resultCount
            return recentSearch
        } else if let recentSearch = NSEntityDescription.insertNewObject(forEntityName: self.entityName, into: context) as? RecentSearch {
            recentSearch.searchText = searchRequest.searchText
            recentSearch.resultCount = searchRequest.resultCount
            recentSearch.date = searchRequest.date
            return recentSearch
        }
        return nil
    }
}
