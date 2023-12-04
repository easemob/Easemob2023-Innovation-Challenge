//
//  WFNetworkRequest.swift
//  News
//
//  Created by 王峰 on 2018/7/29.
//  Copyright © 2018年 qq. All rights reserved.
//

import UIKit

import Alamofire
// 屏幕宽、高
let kScreenW = UIScreen.main.bounds.width
let kScreenH = UIScreen.main.bounds.height

enum FileType:Int {
    case image
    case video
    case voice
}
//private let NetworkRequestShareInstance = WFNetworkRequest()

class WFNetworkRequest: NSObject {

//    class var sharedInstance: WFNetworkRequest {
//        return NetworkRequestShareInstance
//    }

    static let sharedNetwork = WFNetworkRequest()
    private override init() {}
}

extension WFNetworkRequest{
    
    
    /// 自定义网络请求
    ///
    /// - Parameters:
    ///   - url: 网址
    ///   - isPost: 是否为post请求 默认是
    ///   - params: 参数
    ///   - success: 成功回调
    ///   - failture: 失败回调
    func ToolRequest(url:String, method: HTTPMethod, params:[String:String]?, success:@escaping(_ response :AnyObject)->(), failture:@escaping(_ response :Error)->() ) {

        let headers: HTTPHeaders = ["uuid":""]

        AF.sessionConfiguration.timeoutIntervalForRequest = 60
        AF.request(url,
                   method: method,
                   parameters: params,
                   encoder: JSONParameterEncoder.default,
                   headers: headers).response { response in
            
            switch response.result {
            case .success:
                guard let reqData = response.data else{
                    
                    success(["code":-1,"msg":""] as AnyObject)
                    return
                }
                let responseData = try? JSONSerialization.jsonObject(with: reqData, options: .mutableContainers)
                success(responseData as AnyObject)
                print("Validation Successful")
            case let .failure(error):
                failture(error)
                print(error)
            }
        }
    }
    
    func ToolUploadImageRequest(url:String, fileType:FileType, fileArray:Array<[String:URL]>, success:@escaping(_ response :AnyObject)->(), failture:@escaping(_ response :Error)->() ) {
            
//        let headers: HTTPHeaders = ["userid":UserDefaults.standard.object(forKey: userIDUserDefault) as? String ?? "",
//                                    "token":UserDefaults.standard.object(forKey: tokenIDUserDefault) as? String ?? "",
//                                    "key":UserDefaults.standard.object(forKey: keyIDUserDefault) as? String ?? ""]

        struct HTTPBinResponse: Decodable { let url: String }
        
        AF.upload(multipartFormData: { multipartFormData in
            
            for itemDict:Dictionary in fileArray{
                //withName:和后台服务器的name要一致 ；fileName:可以充分利用写成用户的id，但是格式要写对； mimeType：规定的
                let fileName = itemDict.values.first?.absoluteString.components(separatedBy: "/").last!
                let type = itemDict.keys.first
                if type == "image" {
                    multipartFormData.append(itemDict.values.first!, withName: "file", fileName: fileName!, mimeType:"image/png")
                }else if type == "video" {
                    multipartFormData.append(itemDict.values.first!, withName: "file", fileName: fileName!, mimeType:"video/mp4")
                }else if type == "voice" {
                    multipartFormData.append(itemDict.values.first!, withName: "file", fileName: fileName!, mimeType:"application/octet-stream")
                }
            }
        }, to: url, headers: nil).uploadProgress { (progress) in
            print("------\(progress.fractionCompleted)")
        }.responseJSON { response in
            DispatchQueue.global().async(execute: {
                switch response.result {
                case let .success(result):
                    do {
                        let resultDict:[String:Any] = result as! [String:Any]
                        DispatchQueue.main.async(execute: {
                            success(resultDict as AnyObject)
                        })
                    }
                case let .failure(error):
                    print(error)
                }
            })
        }
    }
    
    func ToolDownload(urlString:String, savePath:String, fileName:String, success:@escaping(_ path :String)->(), failture:@escaping(_ response :String)->(), downloadProgress:@escaping(_ progress :CGFloat)->()) {

        AF.request(urlString, method: .get, headers: nil).responseData { response in
            switch response.result {
            case let .success(data):
                // 使用默认的目录，但是使用用户 ID 来替换默认的文件名
                if FileManager.createFolder(folderPath: "\(FileManager.LibraryDirectory())\(savePath)").isSuccess {
                    try? data.write(to: URL(fileURLWithPath: "\(FileManager.LibraryDirectory())\(savePath)/\(fileName)"))
                }
                success("\(savePath)/\(fileName)")
            case .failure(_):
                failture("下载失败")
            }
        }.downloadProgress { progress in
            downloadProgress(progress.fractionCompleted)
        }
    }
    
//        //MARK: - 多图上传 UIImage 数组 [UIImage]
//        class func IMGS(url:String,param:[String:Any],images:[UIImage],success: @escaping SuccessBlock) {
//            let request = AF.upload(multipartFormData: { (mutilPartData) in
//                   for image in images {
//                       // 图片压缩 在下篇博客 https://editor.csdn.net/md/?articleId=106528518
//                       let imgData = UIImage.imageCompress(image: image)
//                       mutilPartData.append(imgData, withName: "files", fileName: String(String.getCurrentTimeStamp()) + ".jpg", mimeType: "image/jpg/png/jpeg")
//                   }
//                   //有参数
//                   if param != nil {
//                       for key in params.keys {
//                           let value = params[key] as! String
//                           let vData:Data = value.data(using: .utf8)!
//                           mutilPartData.append(vData, withName: key)
//                       }
//                   }
//            }, to: url, usingThreshold: UInt64.init(), method: .post, headers: [], interceptor: nil, fileManager: FileManager())
//            request.uploadProgress { (progress) in
//    //            SVProgressHUD.showInfo(withStatus: "正在上传图片")
//            }
//            request.responseJSON { (response) in
//                print(response)
//                DispatchQueue.global().async(execute: {
//                    switch response.result {
//                    case let .success(result):
//                        do {
//                            let resultDict:[String:Any] = result as! [String:Any]
//                            DispatchQueue.main.async(execute: {
//                                // type 1:部分上传成功,2:全部图片上传失败,0:全部上传成功
//                                let resp_code: Int = (resultDict["resp_code"] as! Int)
//                                switch resp_code {
//                                case 0:
//                                    success(resultDict)
//                                case 1:
//                                    SVProgressHUD.showError(withStatus: (resultDict["resp_msg"] as! String))
//                                default:
//                                    SVProgressHUD.showError(withStatus: (resultDict["resp_msg"] as! String))
//                                }
//                            })
//                        }
//                    case let .failure(error):
//                        SVProgressHUD.dismiss()
//                        print(error)
//                    }
//                })
//            }
//        }
}



























