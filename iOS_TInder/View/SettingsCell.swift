//
//  SettingsCell.swift
//  iOS_TInder
//
//  Created by Тагай Абдылдаев on 19/4/23.
//

import UIKit
import SnapKit


class SettingsCell: UITableViewCell {
    
    class CustomTextField: UITextField {
        
        override var intrinsicContentSize: CGSize{
            return .init(width: 0, height: 50)
        }
        
        override func textRect(forBounds bounds: CGRect) -> CGRect {
            super.textRect(forBounds: bounds.insetBy(dx: 16, dy: 0))
        }
        
        override func editingRect(forBounds bounds: CGRect) -> CGRect {
            super.editingRect(forBounds: bounds.insetBy(dx: 16, dy: 0))
        }
    }
    
    let textField: UITextField = {
        let tf = CustomTextField()
        tf.placeholder = "Test"
        return tf
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(textField)
        textField.snp.makeConstraints { make in
            make.size.equalToSuperview()
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
