//
//  LoginRegisterViewController.swift
//  ToDoApp
//
//  Created by Aman Pratap Singh on 07/09/25.
//

import UIKit

class LoginRegisterViewController: UIViewController {
    
    @IBOutlet weak var loginRegisterLabel: UILabel!
    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var loginRegisterButton: UIButton!
    
    var loginRegiseterType: AuthenticationOptions?
    var user: User?

    override func viewDidLoad() {
        super.viewDidLoad()

        configTheme()
    }
    
    private func configTheme() {
        
        self.loginRegisterLabel.customLabel(
            text: loginRegiseterType == .login ? "Login Here" : "Register Here",
            textColor: .black,
            font: UIFont.systemFont(ofSize: 24, weight: .bold)
        )
        
        self.nameTextfield.placeholder = "Enter your name"
        self.passwordTextfield.placeholder = "Enter your password"
        
        self.loginRegisterButton.customButton(
            title: self.loginRegiseterType == .login ? "Login" : "Register",
            titleFont: UIFont.systemFont(ofSize: 20, weight: .regular) ,
            textColor: .black,
            cornerRadius: self.loginRegisterButton.layer.frame.height / 2,
            backgroundColor: .systemBlue
        )
        
        if !(self.user?.name.isEmpty ?? true) {
            self.nameTextfield.text = self.user?.name
            self.nameTextfield.isEnabled = false
        }
    }
    
    private func loginRegisterUser() {
        if self.nameTextfield.text?.isEmpty ?? true || self.passwordTextfield.text?.isEmpty ?? true {
            Utility.shared.showAlert(title: "Warning !", message: "Please fill the Mandalory fields", buttons: [.okay])
        } else {
            switch self.loginRegiseterType {
            case .login:
                if self.authenticateUser() {
                    Utility.shared.showAlert(
                        title: "Success",
                        message: "Login Successfully !",
                        buttons: [.okay], handler: { _ in
                            self.moveToLandingPage()
                        }
                    )
                } else {
                    Utility.shared.showAlert(
                        title: "Failure",
                        message: "Unable to find the user",
                        buttons: [.retry],
                        handler: { _ in
                            self.passwordTextfield.text = ""
                            self.passwordTextfield.becomeFirstResponder()
                        }
                    )
                }
            case .register:
                UserStorage.shared.addUser(User(id: Int.random(in: 1_000_000_000...9_999_999_999), name: self.nameTextfield.text ?? "", password: self.passwordTextfield.text ?? ""))
                Utility.shared.showAlert(
                    title: "Success",
                    message: "User Register Successfully",
                    buttons: [.okay], handler: { _ in
                        self.moveToLandingPage()
                    }
                )
            case .none:
                print("NONE")
            }
        }
    }
    
    private func authenticateUser() -> Bool {
        let currentUser = UserStorage.shared.loadUsers()
        if let _ = currentUser.first(where: {$0.name == self.nameTextfield.text ?? "" && $0.password == self.passwordTextfield.text ?? ""}) {
            return true
        }
        return false
    }
    
    private func moveToLandingPage() {
        
        let landingSB = UIStoryboard(name: "LandingPage", bundle: nil)
        let weatherVC = landingSB.instantiateViewController(withIdentifier: "WeatherViewController") as! WeatherViewController
        weatherVC.modalPresentationStyle = .overFullScreen
        weatherVC.selectedUser = self.user
        self.present(weatherVC, animated: true)
    }
    
    
    @IBAction func didTapLoginRegisterButton(_ sender: UIButton) {
        
        self.loginRegisterUser()
    }
    
}
