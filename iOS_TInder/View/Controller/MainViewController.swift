//
//  ViewController.swift
//  iOS_TInder
//
//  Created by Тагай Абдылдаев on 13/4/23.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {
    
    let topStackView = TopNavigationStackView()
    let cardsDeckView = UIView()
    let bottomStackView = HomeBottomControlsStackView()
    
    let cardViewModels = [User(name: "Kelly", age: "23", proffesion: "Music DJ", imageName: "lady5c").toCardViewModel(),
                          User(name: "Jenny", age: "18", proffesion: "Teacher", imageName: "lady4c").toCardViewModel()]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupViews()
        setupDummyCards()
    }
    
    fileprivate func setupDummyCards() {
        
        for cardViewModel in cardViewModels {
            let cardView = CardView(frame: .zero)
            cardView.descriptionLabel.attributedText = cardViewModel.attributedString
            cardView.imageView.image = UIImage(named:cardViewModel.imageName)
            cardView.descriptionLabel.textAlignment = cardViewModel.textAlignment
            
            cardsDeckView.addSubview(cardView)
            cardView.snp.makeConstraints { make in
                make.size.equalToSuperview()
            }
        }
    }
    
    fileprivate func setupViews() {
        
        let overallStackView = UIStackView(arrangedSubviews: [topStackView, cardsDeckView, bottomStackView])
        overallStackView.axis = .vertical
        view.addSubview(overallStackView)
        overallStackView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-20)
            make.top.equalToSuperview().offset(30)
            make.trailing.leading.equalToSuperview()
        }
        
        overallStackView.isLayoutMarginsRelativeArrangement = true
        overallStackView.layoutMargins = .init(top: 0, left: 8, bottom: 0, right: 8)
        
        overallStackView.bringSubviewToFront(cardsDeckView)
    }
}

