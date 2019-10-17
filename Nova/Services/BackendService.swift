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
    
    var conversationsById = [
        "11": [
            "How was your day?",
            "Not so good today"
        ],
        "12": [
            "How was your day?",
            "Pretty good",
        ]
    ]
    
    var conversationsWithIdDate = [
        [
            "id": 11,
            "date": "10-13-19"
        ],
        [
            "id": 12,
            "date": "10-14-19"
        ]
    ]
    
    func getAnxiety(forUserId: Int, completion: @escaping (_ result: [Int])->()) {
        request(baseUrl + "/anxiety/1").responseSwiftyJSON {dataResponse in
            
            if let anxietyValues = (dataResponse.result.value?["data"].arrayValue.map {$0.intValue}) {
                completion(anxietyValues)
            } else {
                completion([])
            }
        
        }
    }
    
    func getDoctorsPatients() -> [Dictionary<String, Any>] {
        return [
//            [
//                "name": "Stephen Boxwell",
//                "id": 1
//            ],
            [
                "name": "Carter",
                "id": 2
            ]
        ]
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
    
    func getConversations(ofDoctor: Int, forPatientId: Int) -> [Dictionary<String, Any>] {
        
        return conversationsWithIdDate
    }
    
    func getConversationById(conversationId: Int) -> [String] {
        
        return self.conversationsById[String(conversationId)]!
    }

}
