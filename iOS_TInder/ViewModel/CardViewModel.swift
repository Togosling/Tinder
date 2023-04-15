//
//  CardViewModel.swift
//  iOS_TInder
//
//  Created by Тагай Абдылдаев on 14/4/23.
//

import UIKit

protocol ProducesCardViewModel {
    func toCardViewModel() -> CardViewModel
}

class CardViewModel {
    
    let imageNames: [String]
    let attributedString: NSAttributedString
    let textAlignment: NSTextAlignment
    
    init(imageNames: [String], attributedString: NSAttributedString, textAlignment: NSTextAlignment) {
        self.imageNames = imageNames
        self.attributedString = attributedString
        self.textAlignment = textAlignment
    }
    
    fileprivate var imageIndex = 0 {
        didSet {
            imageIndexObserver?(UIImage(named: imageNames[imageIndex]), imageIndex)
        }
    }
    var imageIndexObserver: ((UIImage?,Int) -> ())?
    
    func toNextPhoto() {
        imageIndex = min(imageIndex + 1, imageNames.count - 1)
    }
    func toPreviousPhoto() {
        imageIndex = max(0, imageIndex - 1)
    }
    
}


