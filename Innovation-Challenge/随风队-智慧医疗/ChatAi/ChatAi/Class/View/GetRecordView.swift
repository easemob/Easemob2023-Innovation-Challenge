//
//  GetRecordView.swift
//  ChatAi
//
//  Created by wangfeng on 2023/12/8.
//

import UIKit
import HyphenateChat
class GetRecordView: UIView {
    var tableV:UITableView!
    var from = ""
    
    private var dataArray = [RecordModel?]()
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeUI(){
        self.backgroundColor = .black.withAlphaComponent(0.7)
        tableV = UITableView()
        tableV.delegate = self
        tableV.dataSource = self
        tableV.sectionHeaderHeight = 15
        tableV.sectionFooterHeight = 5
        tableV.separatorStyle = .none
        tableV.backgroundColor = UIColor(hexCode: "F2F2F7")
        let lab = UILabel(frame: CGRect(x: 0, y: 0, width: self.width, height: 70))
        lab.font = UIFont.systemFont(ofSize: 14)
        lab.numberOfLines = 2
        lab.textColor = .blue
        lab.textAlignment = .center
        lab.backgroundColor = .white
        lab.text = "医生想获取你近期的咨询记录，请在下面记录中选择一条发给医生，如果不允许，请点背景关闭"
        tableV.tableHeaderView = lab
        tableV.wf_registerCell(cell: RecordCell.self)
        self.addSubview(tableV)
        tableV.snp.makeConstraints { make in
            make.left.equalTo(40)
            make.right.equalTo(-40)
            make.top.equalTo(100)
            make.bottom.equalTo(-100)
        }
        tableV.layer.masksToBounds = true
        tableV.layer.cornerRadius = 10
        getData()
    }
    func getData(){
        let url = "\(kUrlRecord)\(EMClient.shared().currentUsername ?? "")"
        WFNetworkRequest.sharedNetwork.ToolRequest(url: url, method: .get, params: nil) { response in
            print(response)
            if response["code"] as? Int == 200{
                self.dataArray = [RecordModel].deserialize(from: response["data"] as? Array) ?? []
                self.tableV.reloadData()
            }
        } failture: { response in
            print(response)
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.removeFromSuperview()
    }
}
extension GetRecordView:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.wf_dequeueReusableCell(indexPath: indexPath) as RecordCell
        let model = dataArray[indexPath.row]
        cell.contentLab.text = "咨询医生：\(model!.name)\n\n\(model!.detail)"
        cell.contentLab.font = UIFont.systemFont(ofSize: 13)

        let date = Date(timeIntervalSince1970: TimeInterval(model!.timestamp/1000))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        cell.timeLab.text = dateFormatter.string(from: date)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let model = dataArray[indexPath.row]

        let b = EMCustomMessageBody(event: "Record", customExt: ["data":model?.detail] as? [String:String])
        let msg1 = EMChatMessage(conversationID: self.from, body: b, ext: nil)
        
        EMClient.shared().chatManager?.send(msg1, progress: nil, completion: { m, err in
            if (err != nil) {
                
            }else{
             
            }
        })
        self.removeFromSuperview()
    }
    
}
