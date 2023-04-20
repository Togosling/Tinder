//
//  LoginViewModel.swift
//  iOS_TInder
//
//  Created by Тагай Абдылдаев on 20/4/23.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class LoginViewModel {
    
    var isLoggingIn = Bindable<Bool>()
    var isFormValid = Bindable<Bool>()
    
    var email: String? { didSet { checkFormValidity() } }
    var password: String? { didSet { checkFormValidity() } }
    
    fileprivate func checkFormValidity() {
        let isValid = email?.isEmpty == false && password?.isEmpty == false
        isFormValid.value = isValid
    }
    
    func performLogin(completion: @escaping (Error?) -> ()) {
        guard let email = email, let password = password else { return }
        isLoggingIn.value = true
        Auth.auth().signIn(withEmail: email, password: password) { (res, err) in
            completion(err)
        }
    }
}
