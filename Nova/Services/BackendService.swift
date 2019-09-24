//
//  BackendService.swift
//  Nova
//
//  Created by Max Dignan on 9/23/19.
//  Copyright © 2019 Silvana Garcia. All rights reserved.
//

import Foundation
import Alamofire
import Alamofire_SwiftyJSON

class BackendService {
    let baseUrl = "https://nova-backend-osu.herokuapp.com/nova"
    
    static let shared = BackendService()
    
    func getAnxiety(forUserId: Int, completion: @escaping (_ result: [Int])->()) {
        request(baseUrl + "/anxiety/1").responseSwiftyJSON {dataResponse in
            
            if let anxietyValues = (dataResponse.result.value?["data"].arrayValue.map {$0.intValue}) {
                completion(anxietyValues)
            } else {
                completion([])
            }
        
        }
    }
    
//    func getConversations(forUserId: Int, completion: @escaping (_ result: [Int])->()) {
//        request(baseUrl + "/conversations/1").responseSwiftyJSON {dataResponse in
//
//            if let anxietyValues = (dataResponse.result.value?["conversations"].arrayValue.map {$0 as? [[String : String]]) {
//
//            } else {
//
//            }
//
//        }
//    }

}
