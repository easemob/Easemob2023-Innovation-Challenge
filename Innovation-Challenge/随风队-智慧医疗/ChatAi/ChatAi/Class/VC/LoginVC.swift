//
//  LoginVC.swift
//  FXChat
//
//  Created by wangfeng on 2020/9/4.
//  Copyright © 2020 wangfeng. All rights reserved.
//

import UIKit
import HyphenateChat
import Toast_Swift
class LoginVC: UIViewController {
    @IBOutlet weak var modileTF: UITextField!
    @IBOutlet weak var passwdTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()


    }


    @IBAction func OnLoginClick() {
        
        EMClient.shared().login(withUsername: modileTF.text ?? "", password: passwdTF.text ?? "") { aUsername, err in
            if (err != nil) {
                self.view.makeToast(err?.errorDescription)
            }else{
                
               let appDelegate =  UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = MainTabBarC()
                appDelegate.window?.makeKeyAndVisible()
            }
        }
 
    }
    @IBAction func OnRegisterClick() {
        let vc = CreateArchiveVC()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
