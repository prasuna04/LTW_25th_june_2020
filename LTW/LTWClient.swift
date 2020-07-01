//  LTWClient.swift
//  LTW
//  Created by Ranjeet Raushan on 10/04/19.
//  Copyright © 2019 vaayoo. All rights reserved.

import Foundation
import Alamofire
import SwiftyJSON

enum Result {
    case success(JSON,String)
    case failure(Error)
}
final class LTWClient {
    static let shared = LTWClient()
    private init() {
        // private initializer 
    }
    func hitService(withBodyData data: [String: Any],toEndPoint url: String,using httpMethod: HTTPMethod,dueToAction requestType: String,completion: @escaping (Result) -> Void){
        print("EndPoint = \(url)"); print("BodyData = \(data)");print("Action = \(requestType)")
        let header = ["Content-Type": "application/json"]
    
        Alamofire.request(url, method: httpMethod, parameters: data.isEmpty ? nil: data, encoding: JSONEncoding.default, headers: header).responseJSON { response in
            switch(response.result) {
            case .success(let value):
                print("Response = \(value)")
                completion(Result.success(JSON(value),requestType))
                break
            case .failure(let error):
                print("Failure : \(response.result.error!)")
                print("let error : \(error.localizedDescription)")
                completion(Result.failure(error))
                break
            }
        }
    }
}
