//
//  ArticlesInteractor.swift
//  vmpendischukPW5
//
//  Created by Vladislav on 10.11.2021.
//

import Foundation

protocol ArticlesDataStore: ArticlesViewControllerOutput { }

protocol ArticlesInteractorOutput {
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
    var output: ArticlesInteractorOutput?
    var worker: ArticlesAPIWorkerLogic = ArticlesWorker()
    
    init(_ output: ArticlesInteractorOutput?) {
        self.output = output
    }
    
    func onNewsLoad(_ articles: [ArticleModel]?, _ error: Error?) {
        if let articles = articles {
            self.articles = articles
            return
        }
        
        if error != nil {
            pageIndex -= 1
            output?.presentError()
        }
    }
    
    func onNewsUpdate() {
        output?.presentArticles(models: articles)
    }
}

extension ArticlesInteractor: ArticlesDataStore {
    func loadFreshNews() {
        worker.fetchNews(pageIndex: pageIndex, completion: onNewsLoad)
    }
    
    func loadMoreNews() {
        pageIndex += 1
        worker.fetchNews(pageIndex: pageIndex, completion: onNewsLoad)
    }
}
