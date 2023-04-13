//
//  TopNavigationStackView.swift
//  iOS_TInder
//
//  Created by Тагай Абдылдаев on 13/4/23.
//

import UIKit

class TopNavigationStackView: UIStackView {
    
    let profileButton = UIButton(type: .system)
    let fireImageView = UIImageView(image: UIImage(named: "fire")?.withRenderingMode(.alwaysOriginal))
    let chatButton = UIButton(type: .system)

    
    override init(frame: CGRect) {
        super .init(frame: frame)
        
        snp.makeConstraints { make in
            make.height.equalTo(80)
        }
        
        backgroundColor = .white

        
        profileButton.setImage(UIImage(named: "profile")?.withRenderingMode(.alwaysOriginal), for: .normal)
        chatButton.setImage(UIImage(named: "chat")?.withRenderingMode(.alwaysOriginal), for: .normal)
        fireImageView.contentMode = .scaleAspectFit

        
        let subViews = [profileButton, UIView(), fireImageView, UIView(), chatButton]
        
        subViews.forEach { iv in
            addArrangedSubview(iv)
        }
        
        distribution = .equalCentering
        
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = .init(top: 0, left: 16, bottom: 0, right: 16)
        
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
