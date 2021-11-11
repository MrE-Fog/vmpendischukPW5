//
//  ArticlesRouter.swift
//  vmpendischukPW5
//
//  Created by Vladislav on 10.11.2021.
//

import Foundation
import UIKit

// MARK: - ArticlesRouterLogic

/// _ArticlesRouterLogic_ is a protocol for articles list router behaviour.
protocol ArticlesRouterLogic {
    var viewController: ArticlesViewController? { get }
    
    /// Handles navigation to the _ArticleViewController_ representing the selected article's content.
    ///
    /// - parameter indexPath: Index path to the selected article.
    /// - parameter animated: Flag that indicates if the transition should be animated.
    func navigateToArticle(atIndex indexPath: IndexPath, animated: Bool)
    
    /// Handles the article URL share window popover.
    ///
    /// - parameter indexPath: Index path to the selected article.
    /// - parameter animated: Flag that indicates if the transition should be animated.
    func sharePopover(atIndex indexPath: IndexPath, animated: Bool)
}

// MARK: - ArticlesRouter

/// _ArticlesRouter_ is a default VIP router from _ArticlesViewController_ instances.
final class ArticlesRouter {
    // Routing source.
    weak var viewController: ArticlesViewController?
    
    // MARK: - Initializers
    
    /// Initializes an  _ArticlesRouter_ instance with given _ArticlesViewController_ routing source.
    ///
    /// - parameter viewController: _ArticlesViewController_ routing source.
    ///
    /// - returns _ArticlesRouter_ instance.
    init(_ viewController: ArticlesViewController) {
        self.viewController = viewController
    }
}

// MARK: - ArticlesRouterLogic extension

extension ArticlesRouter: ArticlesRouterLogic {
    /// Handles navigation to the _ArticleViewController_ representing the selected article's content.
    ///
    /// - parameter indexPath: Index path to the selected article.
    /// - parameter animated: Flag that indicates if the transition should be animated.
    func navigateToArticle(atIndex indexPath: IndexPath, animated: Bool) {
        // Check if index is in bounds and articles are set.
        if let articles = viewController?.output.articles, indexPath.row < articles.count {
            let selection = articles[indexPath.row]
            guard let selectionURL = selection.articleUrl else { return }
            
            // Navigating to the article view controller.
            viewController?.navigationController?.pushViewController(ArticleViewController(selectionURL), animated: true)
        }
    }
    
    /// Handles the article URL share window popover.
    ///
    /// - parameter indexPath: Index path to the selected article.
    /// - parameter animated: Flag that indicates if the transition should be animated.
    func sharePopover(atIndex indexPath: IndexPath, animated: Bool) {
        // Check if index is in bounds, articles and source view controller are set.
        if let articles = viewController?.output.articles, let viewController = viewController, indexPath.row < articles.count {
            let selection = articles[indexPath.row]
            guard let selectionURL = selection.articleUrl else { return }
            
            // Initializing the share activityViewController.
            let activityViewController = UIActivityViewController(activityItems: [selectionURL.absoluteString], applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = viewController.view
            
            // Presenting the share window popover.
            viewController.present(activityViewController, animated: animated, completion: nil)
        }
    }
}
