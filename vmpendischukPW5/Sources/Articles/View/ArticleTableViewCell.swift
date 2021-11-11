//
//  ArticleTableViewCell.swift
//  vmpendischukPW5
//
//  Created by Vladislav on 10.11.2021.
//

import UIKit

class ArticleTableViewCell: UITableViewCell {
    private var setupFinished: Bool = false
    let cellView: ArticleCellView = ArticleCellView()
    var displayedViewModel: ArticleViewModel? {
        didSet {
            cellView.displayedViewModel = displayedViewModel
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupContent()
        setupConstraints()
        
        setupFinished = true
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupContent()
        setupConstraints()
        
        setupFinished = true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if !setupFinished {
            setupContent()
            setupConstraints()
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        displayedViewModel = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20))
    }
    
    func setupContent() {
        selectionStyle = .none
        
        contentView.addSubview(cellView)
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 30
    }
    
    func setupConstraints() {
        cellView.translatesAutoresizingMaskIntoConstraints = false
        cellView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        cellView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        cellView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        cellView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
    }
}
