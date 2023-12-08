//
//  ConversationVC.swift
//  ChatAi
//
//  Created by wangfeng on 2023/11/16.
//

import UIKit
import SnapKit
import Kingfisher
import HyphenateChat
class ConversationVC: UIViewController {
    var tableV:UITableView!
    private var dataArray = [EMConversation]()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dataArray = EMClient.shared().chatManager?.getAllConversations() ?? []
        tableV.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "会话"
        view.backgroundColor = UIColor(hexCode: "F2F2F7")
        tableV = UITableView()
        tableV.delegate = self
        tableV.dataSource = self
        tableV.rowHeight = 66
        tableV.sectionHeaderHeight = 5
        tableV.sectionFooterHeight = 5
        tableV.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 10))
        tableV.separatorStyle = .none
        tableV.backgroundColor = UIColor(hexCode: "F2F2F7")
        tableV.wf_registerCell(cell: ConversationCell.self)
        view.addSubview(tableV)
        tableV.snp.makeConstraints { make in
            make.left.right.equalTo(0)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        dataArray = EMClient.shared().chatManager?.getAllConversations() ?? []
        EMClient.shared().chatManager?.add(self, delegateQueue: nil)
        
//        SQLManager.shared.initDB(userId: EMClient.shared().currentUsername ?? "test")
//        let url = "https://aip.baidubce.com/oauth/2.0/token?grant_type=client_credentials&client_id=CR8wCLZG9XdGWS4uP4fPy5lh&client_secret=unLlq8eL4hGtCoizmPsWcKmTMpqW1e4G"
        
//        WFNetworkRequest.sharedNetwork.ToolRequest(url: url, method: .get, params: nil) { response in
//            print(response)
//            QianFanManage.shared.accessToken = response["access_token"] as! String
//        } failture: { response in
//            print(response)
//        }
        QianFanManage.shared.getUserDetail()
    }
}
extension ConversationVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.wf_dequeueReusableCell(indexPath: indexPath) as ConversationCell
        let conv = dataArray[indexPath.row]
        if QianFanManage.shared.model?.role == "1" {
            cell.chatAvatarImageV.image = UIImage(named: "patient")
        }else{
            cell.chatAvatarImageV.image = UIImage(named: conv.conversationId == "ai" ? "ai": "doctor")
        }
        cell.chatNameLab.text = conv.conversationId
        if conv.ext != nil {
            if conv.ext.keys.contains("name") {
                cell.chatNameLab.text = conv.ext["name"] as? String
            }
        }
        if conv.latestMessage != nil{
            cell.chatMsgLab.text = (conv.latestMessage.body as? EMTextMessageBody)?.text
            cell.chatTimeLab.text = (conv.latestMessage.timestamp/1000).timeString()
        }else{
            cell.chatMsgLab.text = ""
            cell.chatTimeLab.text = ""
        }
     
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let conv = dataArray[indexPath.row]
        let chatVC = ChatVC()
        chatVC.conv = conv
        chatVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(chatVC, animated: true)
    }
    
}
extension ConversationVC:EMChatManagerDelegate{
    func messagesDidReceive(_ aMessages: [EMChatMessage]) {
        dataArray = EMClient.shared().chatManager?.getAllConversations() ?? []
        tableV.reloadData()
    }
    func cmdMessagesDidReceive(_ aCmdMessages: [EMChatMessage]) {
        for msg in aCmdMessages{
            let body = msg.body as! EMCmdMessageBody
            if body.action == "Archive" {
                let alertController = UIAlertController(title: "重要提示", message: "医生想要你的个人档案，是否允许？", preferredStyle: UIAlertController.Style.alert)
     
                let cancelAction = UIAlertAction(title: "不允许", style: UIAlertAction.Style.cancel, handler: nil)
                let okAction = UIAlertAction(title: "允许", style: UIAlertAction.Style.default , handler: { (action: UIAlertAction!) -> Void in
                    
                    let b = EMCustomMessageBody(event: "Archive", customExt: QianFanManage.shared.model?.toJSON() as? [String:String])
                    let msg1 = EMChatMessage(conversationID: msg.from, body: b, ext: nil)
                    
                    EMClient.shared().chatManager?.send(msg1, progress: nil, completion: { m, err in
                        if (err != nil) {
                            
                        }else{
                         
                        }
                    })
                })
                alertController.addAction(cancelAction)
                alertController.addAction(okAction)
                UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
            }else if body.action == "Record" {
                
                let recordView = GetRecordView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: kScreenH))
                recordView.from = msg.from
                UIApplication.shared.keyWindow?.addSubview(recordView)
    
            }
        }
    }
}
