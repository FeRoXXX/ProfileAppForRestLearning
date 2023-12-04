//
//  ViewController.swift
//  ProfileApp
//
//  Created by Александр Федоткин on 22.11.2023.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    @IBOutlet weak var appNameLabel: UILabel!
    @IBOutlet weak var signinUpLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func forgotPasswordClicked(_ sender: Any) {
    }
    
    @IBAction func signupClicked(_ sender: Any) {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else { return }
        Authentication().signIn(email: email, password: password) { result in
            switch result {
            case .success(_):
                do {
                    let res = try result.get()
                    print("result: \(res)")
                    let user = User.sharedInstance
                    user.accessToken = res.accessToken
                    user.user = res.user
                } catch {
                    print("error decode datas")
                }
                self.performSegue(withIdentifier: "toRegisterVC", sender: nil)
            case .failure(let error):
                AlertClass.makeAlert(on: self, titleInput: "Error", messageInput: error.localizedDescription)
            }
        }
    }
    
    @IBAction func signinClicked(_ sender: Any) {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else { return }
        
        Authentication().signIn(email: email, password: password) { result in
            switch result {
            case .success(_):
                do {
                    let res = try result.get()
                    let user = User.sharedInstance
                    user.accessToken = res.accessToken
                    user.user = res.user
                } catch {
                    print("error decode datas")
                }
                self.performSegue(withIdentifier: "toFeedVC", sender: nil)
            case .failure(let error):
                AlertClass.makeAlert(on: self, titleInput: "Error", messageInput: error.localizedDescription)
            }
        }
    }

}
