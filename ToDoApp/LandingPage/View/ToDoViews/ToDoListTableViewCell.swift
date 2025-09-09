//
//  ToDoListTableViewCell.swift
//  ToDoApp
//
//  Created by Aman Pratap Singh on 09/09/25.
//

import UIKit

class ToDoListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var todoLabel: UILabel!
    @IBOutlet weak var todoIdLabel: UILabel!
    @IBOutlet weak var todoDescLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setTodoListData(todo: String, id: String, desc: String, status: String) {
        
        self.todoLabel.customLabel(text: "Todo: \(todo)", textColor: .black, font: UIFont.systemFont(ofSize: 20, weight: .semibold))
        self.todoIdLabel.customLabel(text: "User ID: \(id) | Status: \(status == TodoCategory.completed.rawValue ? "Completed" : "Incomplete")", textColor: .black, font: UIFont.systemFont(ofSize: 12, weight: .medium))
        self.todoDescLabel.customLabel(text: "Description: \(desc)", textColor: .black, font: UIFont.systemFont(ofSize: 16, weight: .regular))
    }

}
