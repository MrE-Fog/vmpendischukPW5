//
//  ArticleModel.swift
//  vmpendischukPW5
//
//  Created by Vladislav on 10.11.2021.
//

import Foundation

// MARK: - ArticlePageModel

/// _ArticlePageModel_ is a model that represents the article page object for API response decoding.
struct ArticlePageModel: Decodable {
    // News on the page.
    var news: [ArticleModel]?
    
    // Request ID for article content API calls.
    var requestId: String?
    
    // MARK: - Mutating
    
    /// Passes the page's _requestId_ to its articles.
    mutating func passTheRequestId() {
        for i in 0 ..< (news?.count ?? 0) {
            news?[i].requestId = requestId
        }
    }
}

// MARK: - ArticleModel

/// _ArticleModel_ is a model that represents the article object decoded from API response.
struct ArticleModel: Decodable {
    // ID of the article.
    var newsId: Int?
    
    // Article title.
    var title: String?
    
    // Article description.
    var announce: String?
    
    // Article image.
    var img: ImageContainer
    
    // Request ID for article content API calls.
    var requestId: String?
    
    // Article web page URL.
    var articleUrl: URL? {
        let requestId = requestId ?? ""
        let newsId = newsId ?? 0
        
        return URL(string: "https://news.myseldon.com/ru/news/index/\(newsId)?requestId=\(requestId)")
    }
}

// MARK: - ImageContainer

/// _ImageContainer_ is a model that represents a container for the image
/// decoded from API response.
struct ImageContainer: Decodable {
    var url: URL?
}
