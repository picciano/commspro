//
//  ChannelViewController.swift
//  commspro
//
//  Created by Anthony Picciano on 11/25/16.
//  Copyright © 2016 Anthony Picciano. All rights reserved.
//

import UIKit

class ChannelViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var subscribersLabel: UILabel!
    @IBOutlet weak var postMessageButton: CommsButton!
    @IBOutlet weak var subscribeButton: CommsButton!
    @IBOutlet weak var tableView: UITableView!
    
    var channel: Channel?
    var posts: [Post]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = channel?.name
        
        if let channel = channel {
            Post.get(from: channel) { posts in
                self.posts = posts
                self.tableView.reloadData()
            }
        }
    }

    @IBAction func subscribeAction(_ sender: Any) {
        
    }
    
    // MARK: - Table View
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableViewCell", for: indexPath) as! PostTableViewCell
        cell.post = posts?[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
