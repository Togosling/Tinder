//
//  RegistrationViewModel.swift
//  iOS_TInder
//
//  Created by Тагай Абдылдаев on 16/4/23.
//

import UIKit


class RegistrationViewModel {
    
    var bindableImage = Bindable<UIImage>()
    
    var name: String? {didSet{isFormIsValid()}}
    var email: String? {didSet{isFormIsValid()}}
    var password: String? {didSet{isFormIsValid()}}
        
    func isFormIsValid() {
        let isFormValid = name?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false
        bindableFormIsValid.value = isFormValid
    }
    var bindableFormIsValid = Bindable<Bool>()
}
