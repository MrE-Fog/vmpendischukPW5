//
//  ArticlesConfigurator.swift
//  vmpendischukPW5
//
//  Created by Vladislav on 10.11.2021.
//

import Foundation

final class ArticlesConfigurator {
    static let shared = ArticlesConfigurator()
    
    func configure(_ viewController: ArticlesViewController) {
        let presenter = ArticlesPresenter(viewController)
        let interactor = ArticlesInteractor(presenter)
        let router = ArticlesRouter(viewController)
        
        viewController.router = router
        viewController.output = interactor
    }
}
