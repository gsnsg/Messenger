//
//  ChatViewController.swift
//  Messenger
//
//  Created by Nikhi on 19/09/20.
//  Copyright © 2020 nikhit. All rights reserved.
//

import UIKit
import MessageKit


struct Message: MessageType {
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
}

struct Sender: SenderType {
    var photoURL: String
    var senderId: String
    var displayName: String
}

class ChatViewController: MessagesViewController {
    
    private var messages = [Message]()
    
    private let selfSender = Sender(photoURL: "", senderId: "1", displayName: "Joe Smith")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messages.append(Message(sender: selfSender ,
                                messageId: "Hello There",
                                sentDate: Date(),
                                kind: .text("Hello World")))
        
        messages.append(Message(sender: selfSender ,
                                messageId: "Hello There",
                                sentDate: Date(),
                                kind: .text("Hello World")))
        
        messages.append(Message(sender: selfSender ,
                                messageId: "Hello There",
                                sentDate: Date(),
                                kind: .text("Hello World")))
    
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
    }
    
}

extension ChatViewController: MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
    func currentSender() -> SenderType {
        self.selfSender
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return self.messages.count
    }
    
    
}
