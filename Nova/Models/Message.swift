//
//  Message.swift
//  Nova
//
//  Created by Silvana Garcia on 8/29/19.
//  Copyright © 2019 Silvana Garcia. All rights reserved.
//

import Foundation
import UIKit
import MessageKit

struct WatsonMessage {
    let messageId: String
    let sender: Sender
    let text: String

    
    init(sender: Sender, messageId: String,text: String) {
        self.sender = sender
        self.text = text
        self.messageId = messageId
    }
}

extension WatsonMessage: MessageType {
    var sentDate: Date {
        return Date()
    }
    
    var kind: MessageKind {
        return .text(text)
    }
}

