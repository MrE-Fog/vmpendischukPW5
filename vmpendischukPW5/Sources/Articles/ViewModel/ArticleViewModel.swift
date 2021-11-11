//
//  ArticleViewModel.swift
//  vmpendischukPW5
//
//  Created by Vladislav on 10.11.2021.
//

import Foundation

// MARK: - ArticleViewModel

/// _ArticleViewModel_ is a view model that represents displayed info on the article.
struct ArticleViewModel {
    // Article title.
    let title: String?
    
    // Article description.
    let announce: String?
    
    // Article image.
    let img: ImageContainer
    
    // Article web page URL.
    let articleURL: URL?
}
