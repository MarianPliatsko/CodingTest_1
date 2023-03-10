//
//  ViewController.swift
//  codeChallenge_MarianPliatsko
//
//  Created by mac on 2022-12-10.
//

import UIKit

protocol TableViewControllerDelegate: AnyObject {
    func tableViewController(_ tableViewController: TableViewController,
                             didTapSaveProfile profile: User)
    func tableViewController(_ tableViewController: TableViewController,
                             didTapSavePassword password: String)
}

class TableViewController: UITableViewController {
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var reEnterPassword: UITextField!
    @IBOutlet weak var basicInfoSaveButton: UIButton!
    @IBOutlet weak var passwordSaveButton: UIButton!
    
    weak var delegate: TableViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
    }
    
    @IBAction func basicInfoSaveButtonPressed(_ sender: UIButton) {
        let userName = userNameTextField.text ?? ""
        let firstName = firstNameTextField.text ?? ""
        let lastName = lastNameTextField.text ?? ""
        
        if userName.isEmpty || firstName.isEmpty || lastName.isEmpty {
            return
        }
        delegate?.tableViewController(self, didTapSaveProfile: User(firstName: firstName, userName: userName, lastName: lastName))
    }
    
    @IBAction func passwordSaveButtonPressed(_ sender: UIButton) {
        let password = passwordTextField.text ?? ""
        let secondPassword = reEnterPassword.text ?? ""
        
        if password.isEmpty == false && password == secondPassword {
            delegate?.tableViewController(self, didTapSavePassword: password)
        } else {
            self.present(allertWrongPassword(), animated: true)
        }
    }
    
    func configProfile(_ profile: Profile) {
        userNameTextField.text = profile.data.userName
        firstNameTextField.text = profile.data.firstName
        lastNameTextField.text = profile.data.lastName
    }
    
    private func configUI() {
        basicInfoSaveButton.layer.cornerRadius = 5
        basicInfoSaveButton.layer.borderWidth = 1
        basicInfoSaveButton.layer.borderColor = UIColor.white.cgColor
        
        passwordSaveButton.layer.cornerRadius = 5
        passwordSaveButton.layer.borderWidth = 1
        passwordSaveButton.layer.borderColor = UIColor.white.cgColor
    }
    
    private func allertWrongPassword() -> UIAlertController {
        let alertViewController = UIAlertController(title: "Error!", message: "Passwords must match", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alertViewController.addAction(okAction)
        return alertViewController
    }
}

