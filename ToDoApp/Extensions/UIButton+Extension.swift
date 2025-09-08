//
//  UIButton+Extension.swift
//  ToDoApp
//
//  Created by Aman Pratap Singh on 04/09/25.
//

import UIKit

extension UIButton {
    
    func customButton(title: String?, titleFont: UIFont?,textColor: UIColor,cornerRadius: CGFloat,  backgroundColor: UIColor?) {
        DispatchQueue.main.async {
            self.setTitle(title, for: .normal)
            self.titleLabel?.font = titleFont
            self.setTitleColor(textColor, for: .normal)
            self.layer.cornerRadius = cornerRadius
            self.clipsToBounds = true
            self.backgroundColor = backgroundColor
        }
    }
}
