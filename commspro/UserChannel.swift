//
//  UserChannel.swift
//  commspro
//
//  Created by Anthony Picciano on 1/2/17.
//  Copyright © 2017 Anthony Picciano. All rights reserved.
//

class UserChannel: NSObject {
    
    static fileprivate let backendless = Backendless.sharedInstance()
    static fileprivate let dataStore = backendless?.data.of(UserChannel.self)
    
    var objectId: String!
    var user: BackendlessUser!
    var channel: Channel!
    
    static func get(completion: @escaping ([UserChannel]) -> ()) {
        let currentUser: BackendlessUser? = backendless?.userService.currentUser
        
        guard currentUser != nil else {
            completion([UserChannel]())
            return
        }
        
        let dataQuery = UserChannel.dataQuery
        if let objectId = currentUser?.objectId {
            dataQuery.whereClause = "user.objectId = \'\(objectId)\'"
        }
        
        dataStore?.find(dataQuery, response: { collection in
            completion(collection?.getCurrentPage() as! [UserChannel])
        }, error: { fault in
            debugPrint(fault!)
            completion([UserChannel]())
        })
    }
    
    static fileprivate var dataQuery: BackendlessDataQuery {
        let dataQuery = BackendlessDataQuery()
        dataQuery.queryOptions = UserChannel.queryOptions
        
        return dataQuery
    }
    
    static fileprivate var queryOptions: QueryOptions {
        let queryOptions = QueryOptions()
        queryOptions.sort(by: ["created"])
        
        return queryOptions
    }

}
