//
//  ArticlesConfigurator.swift
//  vmpendischukPW5
//
//  Created by Vladislav on 10.11.2021.
//

import Foundation

// MARK: - ArticlesConfigurator

/// _ArticlesConfigurator_ is a default VIP cycle pathways configurator
/// for the _ArticlesViewController_ instances.
final class ArticlesConfigurator {
    /// Shared _ArticlesConfigurator_ singleton instance.
    static let shared = ArticlesConfigurator()
    
    // MARK: - Configuration
    
    /// Configures VIP cycle pathways for the given _ArticlesViewController_ instance.
    ///
    /// - parameter viewController: Instance for configuration.
    func configure(_ viewController: ArticlesViewController) {
        // Configuring VIP pathways.
        let presenter = ArticlesPresenter(viewController)
        let interactor = ArticlesInteractor(presenter)
        let router = ArticlesRouter(viewController)
        
        // Setting view controller data flow pathways.
        viewController.router = router
        viewController.output = interactor
    }
}
