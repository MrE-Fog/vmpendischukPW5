//
//  ArticleCellView.swift
//  vmpendischukPW5
//
//  Created by Vladislav on 10.11.2021.
//

import UIKit

// MARK: - ArticleCellView

/// _ArticleCellView_ is a cell that represents the article list cell content container.
class ArticleCellView: UIView {
    // Gradient mask used for loading shimmer animation.
    private let loadingMask: CAGradientLayer = CAGradientLayer()
    
    // Article image view.
    private let imageView: UIImageView = UIImageView()
    
    // Article cell text background blur container.
    private let textBackgroundView: UIView = UIView()
    
    // Article title label.
    private let titleLabel: UILabel = UILabel()
    
    // Article description label.
    private let descLabel: UILabel = UILabel()
    
    // Flag that indicates that the view's setup has been completed.
    private var setupComplete: Bool = false
    
    // URL session data task used for fetching image data.
    private var task: URLSessionDataTask!
    
    // Displayed view model.
    var displayedViewModel: ArticleViewModel? {
        didSet {
            titleLabel.text = displayedViewModel?.title
            descLabel.text = displayedViewModel?.announce
            updateContent()
        }
    }
    
    // MARK: - Initializers
    
    /// Initializes and returns a newly allocated _ArticleCellView_ instance with the specified frame rectangle.
    ///
    /// - parameter frame: The frame rectangle for the view, measured in points.
    ///                    The origin of the frame is relative to the superview
    ///                    in which you plan to add it. This method uses the frame
    ///                    rectangle to set the center and bounds properties accordingly.
    ///
    /// - returns _ArticleCellView_ instance.
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    /// Initializes and _ArticleCellView_ instance with given coder.
    ///
    /// - parameter coder: Coder.
    ///
    /// - returns _ArticleCellView_ instance.
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    // MARK: - Content update and load
    
    /// Updates the view's content with info from view model currently set.
    func updateContent() {
        if (!setupComplete) {
            setup()
        }
        
        // Hiding and resetting the content.
        self.imageView.image = nil
        self.textBackgroundView.isHidden = true
        self.titleLabel.isHidden = true
        self.descLabel.isHidden = true
        self.textBackgroundView.isHidden = false
        
        // Loading mask appearance and init.
        loadingMask.startPoint = CGPoint(x: 0, y: 0.5)
        loadingMask.endPoint = CGPoint(x: 1, y: 0.5)
        imageView.layer.addSublayer(loadingMask)
        
        // Creating the shimmer animation.
        let animationGroup = makeLoadingAnimationGroup()
        animationGroup.beginTime = 0.0
        loadingMask.add(animationGroup, forKey: "backgroundColor")

        // Setting the gradients frame to the image bounds.
        loadingMask.frame = imageView.bounds
        
        // Loading ad displaying the image.
        load()
    }
    
    /// Loads the image from URL in the view model and displays the info on the article.
    private func load() {
        if let imageURL = self.displayedViewModel?.img.url {
            // Cancelling the previous fetch task.
            if let task = task {
                task.cancel()
            }
            
            // Initializing URL session data task.
            task = URLSession.shared.dataTask(with: imageURL) { (data, response, error) in
                // Decoding data.
                guard let data = data, let newImage = UIImage(data: data) else { return }
                
                let group = DispatchGroup()
                group.enter()
                
                // Setting the new image.
                DispatchQueue.main.async {
                    self.imageView.image = newImage
                    group.leave()
                }
                
                // Displaying the content and disabling the loading animation.
                group.notify(queue: .main) {
                    self.loadingMask.removeFromSuperlayer()
                    self.textBackgroundView.isHidden = false
                    self.titleLabel.isHidden = false
                    self.descLabel.isHidden = false
                    self.textBackgroundView.isHidden = false
                }
            }
            
            // Fetching image data via URL session data task.
            task.resume()
        }
    }
    
    // MARK: - Animation
    
    /// Creates a new animation group for the loading gradient mask.
    ///
    /// - returns: Loading animation group.
    private func makeLoadingAnimationGroup() -> CAAnimationGroup {
        // Animation duration.
        let animDuration: CFTimeInterval = 1.5
        
        // Starting point (loop transition).
        let anim1 = CABasicAnimation(keyPath: #keyPath(CAGradientLayer.backgroundColor))
        anim1.fromValue = UIColor.gradientLightGrey.cgColor
        anim1.toValue = UIColor.gradientDarkGrey.cgColor
        anim1.duration = animDuration
        anim1.beginTime = 0.0

        // Animation and end point.
        let anim2 = CABasicAnimation(keyPath: #keyPath(CAGradientLayer.backgroundColor))
        anim2.fromValue = UIColor.gradientDarkGrey.cgColor
        anim2.toValue = UIColor.gradientLightGrey.cgColor
        anim2.duration = animDuration
        anim2.beginTime = anim1.beginTime + anim1.duration

        // Forimg the animation group.
        let group = CAAnimationGroup()
        group.animations = [anim1, anim2]
        group.repeatCount = .greatestFiniteMagnitude
        group.duration = anim2.beginTime + anim2.duration
        group.isRemovedOnCompletion = false
        
        return group
    }
    
    // MARK: - View setup
    
    /// View content and constraints setup.
    private func setup() {
        // Adding the subviews.
        self.addSubview(imageView)
        self.addSubview(textBackgroundView)
        self.addSubview(titleLabel)
        self.addSubview(descLabel)
        
        // Labels appearance setup.
        
        titleLabel.font = UIFont(name: "Poppins-SemiBold", size: 20.0)
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 3
        
        descLabel.font = UIFont(name: "Poppins-Light", size: 14.0)
        descLabel.textColor = .white
        descLabel.numberOfLines = 3
        
        // Text background blur setup.
        let blur = UIBlurEffect(style: .systemUltraThinMaterialDark)
        let blurEffectView = UIVisualEffectView(effect: blur)
        blurEffectView.frame = textBackgroundView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        textBackgroundView.addSubview(blurEffectView)
        
        // Constraints setup.
        setupConstraints()
        
        setupComplete = true
    }
    
    /// Subviews constraints setup.
    private func setupConstraints() {
        // Image view constaints.
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        imageView.contentMode = .scaleAspectFill
        
        // Description label constraints.
        descLabel.translatesAutoresizingMaskIntoConstraints = false
        descLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20).isActive = true
        descLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        descLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        
        // Title label constraints.
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.bottomAnchor.constraint(equalTo: descLabel.topAnchor, constant: -25).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        
        // Blur background constraints.
        textBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        textBackgroundView.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -20).isActive = true
        textBackgroundView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        textBackgroundView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        textBackgroundView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
}

// MARK: - Extension for UIColor

extension UIColor {
    static var gradientDarkGrey: UIColor {
        return UIColor(red: 239 / 255.0, green: 241 / 255.0, blue: 241 / 255.0, alpha: 1)
    }

    static var gradientLightGrey: UIColor {
        return UIColor(red: 201 / 255.0, green: 201 / 255.0, blue: 201 / 255.0, alpha: 1)
    }
}
