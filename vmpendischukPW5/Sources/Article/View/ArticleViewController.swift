//
//  ArticleViewController.swift
//  vmpendischukPW5
//
//  Created by Vladislav on 10.11.2021.
//

import Foundation
import UIKit
import WebKit

final class ArticleViewController: UIViewController {
    private let webView = WKWebView()
    private var setupComplete = false
    
    required init(_ articleURL: URL) {
        super.init(nibName: nil, bundle: nil)
        self.webView.load(URLRequest(url: articleURL))
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        self.title = "Article"
        
        if !setupComplete {
            setup()
        }
    }
    
    func setup() {
        view.addSubview(webView)
        setupConstraints()
        
        setupComplete = true
    }
    
    func setupConstraints() {
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        webView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        webView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
    }
}
