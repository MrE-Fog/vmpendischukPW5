//
//  ArticlesPresenter.swift
//  vmpendischukPW5
//
//  Created by Vladislav on 10.11.2021.
//

import Foundation

// MARK: - ArticlesPresenterInputLogic

/// _ArticlesPresenterInputLogic_ is a protocol for articles list interactor output presenter behaviour.
protocol ArticlesPresenterInputLogic: ArticlesInteractorOutputLogic { }

// MARK: - ArticlesPresenterOutputLogic

/// _ArticlesPresenterOutputLogic_ is a protocol for the article list presenter output behaviour.
protocol ArticlesPresenterOutputLogic {
    /// Handles the display call for given article view model list.
    ///
    /// - parameter models: Models to display.
    func displayArticles(models: [ArticleViewModel]?)
    
    /// Handles the error display call.
    func displayError()
}

// MARK: - ArticlesPresenter

/// _ArticlesPresenter_ is a default article list presenter class
/// responsible for handling output presentation calls from interactor.
final class ArticlesPresenter {
    // Presenter output.
    var output: ArticlesPresenterOutputLogic?
    
    /// Initializes an _ArticlesPresenter_ instance with given output object.
    ///
    /// - parameter output: Presenter output object that handles display calls.
    init(_ output: ArticlesPresenterOutputLogic?) {
        self.output = output
    }
}

// MARK: - ArticlesPresenterInputLogic extension

extension ArticlesPresenter: ArticlesPresenterInputLogic {
    /// Handles article list presentation call for given article data models.
    ///
    /// - parameter models: Models for the presented articles.
    func presentArticles(models: [ArticleModel]?) {
        // Forming the view models.
        let viewModels = models?.compactMap { model -> ArticleViewModel in
            return ArticleViewModel(title: model.title, announce: model.announce, img: model.img, articleURL: model.articleUrl)
        }
        
        // Displaying the view models.
        output?.displayArticles(models: viewModels)
    }
    
    /// Handles error presentation call.
    func presentError() {
        // Displaying the error.
        output?.displayError()
    }
}
