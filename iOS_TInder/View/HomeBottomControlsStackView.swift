//
//  HomeBottomControlsStackView.swift
//  iOS_TInder
//
//  Created by Тагай Абдылдаев on 13/4/23.
//

import UIKit
import SnapKit


class HomeBottomControlsStackView: UIStackView {
    
    static func createButton(image: UIImage) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }
    
    let refreshButton = createButton(image: #imageLiteral(resourceName: "refresh"))
    let dislikeButton = createButton(image: #imageLiteral(resourceName: "cancel"))
    let superLikeButton = createButton(image: #imageLiteral(resourceName: "star"))
    let likeButton = createButton(image: #imageLiteral(resourceName: "heart"))
    let specialButton = createButton(image: #imageLiteral(resourceName: "Lighting"))

    
    override init(frame: CGRect) {
        super .init(frame: frame)
        
        snp.makeConstraints { make in
            make.height.equalTo(120)
        }
        backgroundColor = .white
        distribution = .fillEqually
        
        [refreshButton, dislikeButton, superLikeButton, likeButton, specialButton].forEach { (button) in
            self.addArrangedSubview(button)
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
