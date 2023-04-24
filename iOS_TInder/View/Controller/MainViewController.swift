//
//  ViewController.swift
//  iOS_TInder
//
//  Created by Тагай Абдылдаев on 13/4/23.
//

import UIKit
import SnapKit
import FirebaseFirestore
import FirebaseAuth
import JGProgressHUD

class MainViewController: UIViewController, SettingsControllerDelegate, LoginControllerDelegate, CardViewDelegate {
        
    let topStackView = TopNavigationStackView()
    let cardsDeckView = UIView()
    let bottomControlls = HomeBottomControlsStackView()
    var currentUser: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupViews()
        addTargets()
        fetchUserData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super .viewDidAppear(animated)
        
        if Auth.auth().currentUser == nil {
            let registrationController = RegistrationController()
            registrationController.delegate = self
            let navController = UINavigationController(rootViewController: registrationController)
            navController.modalPresentationStyle = .fullScreen
            present(navController, animated: true)
        }
    }
    
    fileprivate func fetchUserData() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Firestore.firestore().collection("users").document(uid).getDocument { snapShot, err in
            if let err = err {
                print(err)
                return
            }
            guard let dictionary = snapShot?.data() else {return}
            self.currentUser = User(documents: dictionary)
            self.fetchDataFromFirestore()

        }
    }
    
    fileprivate func fetchDataFromFirestore() {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Looking for Users"
        hud.show(in: view)
        guard let minAge = currentUser?.minSeekingAge, let maxAge = currentUser?.maxSeekingAge else {return}
        let query = Firestore.firestore().collection("users").whereField("age", isGreaterThan: minAge).whereField("age", isLessThan: maxAge)
        query.getDocuments {snapShot, err in
            hud.dismiss(animated: true)
            if let err = err {
                print(err)
                return
            }
            snapShot?.documents.forEach({ docSnapShot in
                let userDictionary = docSnapShot.data()
                let user = User(documents: userDictionary)
                if user.uid != Auth.auth().currentUser?.uid {
                    self.setupFirestoreUserCardView(user: user)
                }
            })
        }
    }
    
    fileprivate func setupFirestoreUserCardView(user: User) {
        let cardView = CardView(frame: .zero)
        cardView.delegate = self
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
        settingsController.delegate = self
        let navSettingsController = UINavigationController(rootViewController: settingsController)
        navSettingsController.modalPresentationStyle = .fullScreen
        present(navSettingsController, animated: true)
    }
    
    func didSaveSettings() {
        fetchUserData()
    }
    
    func didFinishLoggingIn() {
        fetchUserData()
    }
    
    func didTapMoreInfo(cardViewModel: CardViewModel) {
        let moreDetailsController = MoreDetailsController()
        moreDetailsController.modalPresentationStyle = .fullScreen
        moreDetailsController.cardViewModel = cardViewModel
        present(moreDetailsController, animated: true)
    }
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

