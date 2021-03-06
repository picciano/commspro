//
//  Channel.swift
//  commspro
//
//  Created by Anthony Picciano on 1/2/17.
//  Copyright © 2017 Anthony Picciano. All rights reserved.
//

class Channel: NSObject {

    static fileprivate let backendless = Backendless.sharedInstance()
    static fileprivate let dataStore = backendless?.data.of(Channel.self)
    
    var objectId: String!
    var name: String!
    
    static func get(completion: @escaping ([Channel]) -> ()) {
        dataStore?.find(Channel.dataQuery, response: { collection in
            completion(collection?.getCurrentPage() as! [Channel])
        }, error: { (fault) in
            debugPrint(fault!)
            completion([Channel]())
        })
    }
    
    static fileprivate var dataQuery: BackendlessDataQuery {
        let dataQuery = BackendlessDataQuery()
        dataQuery.queryOptions = Channel.queryOptions
        
        return dataQuery
    }
    
    static fileprivate var queryOptions: QueryOptions {
        let queryOptions = QueryOptions()
        queryOptions.sort(by: ["name"])
        
        return queryOptions
    }
    
}
