//
//  CardView.swift
//  iOS_TInder
//
//  Created by Тагай Абдылдаев on 13/4/23.
//

import UIKit
import SnapKit


class CardView: UIView {
    
    let imageView = UIImageView(image: UIImage(named: "lady5c"))
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        
        backgroundColor = .red
        layer.cornerRadius = 10
        clipsToBounds = true
        
        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.size.equalToSuperview()
        }
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        addGestureRecognizer(panGesture)
    }

    @objc func handlePan(sender: UIPanGestureRecognizer) {
        
        switch sender.state {
        case .changed :
            handelChanged(sender)
        case .ended :
            handleEnded()
        default: ()
        }
    }
    
    fileprivate func handelChanged(_ sender: UIPanGestureRecognizer) {
        let trasnlation = sender.translation(in: nil)
        self.transform = CGAffineTransform(translationX: trasnlation.x, y: trasnlation.y)
    }
    
    fileprivate func handleEnded() {
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseOut) {
            self.transform = .identity
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
