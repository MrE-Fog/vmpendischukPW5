//
//  ViewController.swift
//  vmpendischukPW5
//
//  Created by Vladislav on 10.11.2021.
//

import UIKit

// MARK: - ArticlesViewControllerInputLogic

/// _ArticlesViewControllerInputLogic_ is a protocol for the article list presenter output behaviour.
protocol ArticlesViewControllerInputLogic : ArticlesPresenterOutputLogic { }

// MARK: - ArticlesViewControllerOutputLogic

/// _ArticlesViewControllerOutputLogic_ is a protocol for article list data storage and view controller output behaviour.
protocol ArticlesViewControllerOutputLogic {
    // Presented articles.
    var articles: [ArticleModel] { get set }
    
    // Current news page index.
    var pageIndex: Int { get set }
    
    // Flag that indicates if output is in the
    // process of awaiting a fetch response.
    var isFetching: Bool { get }
    
    /// Fetches news on the current page and updates the presented list.
    func loadFreshNews()
    
    /// Fetches news on the next page and updates the presented list.
    func loadMoreNews()
}

// MARK: - ArticlesViewController

/// _ArticlesViewController_ is a view controller responsible for displaying an article list.
class ArticlesViewController: UIViewController {
    // Table view row height.
    private static let rowHeight: CGFloat = 450.0
    
    // Table view responsible for article list display.
    private let tableView = UITableView()
    
    // Activity indicator used to indicate table loading activity.
    private let activityIndicator = UIActivityIndicatorView()
    
    // Refresh control used for table refresh.
    private let refreshControl = UIRefreshControl()
    
    // Displayed articles.
    private var articleViewModels: [ArticleViewModel] = []
    
    // Article list view controller's output interactor.
    var output: ArticlesViewControllerOutputLogic!
    
    // Article list view controller's router.
    var router: ArticlesRouterLogic!
    
    // MARK: - Initializers
    
    /// Initializes an _ArticlesViewController_ instance with given configurator.
    ///
    /// - parameter configurator: _ArticlesViewController_ VIP pathways configurator
    ///                           (shared singleton instance by default).
    ///
    /// - returns: _ArticlesViewController_ instance.
    required init(configurator: ArticlesConfigurator = ArticlesConfigurator.shared) {
        super.init(nibName: nil, bundle: nil)
        configure(configurator: configurator)
    }
    
    /// Initializes an _ArticlesViewController_ instance with given coder.
    ///
    /// - parameter coder: Coder.
    ///
    /// - returns: _ArticlesViewController_ instance.
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure(configurator: ArticlesConfigurator.shared)
    }
    
    // MARK: - Configuration
    
    private func configure(configurator: ArticlesConfigurator = ArticlesConfigurator.shared) {
        configurator.configure(self)
    }
    
    // MARK: - Lifecycle
    
    /// On view load.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Articles"
        
        // Table view setup.
        setupTableView()
        
        // Loading the articles to display.
        output.loadFreshNews()
    }
    
    // MARK: View setup
    
    /// Sets the article list table view up.
    private func setupTableView() {
        // Appearance and behaviour setup.
        tableView.rowHeight = ArticlesViewController.rowHeight
        tableView.separatorStyle = .none
        tableView.separatorInset = .zero
        tableView.showsVerticalScrollIndicator = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ArticleTableViewCell.self, forCellReuseIdentifier: "ArticleCell")
        view.addSubview(tableView)
        tableView.estimatedRowHeight = ArticlesViewController.rowHeight
        
        // Refresh control setup.
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshTable), for: .valueChanged)
        
        // Constraints setup.
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    // MARK: - Event handlers
    
    /// Table refresh call handler - reloads the news.
    @objc
    private func refreshTable() {
        // Clearing the table.
        articleViewModels.removeAll()
        
        // Reloading the news.
        output.pageIndex = 1
        output.loadFreshNews()
    }
    
    /// Share swipe action selection handler.
    private func handleShare(_ forIndex: IndexPath) {
        // Calling the share popover window setup in router.
        router.sharePopover(atIndex: forIndex, animated: true)
    }
}

// MARK: - ArticlesViewControllerInputLogic extension

extension ArticlesViewController: ArticlesViewControllerInputLogic {
    /// Handles the display call for given article view model list.
    ///
    /// - parameter models: Models to display.
    func displayArticles(models: [ArticleViewModel]?) {
        if let articleViewModels = models {
            // Update current content.
            self.articleViewModels = articleViewModels
            
            DispatchQueue.main.async {
                // Reloading the table.
                self.tableView.reloadData()
                
                // Stopping all loading spinner animations.
                
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
    
    /// Handles the error display call.
    func displayError() {
        // Displaying the error in the table footer.
        self.tableView.tableFooterView?.isHidden = false
        let errorLabel = UILabel()
        errorLabel.text = "Could not load more news"
        errorLabel.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: CGFloat(44))
        errorLabel.textAlignment = .center
        
        self.tableView.tableFooterView = errorLabel
    }
}

// MARK: - UITableViewDataSource extension

extension ArticlesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the currect article count.
        articleViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue a cell.
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell", for: indexPath) as? ArticleTableViewCell else {
            return UITableViewCell()
        }
        
        // Set the displayed view model.
        let viewModel = articleViewModels[indexPath.row]
        cell.displayedViewModel = viewModel
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ArticlesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // Index of the last section in the table.
        let lastSectionIndex = tableView.numberOfSections - 1
        
        // Index of the last row of the table.
        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
        
        // If the cell is the last one.
        if indexPath.section == lastSectionIndex && indexPath.row == lastRowIndex {
            // Stop if already fetching.
            if output.isFetching {
                return
            }
            
            // Enabling the activity indicator.
            activityIndicator.startAnimating()
            activityIndicator.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: CGFloat(44))
            activityIndicator.hidesWhenStopped = true
            
            // Displaying the activity indicator.
            self.tableView.tableFooterView = activityIndicator
            self.tableView.tableFooterView?.isHidden = false
            
            // Load more news via interactor fetch call.
            self.output.loadMoreNews()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Navigate to selected article content via router.
        router.navigateToArticle(atIndex: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        // Needed for trailing swipe action.
        return .none
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // Action displayed when the article cell is swiped to the left.
        let action = UIContextualAction(style: .normal, title: nil) { [weak self] (action, view, completionHandler) in
            self?.handleShare(indexPath)
            completionHandler(true)
        }
        
        // Action appearance setup.
        action.backgroundColor = UIColor(white: 1, alpha: 0)
        action.image = UIImage(named: "ShareIcon")
        
        return UISwipeActionsConfiguration(actions: [action])
    }
}
