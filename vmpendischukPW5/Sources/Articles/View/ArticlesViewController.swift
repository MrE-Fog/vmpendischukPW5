//
//  ViewController.swift
//  vmpendischukPW5
//
//  Created by Vladislav on 10.11.2021.
//

import UIKit

protocol ArticlesViewControllerInputLogic : ArticlesPresenterOutputLogic { }

protocol ArticlesViewControllerOutputLogic {
    var articles: [ArticleModel]? { get set }
    var pageIndex: Int { get set }
    var isFetching: Bool { get }
    
    func loadFreshNews()
    func loadMoreNews()
}

class ArticlesViewController: UIViewController {
    private static let rowHeight: CGFloat = 450.0
    private let tableView = UITableView()
    private let activityIndicator = UIActivityIndicatorView()
    private let refreshControl = UIRefreshControl()
    private var articleViewModels: [ArticleViewModel] = []
    var output: ArticlesViewControllerOutputLogic!
    var router: ArticlesRouterLogic!
    
    init(configurator: ArticlesConfigurator = ArticlesConfigurator.shared) {
        super.init(nibName: nil, bundle: nil)
        configure(configurator: configurator)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure(configurator: ArticlesConfigurator.shared)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Articles"
        
        setupTableView()
        
        output.loadFreshNews()
    }
    
    private func configure(configurator: ArticlesConfigurator = ArticlesConfigurator.shared) {
        configurator.configure(self)
    }
    
    private func setupTableView() {
        tableView.rowHeight = ArticlesViewController.rowHeight
        tableView.separatorStyle = .none
        tableView.separatorInset = .zero
        tableView.showsVerticalScrollIndicator = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ArticleTableViewCell.self, forCellReuseIdentifier: "ArticleCell")
        view.addSubview(tableView)
        tableView.estimatedRowHeight = 450
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshTable), for: .valueChanged)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    @objc
    private func refreshTable() {
        articleViewModels.removeAll()
        output.pageIndex = 1
        output.loadFreshNews()
    }
}

extension ArticlesViewController: ArticlesViewControllerInputLogic {
    func displayArticles(models: [ArticleViewModel]?) {
        if let articleViewModels = models {
            self.articleViewModels.append(contentsOf: articleViewModels)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                
                if self.activityIndicator.isAnimating {
                    self.tableView.tableFooterView?.isHidden = true
                    self.activityIndicator.stopAnimating()
                }
                
                if self.refreshControl.isRefreshing {
                    self.refreshControl.endRefreshing()
                }
            }
        }
    }
    
    func displayError() {
        self.tableView.tableFooterView?.isHidden = false
        let errorLabel = UILabel()
        errorLabel.text = "Could not load more news"
        errorLabel.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: CGFloat(44))
        errorLabel.textAlignment = .center
        
        self.tableView.tableFooterView = errorLabel
    }
}

extension ArticlesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        articleViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell", for: indexPath) as? ArticleTableViewCell else {
            return UITableViewCell()
        }
        
        let viewModel = articleViewModels[indexPath.row]
        cell.displayedViewModel = viewModel
        
        return cell
    }
}

extension ArticlesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastSectionIndex = tableView.numberOfSections - 1
        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
        if indexPath.section == lastSectionIndex && indexPath.row == lastRowIndex {
            if output.isFetching {
                return
            }
            
            activityIndicator.startAnimating()
            activityIndicator.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: CGFloat(44))
            activityIndicator.hidesWhenStopped = true
            
            self.tableView.tableFooterView = activityIndicator
            self.tableView.tableFooterView?.isHidden = false
            self.output.loadMoreNews()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        router.navigateToArticle(atIndex: indexPath, animated: true)
    }
}
