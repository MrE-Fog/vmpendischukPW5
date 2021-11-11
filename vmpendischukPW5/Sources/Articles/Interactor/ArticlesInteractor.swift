//
//  ArticlesInteractor.swift
//  vmpendischukPW5
//
//  Created by Vladislav on 10.11.2021.
//

import Foundation

// MARK: - ArticlesDataStore

/// _ArticlesDataStore_ is a protocol for article list data storage and view controller output behaviour.
protocol ArticlesDataStore: ArticlesViewControllerOutputLogic { }

// MARK: - ArticlesInteractorOutputLogic

/// _ArticlesInteractorOutputLogic_ is a protocol for article list interactor output behaviour.
protocol ArticlesInteractorOutputLogic {
    /// Handles article list presentation call for given article data models.
    ///
    /// - parameter models: Models for the presented articles.
    func presentArticles(models: [ArticleModel]?)
    
    /// Handles error presentation call.
    func presentError()
}

// MARK: - ArticlesInteractor

/// _ArticlesInteractor_ is a default VIP interactor class responsible for article list business logic.
final class ArticlesInteractor {
    // Presented articles.
    var articles: [ArticleModel] = [] {
        didSet {
            onNewsUpdate()
        }
    }
    
    // Current news page index.
    var pageIndex: Int = 1
    
    // Flag that indicates if interactor is in the
    // process of awaiting a fetch response.
    var isFetching: Bool = false
    
    // Interactor's output presenter.
    var output: ArticlesInteractorOutputLogic?
    
    // Interactor's worker.
    let worker: ArticlesAPIWorkerLogic = ArticlesWorker()
    
    // MARK: - Initializers
    
    /// Initializes an _ArticlesInteractor_ instance with given output presenter object.
    ///
    /// - parameter output: Output presenter object.
    ///
    /// - returns: _ArticlesInteractor_ instance.
    init(_ output: ArticlesInteractorOutputLogic?) {
        self.output = output
    }
    
    /// News fetch completion handler.
    ///
    /// - parameter articles: Articles fetched.
    /// - parameter error: Fetch error.
    func onNewsLoad(_ articles: [ArticleModel]?, _ error: Error?) {
        isFetching = false
        
        // If data was fetched successfully.
        if let articles = articles {
            self.articles.append(contentsOf: articles)
            return
        }
        
        // If fetch request resulted with error.
        if error != nil {
            if pageIndex != 1 {
                pageIndex -= 1
            }
            output?.presentError()
        }
    }
    
    /// News articles property update handler.
    private func onNewsUpdate() {
        // Presenting the articles via output presenter.
        output?.presentArticles(models: articles)
    }
}

// MARK: - ArticlesDataStore extension

extension ArticlesInteractor: ArticlesDataStore {
    /// Fetches news on the current page and updates the presented list.
    func loadFreshNews() {
        articles.removeAll()
        isFetching = true
        worker.fetchNews(pageIndex: pageIndex, completion: onNewsLoad)
    }
    
    /// Fetches news on the next page and updates the presented list.
    /// - ATTENTION: 1.5 second delay is set for the list update and fetch flow demostration purposes,
    ///              it can be safely removed.
    func loadMoreNews() {
        // Setting the delay.
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.isFetching = true
            self.pageIndex += 1
            self.worker.fetchNews(pageIndex: self.pageIndex, completion: self.onNewsLoad)
        }
    }
}
