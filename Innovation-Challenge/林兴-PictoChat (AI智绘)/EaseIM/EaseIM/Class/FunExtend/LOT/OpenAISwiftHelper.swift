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
public class OpenAISwiftHelper: NSObject {
    private static let authToken = "sk-"
//    private static let authToken = "sk-"
    let openAPI = OpenAISwift(config: .makeDefaultOpenAI(apiKey: authToken))
    
    @objc public func sendGTP(query: String,completion: @escaping APIResult) {
        openAPI.sendCompletion(with: "鲁迅和周树人什么关系", maxTokens: 120) { result in
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
}


