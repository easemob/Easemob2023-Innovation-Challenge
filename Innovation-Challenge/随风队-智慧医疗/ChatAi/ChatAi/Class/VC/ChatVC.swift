//
//  ChatVC.swift
//  FXChat
//
//  Created by wangfeng on 2020/9/8.
//  Copyright © 2020 wangfeng. All rights reserved.
//

import UIKit
import HyphenateChat


class ChatVC: UIViewController,UITextViewDelegate {

    @IBOutlet weak var msgTV: UITextView!
    @IBOutlet weak var textView: UIView!
    @IBOutlet weak var toBottomValue: NSLayoutConstraint!
    @IBOutlet weak var tableV: UITableView!
    @IBOutlet weak var sendMsgTV: UITextView!

    var conv = EMConversation()
    var dataList = [EMChatMessage]()
    var curSystemMsg:EMChatMessage?
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        // 设置导航条的背景颜色
        navigationItem.title = conv.conversationId
        sendMsgTV.delegate = self
        tableV.tableFooterView = UIView(frame: CGRect.zero)
        tableV.delegate = self
        tableV.dataSource = self
        tableV.wf_registerCell(cell: ChatTextCell.self)
        tableV.wf_registerCell(cell: MineTextCell.self)
        tableV.wf_registerCell(cell: ArchiveCell.self)
        tableV.wf_registerCell(cell: CustomCell.self)

        
        dataList = conv.loadMessagesStart(fromId: nil, count: 50, searchDirection: .up) ?? []
        if dataList.count>0 {
            tableV.reloadData()
            tableV.scrollToRow(at: NSIndexPath(row: dataList.count-1, section: 0) as IndexPath, at: UITableView.ScrollPosition.bottom, animated: true)
        }
     
        EMClient.shared().chatManager?.add(self, delegateQueue: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
            
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        if QianFanManage.shared.model?.role == "1" {
//
//            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "获取用户档案", style: .plain, target: self, action: #selector(OnGetInfo))
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "download"), style: .plain, target: self, action: #selector(OnGetInfo))
        }else{
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "生成记录", style: .plain, target: self, action: #selector(OnRecordClick))
        }
     
