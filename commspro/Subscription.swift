//
//  Subscription.swift
//  commspro
//
//  Created by Anthony Picciano on 1/2/17.
//  Copyright © 2017 Anthony Picciano. All rights reserved.
//

class Subscription: NSObject {
    
    static fileprivate let backendless = Backendless.sharedInstance()
    static fileprivate let dataStore = backendless?.data.of(Subscription.ofClass())
    
    var user: BackendlessUser!
    var channel: Channel!
    
    static func get(completion: @escaping ([Subscription]) -> ()) {
        
        let currentUser: BackendlessUser? = backendless?.userService.currentUser
        
        guard currentUser != nil else {
            completion([Subscription]())
            return
        }
        
        let dataQuery = BackendlessDataQuery()
        dataQuery.whereClause = "user.name = \'\(currentUser?.name)\'"
        
        dataStore?.find(dataQuery, response: { collection in
            completion(collection?.getCurrentPage() as! [Subscription])
        }, error: { fault in
            debugPrint(fault!)
            completion([Subscription]())
        })
    }
    
    static fileprivate var dataQuery: BackendlessDataQuery {
        let dataQuery = BackendlessDataQuery()
        dataQuery.queryOptions = Subscription.sortOption
        
        return dataQuery
    }
    
    static fileprivate var sortOption: QueryOptions {
        let queryOptions = QueryOptions()
        queryOptions.sort(by: ["channel"])
        
        return queryOptions
    }

}
