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
import SwiftyJSON

class BackendService {
    let baseUrl = "https://nova-backend-osu.herokuapp.com/nova"
    
    static let shared = BackendService()
    
    var token : String = ""
    var loggedIn : Bool = false
    var isDoctor : Bool = false
    var id : Int = 0
    
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
    
    func getDoctorsPatients(completion: @escaping (_ data: [Patient]) -> ()) {
        let headersDict : HTTPHeaders = [
            "Content-Type": "application/json",
            "token": self.token
        ]
        
        request(baseUrl + "/patients", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headersDict).responseJSON(completionHandler: { (response) in
            
            if let status = response.response?.statusCode,
                status >= 200 && status < 300 {
                
                if let data = response.data {
                    if let result : JSON = try! JSON(data: data) {
                        let patientsRaw : [JSON] = result["patients"].arrayValue
                        
                        var patients : [Patient] = patientsRaw.compactMap({rawPatient in
                            return Patient(name: "", id: 0)
                        })
                        
                        // force it to work
                        if patients.count == 0 {
                            patients = [
                                Patient(name: "Carter", id: 1)
                            ]
                        }
                        
                        completion(patients)
                        return
                    }
                }
            }
            
            completion([])
            return
        })
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
    
    func getConversations(forPatientId: Int, completion: @escaping (_ conversations: [Conversation]) -> ()) {
        let headersDict : HTTPHeaders = [
            "Content-Type": "application/json",
            "token": self.token
        ]
        
        request(baseUrl + "/conversations/\(forPatientId)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headersDict).responseJSON(completionHandler: { (response) in
            
            if let status = response.response?.statusCode,
                status >= 200 && status < 300 {
                
                if let data = response.data {
                    if let result : JSON = try! JSON(data: data) {
                        let conversationsRaw : [JSON] = result["conversations"].arrayValue
                        
                        var conversations : [Conversation] = conversationsRaw.compactMap({rawConvo in
                            return Conversation(messages: [])
                        })
                        
                        // force it to work
                        if conversations.count == 0 {
                            conversations = [
                                Conversation(messages: [
                                    RecordedMessage(fromPatient: false, text: "How are you today?", dateCreated: Date(), analysisValue: 0.0),
                                    RecordedMessage(fromPatient: true, text: "Pretty good!", dateCreated: Date(), analysisValue: 1.0),
                                ], dateCreated: Date())
                            ]
                        }
                        
                        completion(conversations)
                        return
                    }
                }
            }
            
            completion([])
            return
        })
    }
    
    func getConversationById(conversationId: Int) -> [String] {
        
        return self.conversationsById[String(conversationId)]!
    }
    
    func login(username: String, password: String, completion: @escaping (_ success: Bool, _ isDoctor: Bool, _ id: Int) -> ()) {
        let headersDict : HTTPHeaders = [
            "Content-Type": "application/json",
        ]
        
        let params : [String: String] = [
            "username": username,
            "password": password
        ]
        
        request(baseUrl + "/login", method: .post, parameters: params, encoding: JSONEncoding.default, headers: headersDict).responseJSON(completionHandler: { (response) in
            
            if let status = response.response?.statusCode,
                status >= 200 && status < 300 {
                
                if let result = response.result.value as? NSDictionary {
                    let token : String = result["token"] as! String
                    let isDoctor : Bool = result["isDoctor"] as! Bool
                    let id : Int = result["id"] as! Int
                    
                    self.loggedIn = true
                    self.token = token
                    self.isDoctor = isDoctor
                    self.id = id
                    
                    completion(true, isDoctor, id)
                    return
                }
            }
            
            completion(false, false, -1)
            return
        })
        
    }

}
