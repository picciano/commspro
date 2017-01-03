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

}
