//
//  ChatViewController.swift
//  Nova
//
//  Created by Silvana Garcia on 8/29/19.
//  Copyright © 2019 Silvana Garcia. All rights reserved.
//
import UIKit
import MessageKit
import Assistant

class ChatViewController: MessagesViewController {
    var assistant: Assistant?
    let dispatchGroup =  DispatchGroup()
    var messages: [WatsonMessage] = []
    var sessionId = ""
    var novaUser = Sender(id: "0", displayName: "Nova")
    var patientUser = Sender(id: "1", displayName: "Patient")
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        setupWatsonAssistant()
        createWatsonSession()
    }
    
    /**
     Configure VC
     */
    func configureVC() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Go Back", style: .plain, target: self, action: #selector(navigateToMenu))
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messageInputBar.delegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        // remove avatar from message view
        if let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout {
            layout.textMessageSizeCalculator.outgoingAvatarSize = .zero
            layout.textMessageSizeCalculator.incomingAvatarSize = .zero
        }
        messagesCollectionView.reloadData()
        messagesCollectionView.scrollToBottom(animated: true)
    }
    
    /**
    Create a
     */
    func createWatsonSession() {
        
        dispatchGroup.enter()
        
        assistant?.createSession(assistantID: Credentials.assistantId) {
            response, error in
            
            guard let session = response?.result else {
                print(error?.localizedDescription ?? "unknown error")
                return
            }
            
            self.sessionId = session.sessionID
            print(self.sessionId)
            self.dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            print("done with session ID call")
            
            self.startConversation()
        }
    }
    
    /**
     Setup configuration watson assistant
     */
    func setupWatsonAssistant() {
        assistant = Assistant(version: "2019-02-28", apiKey: Credentials.WatsonApiKey)
        assistant?.serviceURL = "https://gateway.watsonplatform.net/assistant/api"
    }
    
    /**
     Start conversation
     */
    func startConversation() {

        dispatchGroup.enter()
        assistant?.message(assistantID: Credentials.assistantId, sessionID: sessionId) {
            response, error in
            if let error = error {
                switch error {
                case let .http(statusCode, message, metadata):
                    switch statusCode {
                    case .some(404):
                        // Handle Not Found (404) exception
                        print("Not found")
                    case .some(413):
                        // Handle Request Too Large (413) exception
                        print("Payload too large")
                    default:
                        if let statusCode = statusCode {
                            print("Error - code: \(statusCode), \(message ?? "")")
                        }
                    }
                default:
                    print(error.localizedDescription)
                }
                return
            }
            
            guard let result = response?.result else {
                print(error?.localizedDescription ?? "unknown error")
                return
            }
            
            for message in result.output.generic ?? [] {
                var inputMessage = WatsonMessage(sender: self.novaUser, messageId: UUID().uuidString, text: message.text ?? kEmptyString)
                self.messages.append(inputMessage)
            }
            self.dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            print("done reading messages")
            self.messagesCollectionView.reloadData()
            self.messagesCollectionView.scrollToBottom(animated: true)
        }

    }
    
    /**
     Go back to menu
     */
    @objc func navigateToMenu() {
        let navigationController = UINavigationController(rootViewController: RegistrationViewController())
        present(navigationController, animated: false, completion: nil)
    }
}

// MARK: - MessagesDataSource

extension ChatViewController: MessagesDataSource {
    func numberOfSections(
        in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func currentSender() -> Sender {
        return patientUser
    }
    
    func messageForItem(
        at indexPath: IndexPath,
        in messagesCollectionView: MessagesCollectionView) -> MessageType {
        
        return messages[indexPath.section]
    }
    
    func messageTopLabelHeight(
        for message: MessageType,
        at indexPath: IndexPath,
        in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        
        return 12
    }
    
    func messageTopLabelAttributedText(
        for message: MessageType,
        at indexPath: IndexPath) -> NSAttributedString? {
        
        return NSAttributedString(
            string: message.sender.displayName,
            attributes: [.font: UIFont.systemFont(ofSize: 12)])
    }
}
// MARK: - MessagesLayoutDelegate

extension ChatViewController: MessagesLayoutDelegate {
    
    func footerViewSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        return CGSize(width: 0, height: 8)
    }
    
    func heightForLocation(message: MessageType, at indexPath: IndexPath, with maxWidth: CGFloat, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 0
    }
}

// MARK: - MessagesDisplayDelegate

extension ChatViewController: MessagesDisplayDelegate {
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? kSenderColor : kReceiverColor
    }
    
    func shouldDisplayHeader(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> Bool {
        return false
    }
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
        return .bubbleTail(corner, .curved)
    }
}

// MARK: - MessageInputBarDelegate

extension ChatViewController: MessageInputBarDelegate {
    func messageInputBar(
        _ inputBar: MessageInputBar,
        didPressSendButtonWith text: String) {
        
        let newMessage = WatsonMessage(
            sender: patientUser,
            messageId: UUID().uuidString,
            text: text)
        
        messages.append(newMessage)
        inputBar.inputTextView.text = ""
        messagesCollectionView.reloadData()
        messagesCollectionView.scrollToBottom(animated: true)
        
        dispatchGroup.enter()
        assistant?.message(assistantID: Credentials.assistantId, sessionID: sessionId, input: MessageInput(text: text)) {
            response, error in
            if let error = error {
                switch error {
                case let .http(statusCode, message, metadata):
                    switch statusCode {
                    case .some(404):
                        // Handle Not Found (404) exception
                        print("Not found")
                    case .some(413):
                        // Handle Request Too Large (413) exception
                        print("Payload too large")
                    default:
                        if let statusCode = statusCode {
                            print("Error - code: \(statusCode), \(message ?? "")")
                        }
                    }
                default:
                    print(error.localizedDescription)
                }
                return
            }
            
            guard let result = response?.result else {
                print(error?.localizedDescription ?? "unknown error")
                return
            }
            
            for message in result.output.generic ?? [] {
                var inputMessage = WatsonMessage(sender: self.novaUser, messageId: UUID().uuidString, text: message.text ?? kEmptyString)
                self.messages.append(inputMessage)
            }
            self.dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            print("done reading messages")
            self.messagesCollectionView.reloadData()
            self.messagesCollectionView.scrollToBottom(animated: true)
        }
        
    }
}
