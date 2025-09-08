//
//  UserListTableViewCell.swift
//  ToDoApp
//
//  Created by Aman Pratap Singh on 07/09/25.
//

import UIKit

class UserListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setUserListCell(name: String, id: Int) {
        self.idLabel.customLabel(text: "User Id: \(id)", textColor: .green, font: UIFont.systemFont(ofSize: 10, weight: .medium))
        self.nameLabel.customLabel(text: "Name: \(name)", textColor: .systemRed, font: UIFont.systemFont(ofSize: 15, weight: .semibold))
    }
    
}
