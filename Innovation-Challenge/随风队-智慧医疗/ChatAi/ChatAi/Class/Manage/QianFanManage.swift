//
//  QianFanManage.swift
//  ChatAi
//
//  Created by wangfeng on 2023/11/22.
//

import UIKit
import Alamofire
import HyphenateChat
import HandyJSON
import Toast_Swift
class QianFanManage: NSObject {
    static let shared = QianFanManage()

//    var accessToken = ""
    var model:ArchiveModel?
    var doctorData = [ArchiveModel?]()
    func getData(messages:Array<Any>,success:@escaping(_ ret :String)->(), failture:@escaping(_ response :String)->(), done:@escaping()->()) {
        
        let system = ["role": "system",
                      "content": "你是一位全能医生，可以给患者的提问回答出一个很好的建议，长度限制300个字符"]
        var m = messages
        m.insert(system, at: 0)

        let parameters = [
            "input": ["messages": m],
            "model": "qwen-max",
        ] as [String : Any]
        
        
        let data = try! JSONSerialization.data(withJSONObject: parameters, options: [])
        var request = URLRequest(url: URL(string: "https://dashscope.aliyuncs.com/api/v1/services/aigc/text-generation/generation")!)
        let headers: HTTPHeaders = ["Authorization":key,
                                    "Content-Type":"application/json",
                                    "X-DashScope-SSE":"enable"
        ]
        request.headers = headers
        request.httpMethod = HTTPMethod.post.rawValue
        request.httpBody = data
        AF.streamRequest(request)
            .validate()
            .responseStream { response in
                switch response.result {
                case .success(let stream):
                    let string = String(data: stream, encoding: .utf8)
                    let result = string?.components(separatedBy: "data:")
                    let jsonData = result?.last?.data(using: .utf8)
                    do {
                        let jsonDict = try JSONSerialization.jsonObject(with: jsonData!, options: []) as? [String: AnyObject]
                        success(jsonDict?["output"]?["text"] as! String)
                    } catch {
                        let jsonDict = try JSONSerialization.jsonObject(with: stream, options: []) as? [String: Any]
                        print(jsonDict)
                    }
                case .failure(let error):
                    print("请求失败: \(error)")
                    failture("请求失败: \(error)")
                case .none:
                    print("请求完成")
                    done()
                }
            }
    }
    
    func getUserDetail() {
        let url = "\(kUrlUser)\(EMClient.shared().currentUsername ?? "")"
        WFNetworkRequest.sharedNetwork.ToolRequest(url: url, method: .get, params: nil) {[weak self] response in
            print(response)
            if response["code"] as? Int == 200{
                self?.model = ArchiveModel.deserialize(from: response["data"] as? Dictionary)
                self?.getDoctor()
            }
        } failture: { response in
            print(response)
        }
    }
    
    func getDoctor() {
        if model?.role == "0" {
            WFNetworkRequest.sharedNetwork.ToolRequest(url: kUrlDoctor, method: .get, params: nil) {[weak self] response in
                print(response)
                if response["code"] as! Int == 200{
                    self?.doctorData = [ArchiveModel].deserialize(from: response["data"] as? Array) ?? []
                }
            } failture: { response in
                print(response)
            }
        }
    }
    func buildRecord(messages:Array<[String:String?]>, toConv:EMConversation, success:@escaping()->()) {
        print(messages)
        
        let system = ["role": "system",
                      "content": "你是一位医生助理，可以根据聊天记录总结一个纪要，长度限制600个字符"]
        var m = messages
        m.insert(system, at: 0)

        let parameters = [
            "input": ["repetition_penalty":1.0,
                      "messages": m],
            "model": "qwen-max",
        ] as [String : Any]
        
        
        let data = try! JSONSerialization.data(withJSONObject: parameters, options: [])
        var request = URLRequest(url: URL(string: "https://dashscope.aliyuncs.com/api/v1/services/aigc/text-generation/generation")!)
        let headers: HTTPHeaders = ["Authorization":key,
                                    "Content-Type":"application/json",
        ]
        request.headers = headers
        request.httpMethod = HTTPMethod.post.rawValue
        request.httpBody = data
        request.headers = headers
        AF.request(request).responseJSON { response in
            guard let reqData = response.data else{
                return
            }
            let responseData = try? JSONSerialization.jsonObject(with: reqData, options: .mutableContainers) as? [String:AnyObject]
            guard let result = responseData!["output"]?["text"] as? String else{
                return
            }
            print(result)
            
            var toName = "未命名"
            if toConv.ext.keys.contains("name") {
                toName = toConv.ext["name"] as! String
            }
            let p = ["name":toName,"to_hid":toConv.conversationId,"detail":result,"hid":EMClient.shared().currentUsername!] as? [String:String]
            WFNetworkRequest.sharedNetwork.ToolRequest(url: kUrlRecordAdd, method: .post, params: p) { response in
                print(response)
                if response["code"] as! Int == 200{
                    success()
                }
            } failture: { response in
                print(response)
            }
        }
    }
    
    func recommend(messages:Array<[String:String?]>) {
        UIApplication.shared.keyWindow?.makeToastActivity(.center)

        var doctorString = ""
        
        for item in doctorData {
            if item?.hid != "ai" {
                doctorString += "医生姓名：\(item!.name) 医生科室：\(item!.department) 医生擅长领域：\(item!.info)"
            }
        }
        if doctorString.count < 10 {
            UIApplication.shared.keyWindow?.hideToastActivity()
            return
        }
        let system = ["role": "system",
                      "content": "你是一位医生助理，可以根据聊天记录推荐一名合适的医生，如果没有合适的，请回复暂无推荐，长度限制100个字符"]
        var m = messages
        m[m.count-1]["content"] = "\(doctorData) 请根据上面的医生数据和聊天记录给我推荐一名医生"
        let parameters = [
            "input": ["repetition_penalty":1.0,
                      "messages": m],
            "model": "qwen-max",
        ] as [String : Any]
        m.insert(system, at: 0)
        let data = try! JSONSerialization.data(withJSONObject: parameters, options: [])
        var request = URLRequest(url: URL(string: "https://dashscope.aliyuncs.com/api/v1/services/aigc/text-generation/generation")!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.httpBody = data
        let headers: HTTPHeaders = ["Authorization":key,
                                    "Content-Type":"application/json"]

        request.headers = headers
        AF.request(request).responseJSON { response in
            UIApplication.shared.keyWindow?.hideToastActivity()
            guard let reqData = response.data else{
                return
            }
            let responseData = try? JSONSerialization.jsonObject(with: reqData, options: .mutableContainers) as? [String:AnyObject]
            guard let result = responseData!["output"]?["text"] as? String else{
                return
            }
            print(result)
            let alertController = UIAlertController(title: "医生推荐", message: result, preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "确定", style: UIAlertAction.Style.default , handler: { (action: UIAlertAction!) -> Void in
                UIApplication.shared.keyWindow?.rootViewController?.navigationController?.popViewController(animated: true)
            })
            alertController.addAction(okAction)
            UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
        }
    }
}
