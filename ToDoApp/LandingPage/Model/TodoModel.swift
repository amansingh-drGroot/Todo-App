//
//  Todo.swift
//  ToDoApp
//
//  Created by Aman Pratap Singh on 09/09/25.
//

enum TodoCategory: String, CaseIterable {
    case completed = "completed"
    case uncompleted = "uncompleted"
}

struct TodoModel: Codable {
    
    var todoName: String
    var todoDesc: String
    let todoId: Int
    let todoAssignedUserId: Int
    var todoCategoryType: String
}
