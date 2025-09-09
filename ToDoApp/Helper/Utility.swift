//
//  Utility.swift
//  ToDoApp
//
//  Created by Aman Pratap Singh on 07/09/25.
//

import Foundation
import UIKit

enum AlertButtonType: String {
    case okay = "Okay"
    case cancel = "Cancel"
    case retry = "Retry"
    case markAsCompleted = "Mark as Completed"
    case uncompleteTask = "Uncomplete Task"
    case editTodo = "Edit Todo"
    case none
}


class Utility {

    static let shared = Utility()
    
    private init() {}

    func showAlert(
        title: String, message: String, buttons: [AlertButtonType],
        handler: @escaping (AlertButtonType) -> Void = { _ in }
    ) {
        DispatchQueue.main.async {
            if let topController = UIApplication.topViewController() {
                if topController is UIAlertController {
                } else {
                    let alert = UIAlertController(
                        title: title, message: message, preferredStyle: .alert)
                    buttons.forEach { button in
                        alert.addAction(
                            UIAlertAction(
                                title: button.rawValue, style: .default,
                                handler: { action in
                                    if let index = alert.actions.firstIndex(
                                        where: { $0 === action })
                                    {
                                        handler(buttons[index])
                                    }
                                })
                        )
                    }
                    topController.present(
                        alert, animated: true, completion: nil)
                }
            }
        }
    }

}
