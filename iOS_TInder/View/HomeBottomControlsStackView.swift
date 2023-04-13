//
//  HomeBottomControlsStackView.swift
//  iOS_TInder
//
//  Created by Тагай Абдылдаев on 13/4/23.
//

import UIKit
import SnapKit


class HomeBottomControlsStackView: UIStackView {
    
    
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        
        snp.makeConstraints { make in
            make.height.equalTo(120)
        }
        backgroundColor = .white
        
        distribution = .fillEqually
        
        let subViews = [UIImage(named: "refresh"),UIImage(named: "cancel"),UIImage(named: "star"),UIImage(named: "heart"),UIImage(named: "Lighting"),].map {
            (img) -> UIView in
            let button = UIButton(type: .system)
            button.setImage(img?.withRenderingMode(.alwaysOriginal), for: .normal)
            return button
        }
        subViews.forEach { iv in
            addArrangedSubview(iv)
        }
        
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
