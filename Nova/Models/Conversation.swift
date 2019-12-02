//
//  Conversation.swift
//  Nova
//
//  Created by Max Dignan on 11/22/19.
//  Copyright © 2019 Silvana Garcia. All rights reserved.
//

import Foundation

struct RecordedMessage {
    var fromPatient : Bool = false
    var text : String = ""
    var dateCreated : Date = Date()
    var analysisValue : Double = 0.0
}

struct Conversation {
    var messages : [RecordedMessage]
    var dateCreated : Date = Date()
    var id : Int = 0
}

extension Conversation {
    mutating func addMessage(message: RecordedMessage) {
        var msgs = self.messages

        msgs.append(message)

        self.messages = msgs
    }
}
