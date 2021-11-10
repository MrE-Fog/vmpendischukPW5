//
//  ViewController.swift
//  vmpendischukPW5
//
//  Created by Vladislav on 10.11.2021.
//

import UIKit

protocol ArticlesViewControllerInput : ArticlesPresenterOutputLogic { }

protocol ArticlesViewControllerOutput {
    var articles: [ArticleModel]? { get set }
    var pageIndex: Int { get set }
    
    func loadFreshNews()
    func loadMoreNews()
}

class ArticlesViewController: UIViewController, ArticlesViewControllerInput {
    private var articleViewModels: [ArticleViewModel] = []
    private var tableView: UITableView!
    var output: ArticlesViewControllerOutput!
    var router: ArticlesRouterLogic!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure(configurator: ArticlesConfigurator.shared)
    }
    
    private func configure(configurator: ArticlesConfigurator = ArticlesConfigurator.shared) {
        configurator.configure(self)
    }
    
    func displayArticles(models: [ArticleViewModel]?) {
        if let articleViewModels = models {
            self.articleViewModels = articleViewModels
        }
    }
    
    func displayError() {
        <#code#>
    }
}

