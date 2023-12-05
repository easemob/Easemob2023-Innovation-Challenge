//
//  MineVC.swift
//  ChatAi
//
//  Created by wangfeng on 2023/11/23.
//

import UIKit
import HyphenateChat
class MineVC: UIViewController {
    @IBOutlet weak var recordView: UIView!
    
    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var nameLab: UILabel!
    @IBOutlet weak var identityLab: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLab.text = QianFanManage.shared.model?.name
        if (QianFanManage.shared.model?.role  == "1") {
            identityLab.text = "医生"
            recordView.isHidden = true
        }else{
            identityLab.text = "用户"
        }
    }
    
    @IBAction func OnRecordClick() {
        let vc = RecordVC()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func OnQuitClick() {
        EMClient.shared().logout(true) { err in
            if err == nil {
                let appDelegate =  UIApplication.shared.delegate as! AppDelegate
                 appDelegate.window?.rootViewController = LoginVC()
                 appDelegate.window?.makeKeyAndVisible()
            }
        }
    }
}
