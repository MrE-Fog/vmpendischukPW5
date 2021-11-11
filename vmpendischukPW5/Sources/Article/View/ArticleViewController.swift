//
//  ArticleViewController.swift
//  vmpendischukPW5
//
//  Created by Vladislav on 10.11.2021.
//

import Foundation
import UIKit
import WebKit

// MARK: - ArticleViewController

/// _ArticleViewController_ is a view controller responsible for displaying an article.
final class ArticleViewController: UIViewController {
    // Web view that displays the article.
    private let webView = WKWebView()
    
    // Flag of view controller setup being complete.
    private var setupComplete = false
    
    // MARK: - Initializers
    
    /// Initializes an instance of _ArticleViewController_ and
    /// sets the displayed article webpage from given URL.
    ///
    /// - parameter articleURL: URL of displayed article.
    ///
    /// - returns: Instance of _ArticleViewController_.
    required init(_ articleURL: URL) {
        super.init(nibName: nil, bundle: nil)
        self.webView.load(URLRequest(url: articleURL))
    }
    
    /// Initializes an instance of _ArticleViewController_
    /// with given _NSCoder_.
    ///
    /// - parameter coder: Coder.
    ///
    /// - returns: Instance of _ArticleViewController_.
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Disabling the large navigation bar title.
        navigationItem.largeTitleDisplayMode = .never
        
        self.title = "Article"
        
        // Init setup if not complete.
        if !setupComplete {
            setup()
        }
    }
    
    // MARK: - View setup
    
    /// View content and constraints setup.
    private func setup() {
        // Web view setup.
        view.addSubview(webView)
        
        // Constraints setup.
        setupConstraints()
        
        setupComplete = true
    }
    
    /// View constraints setup.
    private func setupConstraints() {
        // Web view constraints setup.
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        webView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        webView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
    }
}
