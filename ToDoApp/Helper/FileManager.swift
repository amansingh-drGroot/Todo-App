//
//  FileManager.swift
//  ToDoApp
//
//  Created by Aman Pratap Singh on 07/09/25.
//

import Foundation
 
class UserStorage {
    
    static let shared = UserStorage()
    
    private init() {}
    
    private let fileName = "users.json"
    
    private var fileURL: URL? {
        do {
            let documentDir = try FileManager.default.url(for: .documentDirectory,
                                                          in: .userDomainMask,
                                                          appropriateFor: nil,
                                                          create: true)
            return documentDir.appendingPathComponent(fileName)
        } catch {
            print("Error getting file path: \(error)")
            return nil
        }
    }
    
    // MARK: Save all users
    private func saveUsers(_ users: [User]) {
        guard let fileURL = fileURL else { return }
        
        do {
            let data = try JSONEncoder().encode(users)
            try data.write(to: fileURL, options: .atomic)
            print("Users saved at: \(fileURL)")
        } catch {
            print("Error saving users: \(error)")
        }
    }
    
    // MARK: Load all users
    func loadUsers() -> [User] {
        guard let fileURL = fileURL else { return [] }
        
        do {
            let data = try Data(contentsOf: fileURL)
            let users = try JSONDecoder().decode([User].self, from: data)
            return users
        } catch {
            print("No users found, returning empty list")
            return []
        }
    }
    
    // MARK: Add new user
    func addUser(_ user: User) {
        var users = loadUsers()
        users.append(user)
        saveUsers(users)
    }
    
    // MARK: Update user by ID
    func updateUser(_ updatedUser: User) {
        var users = loadUsers()
        if let index = users.firstIndex(where: { $0.id == updatedUser.id }) {
            users[index] = updatedUser
            saveUsers(users)
            print("User updated successfully")
        } else {
            print("User not found")
        }
    }
}


class TodoManager {
    
    static let shared = TodoManager()
    
    private init() {}
    
    private let fileName = "todos.json"
    
    private var fileURL: URL? {
        do {
            let documentDir = try FileManager.default.url(for: .documentDirectory,
                                                          in: .userDomainMask,
                                                          appropriateFor: nil,
                                                          create: true)
            return documentDir.appendingPathComponent(fileName)
        } catch {
            print("Error getting file path: \(error)")
            return nil
        }
    }
    
    // MARK: Save all todo
    private func saveTodo(_ todos: [TodoModel]) {
        guard let fileURL = fileURL else { return }
        
        do {
            let data = try JSONEncoder().encode(todos)
            try data.write(to: fileURL, options: .atomic)
            print("Users saved at: \(fileURL)")
        } catch {
            print("Error saving todos: \(error)")
        }
    }
    
    // MARK: Load all todo
    func loadTodos() -> [TodoModel] {
        guard let fileURL = fileURL else { return [] }
        
        do {
            let data = try Data(contentsOf: fileURL)
            let todos = try JSONDecoder().decode([TodoModel].self, from: data)
            return todos
        } catch {
            print("No todo found, returning empty list")
            return []
        }
    }
    
    // MARK: Load SpecificUser todo
    func loadSpecificTodos(userId: Int) -> [TodoModel] {
        let todos = loadTodos()
            .filter({ $0.todoAssignedUserId == userId })
        return todos
    }
    
    // MARK: Add new todo
    func addTodo(_ todo: TodoModel) {
        var todos = loadTodos()
        todos.append(todo)
        saveTodo(todos)
    }
    
    // MARK: Update Todo by ID
    func updateTodo(_ updatedTodo: TodoModel) {
        var todos = loadTodos()
        if let index = todos.firstIndex(where: { $0.todoId == updatedTodo.todoId }) {
            todos[index] = updatedTodo
            saveTodo(todos)
            print("Todo updated successfully")
        } else {
            print("Todo not found")
        }
    }
    
    // MARK: Delete Todo by ID
    func deleteTodo(_ updatedTodo: TodoModel) {
        var todos = loadTodos()
        if let index = todos.firstIndex(where: { $0.todoId == updatedTodo.todoId }) {
            todos.remove(at: index)
            saveTodo(todos)
            print("Todo updated successfully")
        } else {
            print("Todo not found")
        }
    }
}
