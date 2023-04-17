//
//  RegistrationController.swift
//  iOS_TInder
//
//  Created by Тагай Абдылдаев on 16/4/23.
//

import UIKit
import SnapKit
import FirebaseAuth
import JGProgressHUD


class RegistrationController: UIViewController {
    
    let registrationViewModel = RegistrationViewModel()
    
    let selectPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Select Photo", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 32, weight: .heavy)
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 16
        button.imageView?.contentMode = .scaleAspectFill
        button.clipsToBounds = true
        button.snp.makeConstraints { make in
            make.height.equalTo(275)
        }
        return button
    }()
    
    let fullNameTextField: CustomTextField = {
        let tf = CustomTextField(padding: 24, height: 44)
        tf.placeholder = "Enter full name"
        tf.backgroundColor = .white
        return tf
    }()
    let emailTextField: CustomTextField = {
        let tf = CustomTextField(padding: 24, height: 44)
        tf.placeholder = "Enter email"
        tf.keyboardType = .emailAddress
        tf.backgroundColor = .white
        return tf
    }()
    let passwordTextField: CustomTextField = {
        let tf = CustomTextField(padding: 24, height: 44)
        tf.placeholder = "Enter password"
        tf.isSecureTextEntry = true
        tf.backgroundColor = .white
        return tf
    }()
    
    let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Register", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        button.isEnabled = false
        button.backgroundColor = .lightGray
        button.setTitleColor(UIColor.darkGray, for: .disabled)
        button.layer.cornerRadius = 22
        button.snp.makeConstraints { make in
            make.height.equalTo(44)
        }
        return button
    }()
            
    override func viewDidLoad() {
        super.viewDidLoad()

        setupGradientLayer()
        setupLayout()
        setupNotificationObservers()
        setupTapGesture()
        addTargets()
        validFromObserver()
    }
        
    fileprivate func validFromObserver() {
        registrationViewModel.bindableFormIsValid.bind(observer: { [weak self] formIsValid in
            guard let formIsValid = formIsValid else {return}
            if formIsValid {
                self?.registerButton.isEnabled = true
                self?.registerButton.backgroundColor = #colorLiteral(red: 0.8235294118, green: 0, blue: 0.3254901961, alpha: 1)
                self?.registerButton.setTitleColor(.white, for: .normal)
            } else {
                self?.registerButton.isEnabled = false
                self?.registerButton.backgroundColor = .lightGray
                self?.registerButton.setTitleColor(UIColor.darkGray, for: .disabled)
            }
        })
        registrationViewModel.bindableImage.bind { [weak self] image in
            self?.selectPhotoButton.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
    }
    
    fileprivate func addTargets() {
        fullNameTextField.addTarget(self, action: #selector(handleTextField), for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(handleTextField), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(handleTextField), for: .editingChanged)
        registerButton.addTarget(self, action: #selector(handleRegistrtion), for: .touchUpInside)
        selectPhotoButton.addTarget(self, action: #selector(handlePhoto), for: .touchUpInside)
    }
    
    @objc func handlePhoto() {
        
        let photoPickerController = UIImagePickerController()
        photoPickerController.modalPresentationStyle = .fullScreen
        photoPickerController.delegate = self
        present(photoPickerController, animated: true)
    }
    
    @objc func handleRegistrtion() {
        self.handleTapDismiss()
        guard let emailText = emailTextField.text else {return}
        guard let passwordText = passwordTextField.text else {return}

        Auth.auth().createUser(withEmail: emailText, password: passwordText) { resp, err in
            
            if let err = err {
                self.showHUDWithError(error: err)
            }
            print("Succes", resp?.user.uid ?? "")
        }
    }
    
    fileprivate func showHUDWithError(error: Error) {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Failed Registration"
        hud.detailTextLabel.text = error.localizedDescription
        hud.show(in: self.view)
        hud.dismiss(afterDelay: 5)
    }
    
    @objc func handleTextField(sender: UITextField) {
        if sender == fullNameTextField {
            registrationViewModel.name = sender.text
        } else if sender == emailTextField {
            registrationViewModel.email = sender.text
        } else {
            registrationViewModel.password = sender.text
        }
    }
        
    fileprivate func setupTapGesture() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
    }
    
    @objc fileprivate func handleTapDismiss() {
        self.view.endEditing(true)
    }
    
    fileprivate func setupNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self) 
    }
    
    @objc fileprivate func handleKeyboardHide() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.transform = .identity
        })
    }
    
    @objc fileprivate func handleKeyboardShow(notification: Notification) {
        guard let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardFrame = value.cgRectValue
        let bottomSpace = view.frame.height - stackView.frame.origin.y - stackView.frame.height
        let difference = keyboardFrame.height - bottomSpace
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.transform = CGAffineTransform(translationX: 0, y: -difference - 8)
        })
    }
    
    lazy var stackView = UIStackView(arrangedSubviews: [
        selectPhotoButton,
        fullNameTextField,
        emailTextField,
        passwordTextField,
        registerButton
        ])
    
    fileprivate func setupLayout() {
        view.addSubview(stackView)
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(50)
            make.trailing.equalToSuperview().offset(-50)
        }
    }
    
    fileprivate func setupGradientLayer() {
        let gradientLayer = CAGradientLayer()
        let topColor = #colorLiteral(red: 0.9921568627, green: 0.3568627451, blue: 0.3725490196, alpha: 1)
        let bottomColor = #colorLiteral(red: 0.8980392157, green: 0, blue: 0.4470588235, alpha: 1)
        // make sure to user cgColor
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.locations = [0, 1]
        view.layer.addSublayer(gradientLayer)
        gradientLayer.frame = view.bounds
    }

}

extension RegistrationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as? UIImage
        registrationViewModel.bindableImage.value = image
        self.dismiss(animated: true)
    }
}

