//
//  Group.swift
//  commspro
//
//  Created by Anthony Picciano on 1/2/17.
//  Copyright © 2017 Anthony Picciano. All rights reserved.
//

class Group: NSObject {
    
    static fileprivate let backendless = Backendless.sharedInstance()
    static fileprivate let dataStore = backendless?.data.of(Group.ofClass())
    
    var objectId: String!
    var name: String!
    var channels: [Channel] = []
    
    var sortedChannels: [Channel] {
        return channels.sorted(by: { (lhs, rhs) -> Bool in
            lhs.name < rhs.name
        })
    }
    
    static func get(completion: @escaping ([Group]) -> ()) {
        dataStore?.find(Group.dataQuery, response: { collection in
            completion(collection?.getCurrentPage() as! [Group])
        }, error: { (fault) in
            debugPrint(fault!)
            completion([Group]())
        })
    }
    
    static fileprivate var dataQuery: BackendlessDataQuery {
        let dataQuery = BackendlessDataQuery()
        dataQuery.queryOptions = Group.queryOptions
        
        return dataQuery
    }
    
    static fileprivate var queryOptions: QueryOptions {
        let queryOptions = QueryOptions()
        queryOptions.sort(by: ["name"])
        
        return queryOptions
    }

}
