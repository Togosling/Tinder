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
    let blueView = UIView()
    let bottomStackView = HomeBottomControlsStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        blueView.backgroundColor = .blue

        setupViews()
    }
    
    fileprivate func setupViews() {
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .white
        
        view.insertSubview(backgroundView, at: 0)
        backgroundView.snp.makeConstraints { make in
            make.size.equalToSuperview()
        }
        
        let overallStackView = UIStackView(arrangedSubviews: [topStackView, blueView, bottomStackView])
        overallStackView.axis = .vertical
        view.addSubview(overallStackView)
        overallStackView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-20)
            make.top.equalToSuperview().offset(30)
            make.trailing.leading.equalToSuperview()
        }
    }


}

