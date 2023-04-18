//
//  ViewController.swift
//  iOS_TInder
//
//  Created by Тагай Абдылдаев on 13/4/23.
//

import UIKit
import SnapKit
import FirebaseFirestore
import JGProgressHUD

class MainViewController: UIViewController {
    
    let topStackView = TopNavigationStackView()
    let cardsDeckView = UIView()
    let bottomControlls = HomeBottomControlsStackView()
//    var cardViewModels = [CardViewModel]()
    var lastUser: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupViews()
//        setupFirestoreUserCardView()
        addTargets()
        fetchDataFromFirestore()
    }
    
    fileprivate func fetchDataFromFirestore() {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Looking for Users"
        hud.show(in: view)
        let query = Firestore.firestore().collection("users").order(by: "uid").start(after: [lastUser?.uid ?? ""]).limit(to: 2)
        query.getDocuments {snapShot, err in
            hud.dismiss(animated: true)
            if let err = err {
                print(err)
                return
            }
            snapShot?.documents.forEach({ docSnapShot in
                let userDictionary = docSnapShot.data()
                let user = User(documents: userDictionary)
//                self.cardViewModels.append(user.toCardViewModel())
                self.lastUser = user
                self.setupFirestoreUserCardView(user: user)
            })
        }
    }
    
    fileprivate func setupFirestoreUserCardView(user: User) {
        let cardView = CardView(frame: .zero)
        cardView.cardViewModel = user.toCardViewModel()
        cardsDeckView.addSubview(cardView)
        cardsDeckView.sendSubviewToBack(cardView)
        cardView.snp.makeConstraints { make in
            make.size.equalToSuperview()
        }
    }

    fileprivate func addTargets() {
        topStackView.profileButton.addTarget(self, action: #selector(handleRegistration), for: .touchUpInside)
        bottomControlls.refreshButton.addTarget(self, action: #selector(handleRefresh), for: .touchUpInside)
    }
    @objc func handleRefresh() {
        self.fetchDataFromFirestore()
    }
    
    @objc func handleRegistration() {
        let settingsController = SettingsController()
        let navSettingsController = UINavigationController(rootViewController: settingsController)
        navSettingsController.modalPresentationStyle = .fullScreen
        present(navSettingsController, animated: true)
    }
    
//    fileprivate func setupUserCardView() {
//
//        for cardViewModel in cardViewModels {
//            let cardView = CardView(frame: .zero)
//            cardView.cardViewModel = cardViewModel
//            cardsDeckView.addSubview(cardView)
//            cardView.snp.makeConstraints { make in
//                make.size.equalToSuperview()
//            }
//        }
//    }
    
    fileprivate func setupViews() {
        
        let overallStackView = UIStackView(arrangedSubviews: [topStackView, cardsDeckView, bottomControlls])
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

