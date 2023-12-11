//
//  OpenAISwiftHelper.swift
//  EaseIM
//
//  Created by mac on 2023/12/7.
//  Copyright © 2023 mac. All rights reserved.
//

import Foundation
import OpenAISwift

public typealias APIResult = (String?, NSError?) -> ()

@objcMembers
public class EaseOpenAISwiftHelper: NSObject {
    @objc public static let shareHelper: EaseOpenAISwiftHelper = EaseOpenAISwiftHelper()
    
    public var authToken: String = ""
    public var baseURL: String = ""
    
    lazy var openAPI: OpenAISwift = {
        OpenAISwift(config: .makeDefaultOpenAI(apiKey: authToken,baseURL: baseURL))
    }()
    
    @objc public func sendCompletion(query: String,completion: @escaping APIResult) {
        openAPI.sendCompletion(with: query, maxTokens: 2000) { result in
            switch result {
            case .success(let openApi):
                guard let response = openApi.choices else {
                    completion(nil,nil)
                    return
                }

                var returnString: String = ""
                for choice in response {
                    returnString.append(choice.text)
                }
                completion(returnString,nil)

            case .failure(let error):
                completion(nil,error as? NSError)
            }
        }
    }
    
    @available(iOS 13.0.0, *)
    @objc public func sendChat(query: String, completion: @escaping APIResult) async {
        // 个人apikey没有有数据，买的gpt4 apikey有数据
        do {
            let chat: [ChatMessage] = [
                ChatMessage(role: .user, content: query)
            ]
                        
            let result = try await openAPI.sendChat(with: chat, model: .gpt4(.gpt4))
            // use result
            guard let response = result.choices else {
                completion(nil,nil)
                return
            }
            var returnString: String = ""
            for choice in response {
                returnString.append(choice.message.content ?? "-")
            }
            completion(returnString,nil)
        } catch let error {
            completion(nil,error as? NSError)
        }
    }
    
    @available(iOS 13.0.0, *)
    @objc public func createImage(query: String, completion: @escaping APIResult) {
        // 个人apikey有数据，买的gpt4 apikey没数据
        openAPI.sendImages(with: query, numImages: 1, size: .size256) { result in // Result<OpenAI, OpenAIError>
            switch result {
            case .success(let success):
                let url = success.data?.first?.url ?? ""
                completion(url,nil)
            case .failure(let failure):
                completion(nil,failure as? NSError)
            }
        }
    }
    
    
}


