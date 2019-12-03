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
    
    func createMessage(text: String, fromPatient: Bool, conversationId: Int, callback: @escaping () -> ()) {
        let headersDict : HTTPHeaders = [
            "Content-Type": "application/json",
            "token": self.token
        ]
        
        let params: Parameters = [
            "from_patient": fromPatient,
            "text": text,
        ]
        
        request(baseUrl + "/create-message/\(conversationId)", method: .post, parameters: params, encoding: JSONEncoding.default, headers: headersDict).responseJSON(completionHandler: { (response) in
            
            if let status = response.response?.statusCode,
                status >= 200 && status < 300 {
                
                if let data = response.data {
                    if let result : JSON = try! JSON(data: data) {
                        let message : JSON = result["message"]
                        
                        callback()
                        return
                    }
                }
            }
            
            callback()
            return
        })
        
    }
    
    func createConversation(callback: @escaping (_ conversationId: Int) -> ()) {
        let headersDict : HTTPHeaders = [
            "Content-Type": "application/json",
            "token": self.token
        ]
        
        request(baseUrl + "/create-conversation", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headersDict).responseJSON(completionHandler: { (response) in
            
            if let status = response.response?.statusCode,
                status >= 200 && status < 300 {
                
                if let data = response.data {
                    if let result : JSON = try! JSON(data: data) {
                        let conversationId : Int = result["converation_id"].intValue
                        
                        callback(conversationId)
                        return
                    }
                }
            }
            
            callback(-1)
            return
        })
    }
    
    func getAnxiety(forPatientId: Int, completion: @escaping (_ result: [Double])->()) {
//        request(baseUrl + "/anxiety/1").responseSwiftyJSON {dataResponse in
//
//            if let anxietyValues = (dataResponse.result.value?["data"].arrayValue.map {$0.intValue}) {
//                completion(anxietyValues)
//            } else {
//                completion([])
//            }
//
//        }
        getConversations(forPatientId: forPatientId, completion: {conversations in
            let anxietyValues : [Double] = conversations.map({convo in
                let anxVal : [Double] = convo.messages.map({$0.analysisValue})
                
                var total: Double = 0.0
                
                for a in anxVal {
                    total += a
                }
                
                return total / Double(anxVal.count)
            })
            
            completion(anxietyValues)
        })
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
                        let patientsRaw : [JSON] = result.arrayValue
                        
                        var patients : [Patient] = patientsRaw.compactMap({rawPatient in
                            return Patient(name: rawPatient["name"].stringValue, id: rawPatient["id"].intValue)
                        })
                        
                        // force it to work
                        if patients.count == 0 {
                            print("There was an issue getting patients!")
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
                        let rawMessages : [JSON] = result.arrayValue
                        
                        var convoIdList : [Int] = []
                        var conversations : [Conversation] = []
                        
                        for rawMessage in rawMessages {
                            let convoId = rawMessage["conversation_id"].intValue
                            
                            var messageDate = Date()
                            
                            do {
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "yyyy-MM-dd"
                                dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
                                messageDate = dateFormatter.date(from: rawMessage["date_created"].stringValue)!
                            }
                            
                            let m = RecordedMessage(fromPatient: rawMessage["from_patient"].boolValue, text: rawMessage["text"].stringValue, dateCreated: messageDate, analysisValue: Double(rawMessage["analysis_value"].floatValue))
                            
                            if convoIdList.contains(convoId) {
                                for var (index, convo) in conversations.enumerated() {
                                    if convo.id == convoId {
                                        convo.addMessage(message: m)
                                        
                                        conversations[index] = convo
                                    }
                                }
                            } else {
                                convoIdList.append(convoId)
                                
                                var convo = Conversation(messages: [], dateCreated: messageDate, id: rawMessage["conversation_id"].intValue)
                                
                                convo.addMessage(message: m)
                                
                                conversations.append(convo)
                            }
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
