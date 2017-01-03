//
//  Post.swift
//  commspro
//
//  Created by Anthony Picciano on 1/2/17.
//  Copyright © 2017 Anthony Picciano. All rights reserved.
//

class Post: NSObject {
    
    static fileprivate let backendless = Backendless.sharedInstance()
    static fileprivate let dataStore = backendless?.data.of(Post.ofClass())
    
    var objectId: String!
    var channel: Channel!
    var sender: BackendlessUser!
    var recipient: BackendlessUser?
    var read: Bool = false
    var plaintext: String?
    var ciphertext: String?
    var created: Date!
    
    static func get(from channel: Channel, completion: @escaping ([Post]) -> ()) {
        let dataQuery = Post.dataQuery
        if let objectId = channel.objectId {
            dataQuery.whereClause = "channel.objectId = '\(objectId)'"
        }
        
        dataStore?.find(dataQuery, response: { collection in
            completion(collection?.getCurrentPage() as! [Post])
        }, error: { fault in
            debugPrint(fault!)
            completion([Post]())
        })
    }
    
    static fileprivate var dataQuery: BackendlessDataQuery {
        let dataQuery = BackendlessDataQuery()
        dataQuery.queryOptions = Post.queryOptions
        
        return dataQuery
    }
    
    static fileprivate var queryOptions: QueryOptions {
        let queryOptions = QueryOptions()
        queryOptions.sort(by: ["created"])
        
        return queryOptions
    }
    
    static func height(for post: Post, frame: CGRect) -> CGFloat {
        let messageTextRect = CGRect(x: frame.minX + 5, y: frame.minY + 25, width: frame.width - 10, height: frame.height - 25)
        let messageTextStyle: NSMutableParagraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        messageTextStyle.alignment = .left
        
        let messageTextFontAttributes = [ NSFontAttributeName : UIFont.systemFont(ofSize: 17),
                                          NSForegroundColorAttributeName : CommsProStyleKit.commsBlue,
                                          NSParagraphStyleAttributeName : messageTextStyle]
        
        let plaintext: NSString = post.plaintext as NSString? ?? ""
        let messageTextTextHeight = plaintext.boundingRect(with: CGSize(width: messageTextRect.size.width, height: .infinity), options: .usesLineFragmentOrigin, attributes: messageTextFontAttributes, context: nil).size.height
        
        return messageTextTextHeight + 35;
    }

}
