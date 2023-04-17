//
//  Bindable.swift
//  iOS_TInder
//
//  Created by Тагай Абдылдаев on 17/4/23.
//

import Foundation

class Bindable<T> {
    var value: T? {
        didSet {
            observer?(value)
        }
    }
    
    var observer: ((T?)->())?
    
    func bind(observer: @escaping (T?) ->()) {
        self.observer = observer
    }
    
}
