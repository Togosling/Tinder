//
//  CardView.swift
//  iOS_TInder
//
//  Created by Тагай Абдылдаев on 13/4/23.
//

import UIKit
import SnapKit
import SDWebImage


class CardView: UIView {
    
    var cardViewModel: CardViewModel! {
        didSet {
            descriptionLabel.attributedText = cardViewModel.attributedString
            let url = URL(string: cardViewModel.imageUrls.first ?? "")
            imageView.sd_setImage(with: url)
            descriptionLabel.textAlignment = cardViewModel.textAlignment
            
            (0 ..< cardViewModel.imageUrls.count).forEach { (_) in
                let barView = UIView()
                barView.backgroundColor = UIColor(white: 0, alpha: 0.1)
                barView.layer.cornerRadius = 4
                barStackView.addArrangedSubview(barView)
            }
            barStackView.arrangedSubviews.first?.backgroundColor = .white
            
            cardViewModel.imageIndexObserver = {[weak self] (imageUrl, index) in
                self?.imageView.sd_setImage(with: URL(string: imageUrl ?? ""))
                self?.barStackView.arrangedSubviews.forEach { iv in
                    iv.backgroundColor = UIColor(white: 0, alpha: 0.1)
                }
                self?.barStackView.arrangedSubviews[index].backgroundColor = .white
            }
        }
    }
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    
    let threshold: CGFloat = 80
    
    let barStackView = UIStackView()
        
    override init(frame: CGRect) {
        super .init(frame: frame)
        
        layer.cornerRadius = 10
        clipsToBounds = true
        
        setupViews()
        setupPanGesture()
        setupTapGesture()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupGradient()
    }
    
    fileprivate func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        let tapLocation = sender.location(in: nil)
        let direction = tapLocation.x > frame.width / 2 ? true : false
        if direction {
            cardViewModel.toNextPhoto()
        } else {
            cardViewModel.toPreviousPhoto()
        }
    }
    
    fileprivate func setupGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.5,1.1]
        gradientLayer.frame = self.frame
        layer.insertSublayer(gradientLayer, at: 1)
    }
    
    fileprivate func setupPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        addGestureRecognizer(panGesture)
    }

    @objc func handlePan(sender: UIPanGestureRecognizer) {
        
        switch sender.state {
        case .changed :
            handleChanged(sender)
        case .ended :
            handleEnded(sender)
        default: ()
        }
    }
    
    fileprivate func handleChanged(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: nil)
        let degrees: CGFloat = translation.x / 20
        let angle = degrees * .pi / 180
        
        let rotationalTransformation = CGAffineTransform(rotationAngle: angle)
        self.transform = rotationalTransformation.translatedBy(x: translation.x, y: translation.y)
    }
    
    fileprivate func handleEnded(_ gesture: UIPanGestureRecognizer) {
        let translationDirection: CGFloat = gesture.translation(in: nil).x > 0 ? 1 : -1
        let shouldDismissCard = abs(gesture.translation(in: nil).x) > threshold
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
            if shouldDismissCard {
                self.transform = CGAffineTransform(translationX: 600 * translationDirection, y: 0)
            } else {
                self.transform = .identity
            }
            
        }) { (_) in
            self.transform = .identity
            if shouldDismissCard {
                self.removeFromSuperview()
            }
        }
    }
    
    fileprivate func setupViews() {
        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.size.equalToSuperview()
        }
        
        addSubview(barStackView)
        barStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
            make.height.equalTo(4)
        }
        barStackView.spacing = 4
        barStackView.distribution = .fillEqually
        
        addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
