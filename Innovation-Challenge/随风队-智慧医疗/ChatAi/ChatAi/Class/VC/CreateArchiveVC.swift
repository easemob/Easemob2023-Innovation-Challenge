//
//  CreateArchiveVC.swift
//  ChatAi
//
//  Created by wangfeng on 2023/11/23.
//

import UIKit
import SnapKit
import Toast_Swift
import HyphenateChat
class CreateArchiveVC: UIViewController {
    @IBOutlet weak var passwordTf: UITextField!
    @IBOutlet weak var accountTF: UITextField!
    @IBOutlet weak var infoTV: UITextView!
    @IBOutlet weak var nameTF: UITextField!
    
    @IBOutlet weak var birthBut: UIButton!
    @IBOutlet weak var genderBut: UIButton!
    let pickerView = UIPickerView()
    var GenderNumber = ""
    var BirthNumber = ""
    
    var births:[String] = []
    let genders = ["男","女"]

    var curSelect = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.dataSource = self
        pickerView.delegate = self
        view.addSubview(pickerView)
        pickerView.snp.makeConstraints { make in
            make.right.left.equalToSuperview()
            make.height.equalTo(200)
            make.bottom.equalTo(300)
        }
        
        for item in 1900...2023 {
            births.append(String(item))
        }
        guard let model = QianFanManage.shared.model else{
            return
        }
        self.nameTF.text = model.name
        self.infoTV.text = model.info
        self.birthBut.setTitle(model.birth, for: .normal)
        self.genderBut.setTitle(model.gender, for: .normal)
        self.GenderNumber = model.gender 
        self.BirthNumber = model.birth
    }
    @IBAction func OnBirthClick() {
        curSelect = 0
        pickerView.reloadAllComponents()
        UIView.animate(withDuration: 0.7) {
            self.pickerView.snp.updateConstraints { make in
                make.bottom.equalTo(0)
            }
        }
    }
    
    @IBAction func OnGenderClick() {
        curSelect = 1
        pickerView.reloadAllComponents()
        UIView.animate(withDuration: 0.7) {
            self.pickerView.snp.updateConstraints { make in
                make.bottom.equalTo(0)
            }
        }
    }
    @IBAction func OnSubmitClick() {
        
        if nameTF.text?.count == 0 ||
            BirthNumber.count == 0 ||
            infoTV.text.count == 0 ||
            GenderNumber.count == 0 ||
            accountTF.text?.count == 0 ||
            passwordTf.text?.count == 0{
            
            view.makeToast("信息不完整")
            return
        }
        
        let err =  EMClient.shared().register(withUsername: accountTF.text!, password: passwordTf.text!)
        if err != nil {
            view.makeToast(err?.errorDescription)
            return
        }
        let model = ArchiveModel(
            name: nameTF.text ?? "",
            birth: BirthNumber,
            info: infoTV.text ?? "",
            gender: GenderNumber,
            role:"0",
            hid:  accountTF.text ?? ""
        )
        let p = model.toJSON() as! [String:String]?
        WFNetworkRequest.sharedNetwork.ToolRequest(url: kUrlUserAdd, method: .post, params: p) { response in
            print(response)
            if response["code"] as! Int == 200{
                self.view.makeToast("建档成功") { didTap in
                    self.dismiss(animated: true)
                }
            }
        } failture: { response in
            print(response)
        }
        
    }
    @IBAction func OnCloseClick() {
        self.dismiss(animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        UIView.animate(withDuration: 0.7) {
            self.pickerView.snp.updateConstraints { make in
                make.bottom.equalTo(300)
            }
        }
    }
}
extension CreateArchiveVC:UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }
        
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return curSelect == 0 ? births.count : genders.count
    }
            
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return curSelect == 0 ? births[row] : genders[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if curSelect == 0 {
            birthBut.setTitle(births[row], for: .normal)
            BirthNumber = births[row]
        } else{
            genderBut.setTitle(genders[row], for: .normal)
            GenderNumber = genders[row]
        }
    }
}
