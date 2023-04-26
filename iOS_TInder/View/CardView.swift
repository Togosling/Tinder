//
//  CardView.swift
//  iOS_TInder
//
//  Created by Тагай Абдылдаев on 13/4/23.
//

import UIKit
import SnapKit
import SDWebImage

protocol CardViewDelegate {
    func didTapMoreInfo(cardViewModel: CardViewModel)
    func didRemoveCard(cardView: CardView)
}

class CardView: UIView {
    
    var nextCardView: CardView?
    
    var delegate: CardViewDelegate?
    
    var cardViewModel: CardViewModel! {
        didSet {
            descriptionLabel.attributedText = cardViewModel.attributedString
            swipingPhotosController.cardViewModel = self.cardViewModel
            }
        }
    
    fileprivate let swipingPhotosController = SwipingPhotosController(isCardViewMode: true)
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    
    let threshold: CGFloat = 80
    
    let barStackView = UIStackView()
    
    let moreInfoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named:"moreInfo")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
        
    override init(frame: CGRect) {
        super .init(frame: frame)
        
        layer.cornerRadius = 10
        clipsToBounds = true
        
        setupViews()
        setupPanGesture()
        setupTapGesture()
        
        moreInfoButton.addTarget(self, action: #selector(handleMoreInfo), for: .touchUpInside)
    }
    
    @objc fileprivate func handleMoreInfo() {
        self.delegate?.didTapMoreInfo(cardViewModel: self.cardViewModel)
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
        
        if shouldDismissCard {
            guard let homeController = self.delegate as? MainViewController else {return}
            if translationDirection == 1 {
                homeController.handleLike()
            } else {
                homeController.dislikeButton()
            }
        } else {
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
                self.transform = .identity
            })
        }
    }
    
    fileprivate func setupViews() {
        addSubview(swipingPhotosController.view)
        swipingPhotosController.view.snp.makeConstraints { make in
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
        addSubview(moreInfoButton)
        moreInfoButton.snp.makeConstraints { make in
            make.width.equalTo(50)
            make.height.equalTo(50)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-16)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
