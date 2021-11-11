//
//  ArticleTableViewCell.swift
//  vmpendischukPW5
//
//  Created by Vladislav on 10.11.2021.
//

import UIKit

// MARK: - ArticleTableViewCell

/// _ArticleTableViewCell_ is a class that represents a default cell of the article list table
class ArticleTableViewCell: UITableViewCell {
    // Article cell content container view.
    private let cellView: ArticleCellView = ArticleCellView()
    
    // Flag that indicates if the cell's setup has been finished.
    private var setupFinished: Bool = false
    
    // Displayed view model.
    var displayedViewModel: ArticleViewModel? {
        didSet {
            cellView.displayedViewModel = displayedViewModel
        }
    }
    
    // MARK: - Initializers
    
    /// Initializes an _ArticleTableViewCell_ instance with given style and reuse identifier.
    ///
    /// - parameter style: Cell style.
    /// - parameter reuseIdentifier: Cell reuse identifier.
    ///
    /// - returns: _ArticleTableViewCell_ instance.
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Cell setup.
        setup()
        
        setupFinished = true
    }
    
    /// Initializes an _ArticleTableViewCell_ instance with coder.
    ///
    /// - parameter coder: Coder.
    ///
    /// - returns: _ArticleTableViewCell_ instance.
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        // Cell setup.
        setup()
        
        setupFinished = true
    }
    
    // MARK: - Lifecycle
    
    /// Prepares a reusable cell for reuse by the table view's delegate.
    override func prepareForReuse() {
        super.prepareForReuse()
        
        displayedViewModel = nil
    }
    
    /// Lays out subviews.
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Sets the content view size and frame.
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20))
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 30
    }
    
    // MARK: - Setup
    
    /// Cell content and constraints setup.
    func setup() {
        selectionStyle = .none
        
        // Content view setup.
        contentView.addSubview(cellView)
        
        // Constraints setup.
        setupConstraints()
    }
    
    /// Cell content constaints setup.
    func setupConstraints() {
        // Cell content view container constraints setup.
        cellView.translatesAutoresizingMaskIntoConstraints = false
        cellView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        cellView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        cellView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        cellView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
    }
}
