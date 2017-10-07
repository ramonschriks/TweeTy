//
//  TwitterType.swift
//  TweeTy
//
//  Created by Ramon Schriks on 05-10-17.
//  Copyright © 2017 Ramon Schriks. All rights reserved.
//

import Foundation
import TwitterKit

struct TwitterSearchRequest {

    static func doRequest(with searchText: String) -> TWTRTimelineDataSource? {
        
        switch searchText.characters.first {
        case .some("#"):
            return self.searchBy(hashtag: searchText)
        case .some("@"):
            return self.searchBy(user: searchText)
        default:
            if isUrl(query: searchText) {
                return self.searchBy(url: searchText)
            }
        }
        return nil
    }
    
    private static func searchBy(user: String) -> TWTRTimelineDataSource {
        return TWTRUserTimelineDataSource(screenName: user, apiClient: TWTRAPIClient())
    }
    
    private static func searchBy(hashtag: String) -> TWTRTimelineDataSource{
        return TWTRSearchTimelineDataSource(searchQuery: hashtag, apiClient: TWTRAPIClient())
    }
    
    private static func searchBy(url: String) -> TWTRTimelineDataSource {
        return TWTRSearchTimelineDataSource(searchQuery: url, apiClient: TWTRAPIClient())
    }
    
    private static let URLS = ["http", "www",".com",".nl"]
    private static func isUrl(query searchText: String) -> Bool {
        for url in URLS {
            if searchText.contains(url) {
                return true
            }
        }
        return false
    }
}




