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
    
    let imageUrls: [String]
    let attributedString: NSAttributedString
    let textAlignment: NSTextAlignment
    
    init(imageNames: [String], attributedString: NSAttributedString, textAlignment: NSTextAlignment) {
        self.imageUrls = imageNames
        self.attributedString = attributedString
        self.textAlignment = textAlignment
    }
    
    fileprivate var imageIndex = 0 {
        didSet {
            imageIndexObserver?(imageUrls[imageIndex], imageIndex)
        }
    }
    var imageIndexObserver: ((String?,Int) -> ())?
    
    func toNextPhoto() {
        imageIndex = min(imageIndex + 1, imageUrls.count - 1)
    }
    func toPreviousPhoto() {
        imageIndex = max(0, imageIndex - 1)
    }
    
}