        if conv.ext == nil {
            var exts = [String:Any]()
            exts["time"] = Int64(Date().timeIntervalSince1970)*1000
            conv.ext = exts
        }
        let extKeys = conv.ext.keys
        if !extKeys.contains("time") {
            
            var exts = [String:Any]()
            exts["time"] = Int64(Date().timeIntervalSince1970)*1000
            conv.ext = exts
        }
        if !extKeys.contains("name") {
            EMClient.shared().userInfoManager?.fetchUserInfo(byId: [conv.conversationId], completion: { user, err in
                var name = ""
                if err != nil {
           
                }else{
                    let id = String(self.conv.conversationId)
                    let userInfo = user?[id] as? EMUserInfo
                    name = userInfo?.nickname ?? ""
                    if name.count>0 {
                        let exts = NSMutableDictionary(dictionary: self.conv.ext)
                        exts["name"] = name
                        self.conv.ext = exts as? [AnyHashable : Any]
                    }
                }
            })
        }
    }
    
    @objc func OnRecordClick(){
        
        
        let time:Int64 = conv.ext["time"] as! Int64
//        var isUser = false
        var msgs = [[String:String?]]()
        let content = ["role":"user", "content": "根据上述对话，帮我总结一下重点"]
        msgs.append(content)
        let curMsgList = conv.loadMessages(from: time, to: Int64(Date().timeIntervalSince1970)*1000, count: 30)!
        if curMsgList.count > 0 {
            for msg in curMsgList.reversed() {
                if msg.body.type == .text {
                    let text = (msg.body as? EMTextMessageBody)?.text
                    if msg.direction == .send {
//                        if isUser {
                            let content = ["role":"user", "content": text]
                            msgs.insert(content, at: 0)
//                            isUser = false
//                        }
 
                    }else{
//                        if !isUser {
                            let content = ["role":"assistant", "content": text]
                            msgs.insert(content, at: 0)
//                            isUser = true
//                        }
                    }
                }
            }
            if(msgs.count>2){
                QianFanManage.shared.buildRecord(messages: msgs,toConv: conv) {[weak self] in
                    self?.conv.ext = ["time":Int64(Date().timeIntervalSince1970)*1000]
                    let msg = EMChatMessage(conversationID: self!.conv.conversationId, body: EMCustomMessageBody(event: "上述记录已总结", customExt: nil), ext: nil)
                    msg.from = self!.conv.conversationId
                    msg.direction = .receive
                    msg.to = EMClient.shared().currentUsername!
                    EMClient.shared().chatManager?.import([msg])
                    self?.dataList.append(msg)
                    self?.tableV.reloadData()
                    self?.view.makeToast("记录已总结")
                }

                if(conv.conversationId == "ai"){
                    QianFanManage.shared.recommend(messages: msgs)
                }
            }else{
                view.makeToast("没有足够的数据")
            }

        }else{
            view.makeToast("没有新的数据")
        }
        
    }
    @objc func OnGetInfo(){
        
        let alertController = UIAlertController(title: "获取用户信息", message: "", preferredStyle: .actionSheet)
        let action1 = UIAlertAction(title: "获取用户档案", style: .default) { (action) in
            // 处理选项1的操作
            let msg = EMChatMessage(conversationID: self.conv.conversationId, body: EMCmdMessageBody(action: "Archive"), ext: nil)
            EMClient.shared().chatManager?.send(msg, progress: nil, completion: { m, err in
                if (err != nil) {
                    self.view.makeToast("发送成功")
                }else{
                 
                }
            })
        }
        let action2 = UIAlertAction(title: "获取用户咨询记录", style: .default) { (action) in
            // 处理选项2的操作
            let msg = EMChatMessage(conversationID: self.conv.conversationId, body: EMCmdMessageBody(action: "Record"), ext: nil)
            EMClient.shared().chatManager?.send(msg, progress: nil, completion: { m, err in
                if (err != nil) {
                    self.view.makeToast("发送成功")
                }else{
                 
                }
            })
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)

        alertController.addAction(action1)
        alertController.addAction(action2)
        alertController.addAction(cancelAction)
        // 显示弹出框
        present(alertController, animated: true, completion: nil)
    }
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let keyboardHeight = keyboardFrame.height
            // 处理键盘出现时的逻辑
            self.toBottomValue.constant = keyboardHeight
        }
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        // 处理键盘消失时的逻辑
        toBottomValue.constant = 0
    }

    @IBAction func sendMsg() {
        if sendMsgTV.text.isEmpty {
            return
        }
        let msg = EMChatMessage(conversationID: conv.conversationId, body: EMTextMessageBody(text: sendMsgTV.text), ext: nil)
        
        EMClient.shared().chatManager?.send(msg, progress: nil, completion: { [weak self] m, err in
            if (err != nil) {
                
            }else{
                self?.sendMsgTV.text = ""
                self?.dataList.append(msg)
                self?.tableV.reloadData()
                self?.tableV.scrollToRow(at: NSIndexPath(row: (self?.dataList.count ?? 1)-1, section: 0) as IndexPath, at: UITableView.ScrollPosition.bottom, animated: true)
                if self?.conv.conversationId == "ai" {
                    self?.handleMsg(msg: msg)
                }
            }
        })
        
    }
    
    
    func handleMsg(msg:EMChatMessage){
        var msgs = [[String:String?]]()
        let text = (msg.body as? EMTextMessageBody)?.text
        let c = ["role":"user", "content": text]
        msgs.append(c)
        
//        var isUser = false
        
        let time:Int64 = conv.ext["time"] as! Int64
        let curMsgList = conv.loadMessages(from: time, to: Int64(Date().timeIntervalSince1970)*1000, count: 6)!
        for msg in curMsgList.reversed() {
            if msg.body.type == .text {
                let text = (msg.body as? EMTextMessageBody)?.text
                if msg.direction == .send {
//                    if isUser {
//                        let content = ["role":"user", "content": text]
//                        msgs.insert(content, at: 0)
//                        isUser = false
//                    }
                    let content = ["role":"user", "content": text]
                    msgs.insert(content, at: 0)
                }else{
//                    if !isUser {
//                        let content = ["role":"assistant", "content": text]
//                        msgs.insert(content, at: 0)
//                        isUser = true
//                    }
                    let content = ["role":"assistant", "content": text]
                    msgs.insert(content, at: 0)
                }
            }
        }
        

        QianFanManage.shared.getData(messages: msgs) { ret in
            self.curSystemMsg = EMChatMessage(conversationID: self.conv.conversationId, body: EMTextMessageBody(text: ret), ext: nil)
            self.curSystemMsg?.to = EMClient.shared().currentUsername!
            self.curSystemMsg?.from = "ai"
            self.curSystemMsg?.direction = .receive
            print(ret)
            self.tableV.reloadData()
            self.tableV.scrollToRow(at: NSIndexPath(row: self.dataList.count, section: 0) as IndexPath, at: UITableView.ScrollPosition.bottom, animated: true)
 
        } failture: { response in

        } done: {
            if self.curSystemMsg == nil {
                return
            }
            self.curSystemMsg?.timestamp = Int64(Date().timeIntervalSince1970 * 1000)
            EMClient.shared().chatManager?.import([self.curSystemMsg!],completion: { err in
                if err != nil {
                    print("导入失败")
                }

                self.dataList.append(self.curSystemMsg!)
                self.curSystemMsg = nil
                self.tableV.reloadData()
                self.tableV.scrollToRow(at: NSIndexPath(row: self.dataList.count-1, section: 0) as IndexPath, at: UITableView.ScrollPosition.bottom, animated: true)
            })
        }
    }
}
extension ChatVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.curSystemMsg == nil {
            return self.dataList.count
        }
        return self.dataList.count+1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.curSystemMsg != nil  && indexPath.row == dataList.count{
            let cell = tableView.wf_dequeueReusableCell(indexPath: indexPath) as ChatTextCell
            cell.contentLab.text = (self.curSystemMsg!.body as? EMTextMessageBody)?.text
            cell.updateStatus(isSucceed: false)
            return cell
        }
        let msg = dataList[indexPath.row]
        if msg.direction == .send {
            if msg.body.type == .text {
                let cell = tableView.wf_dequeueReusableCell(indexPath: indexPath) as MineTextCell
                cell.contentLab.text = (msg.body as? EMTextMessageBody)?.text
                return cell
            }
        }else{
            if msg.body.type == .text {
                let cell = tableView.wf_dequeueReusableCell(indexPath: indexPath) as ChatTextCell
                cell.contentLab.text = (msg.body as? EMTextMessageBody)?.text
                cell.updateStatus(isSucceed: true)
                return cell
            }else if msg.body.type == .custom {
                let b =  msg.body as? EMCustomMessageBody
                if b?.event == "Archive" {
                    let cell = tableView.wf_dequeueReusableCell(indexPath: indexPath) as CustomCell
                    guard let model = ArchiveModel.deserialize(from: b?.customExt) else{
                        return cell
                    }
                    cell.titleLab.text = "用户档案"
                    cell.content.text = "姓名：\(model.name)\n性别：\(model.gender)\n年龄：\(2023-(Int(model.birth ) ?? 0))\n简介：\(model.info)"
                    cell.backgroundColor = .white
                    cell.content.textColor = .black
                    cell.content.textAlignment = .left
                    return cell
                }else if b?.event == "Record" {
                    let cell = tableView.wf_dequeueReusableCell(indexPath: indexPath) as CustomCell
                    cell.content.text = b?.customExt["data"] ?? ""
                    cell.titleLab.text = "用户咨询记录"
                    cell.backgroundColor = .white
                    cell.content.textColor = .black
                    cell.content.textAlignment = .left
                    return cell
                }else{
                    let cell = tableView.wf_dequeueReusableCell(indexPath: indexPath) as ArchiveCell
                    cell.content.text = b?.event
                    cell.backgroundColor = .clear
                    cell.content.textColor = .darkGray
                    cell.content.textAlignment = .center
                    return cell
                }
 
                
            }
        }
 
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view.endEditing(true)

    }
    
}
extension ChatVC:EMChatManagerDelegate{
    func messagesDidReceive(_ aMessages: [EMChatMessage]) {
        let msg = aMessages.first!
        if msg.conversationId == conv.conversationId {
            dataList.append(msg)
            tableV.reloadData()
            tableV.scrollToRow(at: NSIndexPath(row: dataList.count-1, section: 0) as IndexPath, at: UITableView.ScrollPosition.bottom, animated: true)
        }
    }
}
