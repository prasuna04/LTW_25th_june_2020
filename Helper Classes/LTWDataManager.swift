//  LTWDataManager.swift
//  LTW
//  Created by Vaayoo on 04/10/19.
//  Copyright © 2019 vaayoo. All rights reserved.

import Foundation
import Alamofire
class LTWDataManager: NSObject {
    
    func getResponse<T: Decodable>(endPoint: String, method: HTTPMethod, param: [String: Any]?, completionHandler: @escaping (T) -> Void){
        let header = ["Content-Type": "application/json"]
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 120
        manager.request(endPoint, method: method, parameters: param ?? nil, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            switch(response.result){
            case .success( _):
                //print(value)
                let decode = JSONDecoder()
                //decode.keyDecodingStrategy = .convertFromSnakeCase
                if let data = try? decode.decode(T.self, from: response.data!){
                    completionHandler(data)
                }
                break
                
            case .failure(let error):
                print(error)
                break
            }
        }
    }
}

