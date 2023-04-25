//
//  RegistrationViewModel.swift
//  iOS_TInder
//
//  Created by Тагай Абдылдаев on 16/4/23.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage


class RegistrationViewModel {
    
    var bindableIsRegistering = Bindable<Bool>()
    var bindableImage = Bindable<UIImage>()
    var bindableFormIsValid = Bindable<Bool>()

    
    var name: String? {didSet{isFormIsValid()}}
    var email: String? {didSet{isFormIsValid()}}
    var password: String? {didSet{isFormIsValid()}}
    
    func performRegistration(completion: @escaping (Error?)->()) {
        self.bindableIsRegistering.value = true
        guard let email = email, let password = password else {return}

        Auth.auth().createUser(withEmail: email, password: password) { resp, err in
            
            if let err = err {
                completion(err)
            }
            print("Succes", resp?.user.uid ?? "")
            self.saveImageToFirebase(completion: completion)
        }
    }
    

    fileprivate func saveImageToFirebase(completion: @escaping (Error?) ->()) {
        let filename = UUID().uuidString
        let ref = Storage.storage().reference(withPath: "/images/\(filename)")
        let imageData = self.bindableImage.value?.jpegData(compressionQuality: 0.75) ?? Data()
        ref.putData(imageData, metadata: nil, completion: { (_, err) in

            if let err = err {
                completion(err)
                return
            }

            print("Finished uploading image to storage")
            ref.downloadURL(completion: { (url, err) in
                if let err = err {
                    completion(err)
                    return
                }

                self.bindableIsRegistering.value = false
                print("Download url of our image is:", url?.absoluteString ?? "")
                let imageUrl = url?.absoluteString ?? ""
                self.saveInfoToFirestore(imageUrl: imageUrl, completion: completion)
            })

        })
    }

    fileprivate func saveInfoToFirestore(imageUrl: String, completion: @escaping (Error?) -> ()) {
        let uid = Auth.auth().currentUser?.uid ?? ""
        let docData: [String:Any] = ["fullName": name ?? "", "uid": uid, "imageUrl1": imageUrl, "age": 18, "minSeekingAge": SettingsController.minSeekingAge, "maxSeekingAge": SettingsController.maxSeekingAge]
        Firestore.firestore().collection("users").document(uid).setData(docData) { (err) in
            if let err = err {
                completion(err)
                return
            }
            completion(nil)
        }
    }
        
    func isFormIsValid() {
        let isFormValid = name?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false && bindableImage.value != nil
        bindableFormIsValid.value = isFormValid
    }
}
