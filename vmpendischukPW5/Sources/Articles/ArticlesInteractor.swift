//
//  ArticlesInteractor.swift
//  vmpendischukPW5
//
//  Created by Vladislav on 10.11.2021.
//

import Foundation

protocol ArticlesDataStore {
    var articles: [ArticleModel]? { get set }
    
    func loadFreshNews()
}

protocol ArticlesBusinessLogic {
    func presentArtists()
}
