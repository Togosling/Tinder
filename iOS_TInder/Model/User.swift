//
//  User.swift
//  iOS_TInder
//
//  Created by Тагай Абдылдаев on 14/4/23.
//

import Foundation
import UIKit


struct User: ProducesCardViewModel {
    
    var name: String?
    var age: String?
    var profession: String?
    var imageUrl1: String?
    var uid: String?
    
    init(documents: [String:Any]) {
        self.name = documents["fullName"] as? String
        self.age = documents["age"] as? String
        self.profession = documents["profession"] as? String
        self.imageUrl1 = documents["imageUrl1"] as? String
        self.uid = documents["uid"] as? String
    }
    
    func toCardViewModel() -> CardViewModel{
        let attributedText = NSMutableAttributedString(string: name ?? "", attributes: [.font: UIFont.systemFont(ofSize: 32, weight: .heavy)])
        attributedText.append(NSAttributedString(string: "  \(age ?? "")", attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .regular)]))
        attributedText.append(NSAttributedString(string: "\n\(profession ?? "")", attributes: [.font: UIFont.systemFont(ofSize: 20, weight: .regular)]))

        return CardViewModel(imageNames: [imageUrl1 ?? ""], attributedString: attributedText, textAlignment: .left)
    }
}
