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
        let minAge = currentUser?.minSeekingAge ?? SettingsController.minSeekingAge, maxAge = currentUser?.maxSeekingAge ?? SettingsController.maxSeekingAge
        let query = Firestore.firestore().collection("users").whereField("age", isGreaterThan: minAge).whereField("age", isLessThan: maxAge)
        topCardView = nil
        query.getDocuments {snapShot, err in
            hud.dismiss(animated: true)
            if let err = err {
                print(err)
                return
            }
            
            var previousCardView: CardView?
            
            
            snapShot?.documents.forEach({ docSnapShot in
                let userDictionary = docSnapShot.data()
                let user = User(documents: userDictionary)
                if user.uid != Auth.auth().currentUser?.uid {
                    let cardVIew = self.setupFirestoreUserCardView(user: user)
                    
                    previousCardView?.nextCardView = cardVIew
                    previousCardView = cardVIew
                    
                    if self.topCardView == nil {
                        self.topCardView = cardVIew
                    }
                }
            })
        }
    }
    
    fileprivate func setupFirestoreUserCardView(user: User) -> CardView {
        let cardView = CardView(frame: .zero)
        cardView.delegate = self
        cardView.cardViewModel = user.toCardViewModel()
        cardsDeckView.addSubview(cardView)
        cardsDeckView.sendSubviewToBack(cardView)
        cardView.snp.makeConstraints { make in
            make.size.equalToSuperview()
        }
        return cardView
    }

    fileprivate func addTargets() {
        topStackView.profileButton.addTarget(self, action: #selector(handleRegistration), for: .touchUpInside)
        bottomControlls.refreshButton.addTarget(self, action: #selector(handleRefresh), for: .touchUpInside)
        bottomControlls.likeButton.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
        bottomControlls.dislikeButton.addTarget(self, action: #selector(dislikeButton), for: .touchUpInside)
    }
    
    @objc func performSwipeAnimation(translation: CGFloat, angle: CGFloat) {
        let duration = 0.5
        let translationAnimation = CABasicAnimation(keyPath: "position.x")
        translationAnimation.toValue = translation
        translationAnimation.duration = duration
        translationAnimation.fillMode = .forwards
        translationAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        translationAnimation.isRemovedOnCompletion = false
        
        let rotationAnimation = CABasicAnimation(keyPath: "rotation.z")
        rotationAnimation.toValue = angle * CGFloat.pi / 180
        rotationAnimation.duration = duration
        
        let cardView = topCardView
        topCardView = cardView?.nextCardView
        
        CATransaction.setCompletionBlock {
            cardView?.removeFromSuperview()
        }
        
        cardView?.layer.add(translationAnimation, forKey: "translaition")
        cardView?.layer.add(rotationAnimation, forKey: "rotation")
    }
    @objc func dislikeButton() {
        performSwipeAnimation(translation: -700, angle: -15)
    }
    
    var topCardView: CardView?

    @objc func handleLike() {
        performSwipeAnimation(translation: 700, angle: 15)
    }
    
    func didRemoveCard(cardView: CardView) {
        self.topCardView?.removeFromSuperview()
        self.topCardView = self.topCardView?.nextCardView
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

