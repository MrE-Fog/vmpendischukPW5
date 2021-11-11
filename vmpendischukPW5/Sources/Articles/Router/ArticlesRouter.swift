//
//  ArticlesRouter.swift
//  vmpendischukPW5
//
//  Created by Vladislav on 10.11.2021.
//

import Foundation
import UIKit

protocol ArticlesRouterLogic {
    var viewController: ArticlesViewController? { get }
    
    func navigateToArticle(atIndex indexPath: IndexPath, animated: Bool)
    func sharePopover(atIndex indexPath: IndexPath, animated: Bool)
}

final class ArticlesRouter {
    weak var viewController: ArticlesViewController?
    
    init(_ viewController: ArticlesViewController) {
        self.viewController = viewController
    }
}

extension ArticlesRouter: ArticlesRouterLogic {
    func sharePopover(atIndex indexPath: IndexPath, animated: Bool) {
        if let articles = viewController?.output.articles, let viewController = viewController, indexPath.row < articles.count {
            let selection = articles[indexPath.row]
            guard let selectionURL = selection.articleUrl else { return }
            
            let activityViewController = UIActivityViewController(activityItems: [selectionURL.absoluteString], applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = viewController.view
            
            viewController.present(activityViewController, animated: animated, completion: nil)
        }
    }
    
    func navigateToArticle(atIndex indexPath: IndexPath, animated: Bool) {
        if let articles = viewController?.output.articles, indexPath.row < articles.count {
            let selection = articles[indexPath.row]
            guard let selectionURL = selection.articleUrl else { return }
            
            viewController?.navigationController?.pushViewController(ArticleViewController(selectionURL), animated: true)
        }
    }
}
