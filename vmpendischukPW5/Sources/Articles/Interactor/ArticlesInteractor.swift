//
//  ArticlesInteractor.swift
//  vmpendischukPW5
//
//  Created by Vladislav on 10.11.2021.
//

import Foundation

protocol ArticlesDataStore: ArticlesViewControllerOutputLogic { }

protocol ArticlesInteractorOutputLogic {
    func presentArticles(models: [ArticleModel]?)
    func presentError()
}

final class ArticlesInteractor {
    var articles: [ArticleModel]? {
        didSet {
            onNewsUpdate()
        }
    }
    
    var pageIndex: Int = 1
    var isFetching: Bool = false
    var output: ArticlesInteractorOutputLogic?
    var worker: ArticlesAPIWorkerLogic = ArticlesWorker()
    
    init(_ output: ArticlesInteractorOutputLogic?) {
        self.output = output
    }
    
    func onNewsLoad(_ articles: [ArticleModel]?, _ error: Error?) {
        isFetching = false
        
        if let articles = articles {
            self.articles = articles
            return
        }
        
        if error != nil {
            if pageIndex != 1 {
                pageIndex -= 1
            }
            output?.presentError()
        }
    }
    
    func onNewsUpdate() {
        output?.presentArticles(models: articles)
    }
}

extension ArticlesInteractor: ArticlesDataStore {
    func loadFreshNews() {
        isFetching = true
        worker.fetchNews(pageIndex: pageIndex, completion: onNewsLoad)
    }
    
    func loadMoreNews() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.isFetching = true
            self.pageIndex += 1
            self.worker.fetchNews(pageIndex: self.pageIndex, completion: self.onNewsLoad)
        }
    }
}
