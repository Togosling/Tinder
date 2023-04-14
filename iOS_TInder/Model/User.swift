//
//  User.swift
//  iOS_TInder
//
//  Created by Тагай Абдылдаев on 14/4/23.
//

import Foundation
import UIKit


struct User {
    
    let name: String
    let age: String
    let proffesion: String
    let imageName: String
    
    func toCardViewModel() -> CardViewModel{
        let attributedText = NSMutableAttributedString(string: name, attributes: [.font: UIFont.systemFont(ofSize: 32, weight: .heavy)])
        attributedText.append(NSAttributedString(string: "  \(age)", attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .regular)]))
        attributedText.append(NSAttributedString(string: "\n\(proffesion)", attributes: [.font: UIFont.systemFont(ofSize: 20, weight: .regular)]))

        return CardViewModel(imageName: imageName, attributedString: attributedText, textAlignment: .left)
    }
}
