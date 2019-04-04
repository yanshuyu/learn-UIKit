//
//  LoginViewController.swift
//  01_navgationViewController
//
//  Created by sy on 2019/4/4.
//  Copyright © 2019 sy. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var userNameTextFiled: UITextField!
    @IBOutlet weak var passWordTextFiled: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Login Scene Loaded Success.")
        
    }
    
    @IBAction func onLoginButtonClick(_ sender: UIButton) {
        if checkAccount() {
            let callSceneNavController = self.storyboard?.instantiateViewController(withIdentifier: "CallNavController") as? CallSceneNavigationController
            if let navController = callSceneNavController {
                present(navController, animated: true, completion: { print("Login success")})
            }
        }else{
            let alertController = UIAlertController(title: "Login Error", message: "Unvailde Account, Try Again!", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "ok", style: .cancel, handler: nil))
            present(alertController, animated: true, completion: nil)
            
        }
    }
    
    func checkAccount() -> Bool {
        var isOk = false
        let userName = self.userNameTextFiled.text ?? ""
        let passWord = self.passWordTextFiled.text ?? ""
        if userName == "yanshuyu" && passWord == "abc717171" {
            isOk = true
        }
        return isOk
    }
}
