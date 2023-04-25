//
//  MoreDetailsController.swift
//  iOS_TInder
//
//  Created by Тагай Абдылдаев on 20/4/23.
//

import UIKit
import SDWebImage


class MoreDetailsController: UIViewController, UIScrollViewDelegate {
    
    var cardViewModel: CardViewModel? {
        didSet {
            infoLabel.attributedText = cardViewModel?.attributedString
            swipingPhotosController.cardViewModel = cardViewModel
        }
    }
    
    lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.alwaysBounceVertical = true
        sv.contentInsetAdjustmentBehavior = .never
        sv.delegate = self
        return sv
    }()
    
    let swipingPhotosController = SwipingPhotosController()
    
    let infoLabel: UILabel = {
        let label = UILabel()
        label.text = "User name 30\nDoctor\nSome bio text down below"
        label.numberOfLines = 0
        return label
    }()
    
    let dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "34")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    lazy var dislikeButton = self.createButton(image: #imageLiteral(resourceName: "cancel").withRenderingMode(.alwaysOriginal), selector: #selector(handleDislike))
    lazy var superLikeButton = self.createButton(image: #imageLiteral(resourceName: "star").withRenderingMode(.alwaysOriginal), selector: #selector(handleDislike))
    lazy var likeButton = self.createButton(image: #imageLiteral(resourceName: "heart").withRenderingMode(.alwaysOriginal), selector: #selector(handleDislike))
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [dislikeButton, superLikeButton, likeButton])
        stackView.distribution = .fillEqually
        stackView.spacing = -32
        return stackView
    }()
    
    let blurEffect = UIBlurEffect(style: .regular)
    lazy var visualEffectView = UIVisualEffectView(effect: blurEffect)
        
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        addSubviews()
        setupContraints()
        
        dismissButton.addTarget(self, action: #selector(handleTapDismiss), for: .touchUpInside)
                
    }
    
    fileprivate func addSubviews() {
        view.addSubview(scrollView)
        view.addSubview(swipingPhotosController.view)
        view.addSubview(infoLabel)
        view.addSubview(dismissButton)
        view.addSubview(stackView)
        view.addSubview(visualEffectView)
    }
    
    fileprivate func setupContraints() {
        scrollView.snp.makeConstraints { make in
            make.size.equalToSuperview()
        }
        swipingPhotosController.view.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width)
        infoLabel.snp.makeConstraints { make in
            make.top.equalTo(swipingPhotosController.view.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        dismissButton.snp.makeConstraints { make in
            make.width.height.equalTo(50)
            make.top.equalTo(swipingPhotosController.view.snp.bottom).offset(-25)
            make.trailing.equalToSuperview().offset(-25)
        }
        stackView.snp.makeConstraints { make in
            make.width.equalTo(300)
            make.height.equalTo(80)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-50)
        }
        visualEffectView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(50)
        }

    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let changeY = -scrollView.contentOffset.y
        var width = view.frame.width + changeY * 2
        width = max(view.frame.width, width)
        swipingPhotosController.view.frame = CGRect(x: min(0, -changeY), y: min(0, -changeY), width: width, height: width)
    }
    
    fileprivate func createButton(image: UIImage, selector: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: selector, for: .touchUpInside)
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }
    
    @objc fileprivate func handleTapDismiss() {
        self.dismiss(animated: true)
    }
    
    @objc fileprivate func handleDislike() {
        print("Disliking")
    }

}
