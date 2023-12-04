//
//  ConsultVC.swift
//  ChatAi
//
//  Created by wangfeng on 2023/11/23.
//

import UIKit
import SnapKit
import HyphenateChat
class ConsultVC: UIViewController {
    var collectionV: UICollectionView!

    var dataArray = [ArchiveModel?]()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "咨询"
        view.backgroundColor = UIColor(hexCode: "F2F2F7")
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 12, left: 14, bottom: 5, right: 14)
        layout.invalidateLayout()
        layout.itemSize = CGSize(width: 80, height: 130)
        layout.footerReferenceSize = CGSize(width: kScreenW, height: 80)
        collectionV = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionV.backgroundColor = UIColor(hexCode: "F2F2F7")
        view.addSubview(collectionV)
        collectionV.snp.makeConstraints { make in
            make.left.right.equalTo(0)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        collectionV.delegate = self
        collectionV.dataSource = self
        collectionV.wf_registerCell(cell: ConsultCell.self)
        dataArray = QianFanManage.shared.doctorData
 
    }

}
extension ConsultVC:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.wf_dequeueReusableCell(indexPath: indexPath) as ConsultCell
        let model = dataArray[indexPath.row]
        cell.nameLab.text = model?.name
        cell.typeLab.text = model?.department
        cell.iconImageV.image = UIImage(named: model?.hid == "ai" ? "ai": "doctor")
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = dataArray[indexPath.row]
        
        if model?.hid == "ai" {
            let chatVC = ChatVC()
            chatVC.conv = EMClient.shared().chatManager?.getConversation(model!.hid, type: .chat, createIfNotExist: true) ?? EMConversation()
            chatVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(chatVC, animated: true)
            return
        }
        let alertController = UIAlertController(title: "医生擅长领域", message: model?.info, preferredStyle: UIAlertController.Style.alert)

        let cancelAction = UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel, handler: nil)
        let okAction = UIAlertAction(title: "去咨询", style: UIAlertAction.Style.default , handler: { (action: UIAlertAction!) -> Void in
            
            let chatVC = ChatVC()
            chatVC.conv = EMClient.shared().chatManager?.getConversation(model!.hid, type: .chat, createIfNotExist: true) ?? EMConversation()
            chatVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(chatVC, animated: true)
        })
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
}
