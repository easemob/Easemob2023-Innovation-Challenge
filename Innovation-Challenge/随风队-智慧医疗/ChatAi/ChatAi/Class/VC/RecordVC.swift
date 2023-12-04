//
//  RecordVC.swift
//  ChatAi
//
//  Created by wangfeng on 2023/11/30.
//

import UIKit
import HyphenateChat
class RecordVC: UIViewController {
    var tableV:UITableView!
    private var dataArray = [RecordModel?]()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "咨询记录"
        view.backgroundColor = .white
        tableV = UITableView()
        tableV.delegate = self
        tableV.dataSource = self
        tableV.sectionHeaderHeight = 15
        tableV.sectionFooterHeight = 5
        tableV.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 10))
        tableV.separatorStyle = .none
        tableV.backgroundColor = UIColor(hexCode: "F2F2F7")
        tableV.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 40))
        tableV.wf_registerCell(cell: RecordCell.self)
        view.addSubview(tableV)
        tableV.snp.makeConstraints { make in
            make.left.right.equalTo(0)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(0)
        }

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
    

}
extension RecordVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.wf_dequeueReusableCell(indexPath: indexPath) as RecordCell
        let model = dataArray[indexPath.row]
        cell.contentLab.text = "咨询医生：\(model!.name)\n\n\(model!.detail)"
        
        let date = Date(timeIntervalSince1970: TimeInterval(model!.timestamp/1000))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        cell.timeLab.text = dateFormatter.string(from: date)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    
}
