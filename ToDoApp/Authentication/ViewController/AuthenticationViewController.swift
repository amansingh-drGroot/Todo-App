//
//  AuthenticationViewController.swift
//  ToDoApp
//
//  Created by Aman Pratap Singh on 04/09/25.
//

import UIKit

// Authentication Options
enum AuthenticationOptions {
    case login
    case register
}

class AuthenticationViewController: UIViewController {
    
    @IBOutlet weak var toDoLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var userListLabel: UILabel!
    @IBOutlet weak var userListTableView: UITableView!
    
    var userLists = [User]() {
        didSet {
            self.userListTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configTheme()
        configDependency()
    }
    
    private func configTheme() {
        self.toDoLabel.customLabel(
            text: "To Do App",
            textColor: .black,
            font: UIFont.systemFont(ofSize: 24, weight: .bold)
        )
        self.loginButton.customButton(
            title: "Login",
            titleFont: UIFont.systemFont(ofSize: 20, weight: .regular),
            textColor: .white,
            cornerRadius: self.loginButton.layer.frame.height / 2,
            backgroundColor: .systemBlue
        )
        self.registerButton.customButton(
            title: "Register",
            titleFont: UIFont.systemFont(ofSize: 20, weight: .regular),
            textColor: .white,
            cornerRadius: self.loginButton.layer.frame.height / 2,
            backgroundColor: .systemBlue
        )
        
        self.userListLabel.customLabel(
            text: "Already Logged In Users",
            textColor: .black,
            font: UIFont.systemFont(ofSize: 24, weight: .bold)
        )
    }
    
    private func configDependency() {
        self.userListTableView.register(UINib(nibName: "UserListTableViewCell", bundle: nil), forCellReuseIdentifier: "UserListTableViewCell")
        self.userListTableView.delegate = self
        self.userListTableView.dataSource = self
        self.userLists = UserStorage.shared.loadUsers()
    }
    
    @IBAction func didTapLoginButton(_ sender: UIButton) {
        let authSB = UIStoryboard(name: "Authentication", bundle: nil)
        let loginRegisterVC = authSB.instantiateViewController(withIdentifier: "LoginRegisterViewController") as! LoginRegisterViewController
        loginRegisterVC.modalPresentationStyle = .formSheet
        loginRegisterVC.loginRegiseterType = .login
        self.present(loginRegisterVC, animated: true)
    }
    
    @IBAction func didTapRegisterButton(_ sender: UIButton) {
        let authSB = UIStoryboard(name: "Authentication", bundle: nil)
        let loginRegisterVC = authSB.instantiateViewController(withIdentifier: "LoginRegisterViewController") as! LoginRegisterViewController
        loginRegisterVC.modalPresentationStyle = .formSheet
        loginRegisterVC.loginRegiseterType = .register
        self.present(loginRegisterVC, animated: true)
    }
    
}

extension AuthenticationViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.userLists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let userListCell = tableView.dequeueReusableCell(withIdentifier: "UserListTableViewCell") as! UserListTableViewCell
        userListCell.selectionStyle = .none
        userListCell.setUserListCell(name: userLists[indexPath.row].name, id: userLists[indexPath.row].id)
        return userListCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let authSB = UIStoryboard(name: "Authentication", bundle: nil)
        let loginRegisterVC = authSB.instantiateViewController(withIdentifier: "LoginRegisterViewController") as! LoginRegisterViewController
        loginRegisterVC.modalPresentationStyle = .formSheet
        loginRegisterVC.loginRegiseterType = .login
        loginRegisterVC.user =  userLists[indexPath.row]
        self.present(loginRegisterVC, animated: true)
    }
}
