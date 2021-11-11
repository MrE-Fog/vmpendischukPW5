//
//  ArticleCellView.swift
//  vmpendischukPW5
//
//  Created by Vladislav on 10.11.2021.
//

import UIKit

class ArticleCellView: UIView {
    let loadingMask: CAGradientLayer = CAGradientLayer()
    let imageView: UIImageView = UIImageView()
    let textBackgroundView: UIView = UIView()
    let titleLabel: UILabel = UILabel()
    let descLabel: UILabel = UILabel()
    var setupComplete: Bool = false
    var task: URLSessionDataTask!
    
    var displayedViewModel: ArticleViewModel? {
        didSet {
            titleLabel.text = displayedViewModel?.title
            descLabel.text = displayedViewModel?.announce
            updateContent()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupContent()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupContent()
        setupConstraints()
    }
    
    func updateContent() {
        if (!setupComplete) {
            setupContent()
        }
        
        self.imageView.image = nil
        self.textBackgroundView.isHidden = true
        self.titleLabel.isHidden = true
        self.descLabel.isHidden = true
        self.textBackgroundView.isHidden = false
        
        loadingMask.startPoint = CGPoint(x: 0, y: 0.5)
        loadingMask.endPoint = CGPoint(x: 1, y: 0.5)
        imageView.layer.addSublayer(loadingMask)
        
        // Create the shimmer animation
        let animationGroup = makeLoadingAnimationGroup()
        animationGroup.beginTime = 0.0
        loadingMask.add(animationGroup, forKey: "backgroundColor")

        // Set the gradients frame to the labels bounds
        loadingMask.frame = imageView.bounds
        
        load()
    }
    
    private func makeLoadingAnimationGroup(previousGroup: CAAnimationGroup? = nil) -> CAAnimationGroup {
        let animDuration: CFTimeInterval = 1.5
                
        let anim1 = CABasicAnimation(keyPath: #keyPath(CAGradientLayer.backgroundColor))
        anim1.fromValue = UIColor.gradientLightGrey.cgColor
        anim1.toValue = UIColor.gradientDarkGrey.cgColor
        anim1.duration = animDuration
        anim1.beginTime = 0.0

        let anim2 = CABasicAnimation(keyPath: #keyPath(CAGradientLayer.backgroundColor))
        anim2.fromValue = UIColor.gradientDarkGrey.cgColor
        anim2.toValue = UIColor.gradientLightGrey.cgColor
        anim2.duration = animDuration
        anim2.beginTime = anim1.beginTime + anim1.duration

        let group = CAAnimationGroup()
        group.animations = [anim1, anim2]
        group.repeatCount = .greatestFiniteMagnitude
        group.duration = anim2.beginTime + anim2.duration
        group.isRemovedOnCompletion = false

        if let previousGroup = previousGroup {
            // Offset groups by 0.33 seconds for effect
            group.beginTime = previousGroup.beginTime + 0.33
        }

        return group
    }
    
    private func load() {
        if let imageURL = self.displayedViewModel?.img.url {
            if let task = task {
                task.cancel()
            }
            
            task = URLSession.shared.dataTask(with: imageURL) { (data, response, error) in
                guard let data = data, let newImage = UIImage(data: data) else { return }
                
                let group = DispatchGroup()
                group.enter()
                
                DispatchQueue.main.async {
                    self.imageView.image = newImage
                    group.leave()
                }
                
                group.notify(queue: .main) {
                    self.loadingMask.removeFromSuperlayer()
                    self.textBackgroundView.isHidden = false
                    self.titleLabel.isHidden = false
                    self.descLabel.isHidden = false
                    self.textBackgroundView.isHidden = false
                }
            }
            
            task.resume()
        }
    }
    
    private func setupContent() {
        self.addSubview(imageView)
        self.addSubview(textBackgroundView)
        self.addSubview(titleLabel)
        self.addSubview(descLabel)
        
        titleLabel.font = UIFont(name: "Poppins-SemiBold", size: 20.0)
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 3
        
        descLabel.font = UIFont(name: "Poppins-Light", size: 14.0)
        descLabel.textColor = .white
        descLabel.numberOfLines = 3
        
        let blur = UIBlurEffect(style: .systemUltraThinMaterialDark)
        let blurEffectView = UIVisualEffectView(effect: blur)
        blurEffectView.frame = textBackgroundView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        textBackgroundView.addSubview(blurEffectView)
        
        setupComplete = true
    }
    
    private func setupConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        imageView.contentMode = .scaleAspectFill
        
        descLabel.translatesAutoresizingMaskIntoConstraints = false
        descLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20).isActive = true
        descLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        descLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.bottomAnchor.constraint(equalTo: descLabel.topAnchor, constant: -25).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        
        textBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        textBackgroundView.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -20).isActive = true
        textBackgroundView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        textBackgroundView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        textBackgroundView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
}

extension UIColor {
    static var gradientDarkGrey: UIColor {
        return UIColor(red: 239 / 255.0, green: 241 / 255.0, blue: 241 / 255.0, alpha: 1)
    }

    static var gradientLightGrey: UIColor {
        return UIColor(red: 201 / 255.0, green: 201 / 255.0, blue: 201 / 255.0, alpha: 1)
    }
}
