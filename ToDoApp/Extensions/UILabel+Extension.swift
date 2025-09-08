//
//  UILabel+Extension.swift
//  ToDoApp
//
//  Created by Aman Pratap Singh on 04/09/25.
//

import UIKit

extension UILabel {
    
    func customLabel(text: String?, textColor: UIColor?, font: UIFont?) {
        self.text = text
        self.textColor = textColor
        self.font = font
        self.adjustsFontForContentSizeCategory = false
    }
}
