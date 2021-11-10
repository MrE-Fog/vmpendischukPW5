//
//  ArticlesPresenter.swift
//  vmpendischukPW5
//
//  Created by Vladislav on 10.11.2021.
//

import Foundation

protocol ArticlesPresenterInputLogic: ArticlesInteractorOutput { }

protocol ArticlesPresenterOutputLogic {
    func displayArticles(models: [ArticleViewModel]?)
    func displayError()
}

final class ArticlesPresenter: ArticlesPresenterInputLogic {
    var output: ArticlesPresenterOutputLogic?
    
    init(_ output: ArticlesPresenterOutputLogic?) {
        self.output = output
    }
    
    func presentArticles(models: [ArticleModel]?) {
        let viewModels = models?.compactMap { model -> ArticleViewModel in
            return ArticleViewModel(title: model.title, announce: model.announce, img: model.img, articleURL: model.articleUrl)
        }
        
        output?.displayArticles(models: viewModels)
    }
    
    func presentError() {
        output?.displayError()
    }
}
