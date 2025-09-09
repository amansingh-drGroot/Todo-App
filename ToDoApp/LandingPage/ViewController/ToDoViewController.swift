//
//  ToDoViewController.swift
//  ToDoApp
//
//  Created by Aman Pratap Singh on 09/09/25.
//

import UIKit

class ToDoViewController: UIViewController {
    
    @IBOutlet weak var todoAppLabel: UILabel!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var filterButtonLabel: UILabel!
    @IBOutlet weak var todoTableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var upperSlab: UIView!
    
    var selectedUser: User?
    var todoList: [TodoModel] = []
    var filterTodoList = [TodoModel]() {
        didSet {
            self.todoTableView.reloadData()
        }
    }
    var filterDropDownAction: [UIAction] = []
    var filterCategoryType: TodoCategory?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configTheme()
        configDependency()
        setTodoFilter()
    }
    
    private func configTheme() {
        
        self.upperSlab.layer.cornerRadius = 6
        self.todoAppLabel.customLabel(text: "Your's ToDo", textColor: .black, font: UIFont.systemFont(ofSize: 30, weight: .bold))
        self.filterButtonLabel.customLabel(text: "Filter:", textColor: .black, font: UIFont.systemFont(ofSize: 15, weight: .regular))
        self.filterButton.customButton(title: "Select", titleFont: UIFont.systemFont(ofSize: 12, weight: .semibold), textColor: .white, cornerRadius: 12, backgroundColor: .black)
        self.addButton.layer.cornerRadius = self.addButton.layer.frame.height / 2
    }
    
    private func configDependency() {
        
        self.todoTableView.register(UINib(nibName: "ToDoListTableViewCell", bundle: nil), forCellReuseIdentifier: "ToDoListTableViewCell")
        self.todoTableView.delegate = self
        self.todoTableView.dataSource = self
        self.todoList = TodoManager.shared.loadSpecificTodos(userId: self.selectedUser?.id ?? 0)
        self.filterTodoList = self.todoList
    }
    
    private func createTodo() {
        
        let alert = UIAlertController(title: "Add ToDo", message: "Please add your ToDo", preferredStyle: .alert)
        
        alert.addTextField { (todoName) in
            todoName.text = ""
            todoName.placeholder = "Enter ToDo"
        }
        
        alert.addTextField() { (description) in
            description.text = ""
            description.placeholder = "Enter Description"
        }
        
        let addAction = UIAlertAction(title: "Add", style: .default) { (_) in
            
            guard let todoNameTextField = alert.textFields?.first, let descriptionTextField = alert.textFields?.last else { return }
            
            TodoManager.shared.addTodo(TodoModel(todoName: todoNameTextField.text ?? "", todoDesc: descriptionTextField.text ?? "", todoId: Int.random(in: 1_000_000_000...9_999_999_999), todoAssignedUserId: self.selectedUser?.id ?? 0, todoCategoryType: TodoCategory.uncompleted.rawValue))
            self.todoList = TodoManager.shared.loadSpecificTodos(userId: self.selectedUser?.id ?? 0)
            self.filterTodoList = self.todoList
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true)
        
    }
    
    private func editTodo(todo: TodoModel) {
        var todo = todo
        let alert = UIAlertController(title: "Edit ToDo", message: "Please Edit your ToDo", preferredStyle: .alert)
        
        alert.addTextField { (todoName) in
            todoName.text = todo.todoName
            todoName.placeholder = "Enter ToDo"
        }
        
        alert.addTextField() { (description) in
            description.text = todo.todoDesc
            description.placeholder = "Enter Description"
        }
        
        let addAction = UIAlertAction(title: "Edit", style: .default) { (_) in
            
            guard let todoNameTextField = alert.textFields?.first, let descriptionTextField = alert.textFields?.last else { return }
            todo.todoName = todoNameTextField.text ?? ""
            todo.todoDesc = descriptionTextField.text ?? ""
            TodoManager.shared.updateTodo(todo)
            self.refereshTodo()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true)
    }
    
    private func setTodoFilter() {
        
        TodoCategory.allCases.forEach({ values in
            let action = UIAction(title: values.rawValue, image: nil) { action in
                self.filterButton.setTitle(values.rawValue, for: .normal)
                self.filterCategoryType = values
                self.filterTodoList = self.todoList.filter { $0.todoCategoryType == values.rawValue }
            }
            filterDropDownAction.append(action)

        })
        
        let filterMenu = UIMenu(title: "", options: .displayInline, children: filterDropDownAction)
        if #available(iOS 14.0, *) {
            self.filterButton.menu = filterMenu
            self.filterButton.showsMenuAsPrimaryAction = true
        } else {
            Utility.shared.showAlert(title: "", message: "Need iOS version atleast 14.0", buttons: [.okay])
        }
    }
    
    private func refereshTodo() {
        self.todoList = TodoManager.shared.loadSpecificTodos(userId: self.selectedUser?.id ?? 0)
        if let selectedCategory = self.filterCategoryType {
            self.filterTodoList = self.todoList.filter { $0.todoCategoryType == selectedCategory.rawValue }
        } else {
            self.filterTodoList = self.todoList
        }
    }
    

    @IBAction func didTapAddButton(_ sender: UIButton) {
        self.createTodo()
    }
    
    @IBAction func didTapClearButton(_ sender: UIButton) {
        self.filterCategoryType = nil
        self.filterButton.setTitle("Select", for: .normal)
        self.filterTodoList = self.todoList
    }
    
    
}

extension ToDoViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterTodoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let todoCell = tableView.dequeueReusableCell(withIdentifier: "ToDoListTableViewCell") as! ToDoListTableViewCell
        todoCell.setTodoListData(
            todo: filterTodoList[indexPath.row].todoName,
            id: "\(filterTodoList[indexPath.row].todoId)",
            desc: filterTodoList[indexPath.row].todoDesc,
            status: filterTodoList[indexPath.row].todoCategoryType
        )
        return todoCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Utility.shared.showAlert(title: "Todo Manager", message: "Manage your todo: \( todoList[indexPath.row].todoName)", buttons: [.markAsCompleted, .uncompleteTask, .editTodo, .cancel], handler: { handler in
            switch handler {
            case .markAsCompleted:
                var todo = self.filterTodoList[indexPath.row]
                todo.todoCategoryType = TodoCategory.completed.rawValue
                TodoManager.shared.updateTodo(todo)
                self.refereshTodo()
            case .uncompleteTask:
                var todo = self.filterTodoList[indexPath.row]
                todo.todoCategoryType = TodoCategory.uncompleted.rawValue
                TodoManager.shared.updateTodo(todo)
                self.refereshTodo()
            case .editTodo:
                self.editTodo(todo: self.filterTodoList[indexPath.row])
            default:
                print("None")
            }
        })
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _,_,_  in
            TodoManager.shared.deleteTodo(self.filterTodoList[indexPath.row])
            self.refereshTodo()
        }

        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
}
