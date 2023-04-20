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
    var age: Int?
    var profession: String?
    var imageUrl1: String?
    var imageUrl2: String?
    var imageUrl3: String?
    var uid: String?
    var minSeekingAge: Int?
    var maxSeekingAge: Int?
    
    init(documents: [String:Any]) {
        self.name = documents["fullName"] as? String
        self.age = documents["age"] as? Int
        self.profession = documents["profession"] as? String
        self.imageUrl1 = documents["imageUrl1"] as? String
        self.imageUrl2 = documents["imageUrl2"] as? String
        self.imageUrl3 = documents["imageUrl3"] as? String
        self.uid = documents["uid"] as? String
        self.minSeekingAge = documents["minSeekingAge"] as? Int
        self.maxSeekingAge = documents["maxSeekingAge"] as? Int
    }
    
    func toCardViewModel() -> CardViewModel{
        let attributedText = NSMutableAttributedString(string: name ?? "", attributes: [.font: UIFont.systemFont(ofSize: 32, weight: .heavy)])
        attributedText.append(NSAttributedString(string: "  \(age ?? -1)", attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .regular)]))
        attributedText.append(NSAttributedString(string: "\n\(profession ?? "")", attributes: [.font: UIFont.systemFont(ofSize: 20, weight: .regular)]))
        
        var imageUrls = [String]()
        if let imageUrl = imageUrl1 {
            imageUrls.append(imageUrl)
        }
        if let imageUrl = imageUrl2 {
            imageUrls.append(imageUrl)
        }
        if let imageUrl = imageUrl3 {
            imageUrls.append(imageUrl)
        }

        return CardViewModel(imageNames: imageUrls, attributedString: attributedText, textAlignment: .left)
    }
}
