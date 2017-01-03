//
//  ChannelViewController.swift
//  commspro
//
//  Created by Anthony Picciano on 11/25/16.
//  Copyright © 2016 Anthony Picciano. All rights reserved.
//

import UIKit

class ChannelViewController: UIViewController {
    
    @IBOutlet weak var subscribersLabel: UILabel!
    @IBOutlet weak var postMessageButton: CommsButton!
    @IBOutlet weak var subscribeButton: CommsButton!
    @IBOutlet weak var tableView: UITableView!
    
    var channel: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = channel
    }

    @IBAction func subscribeAction(_ sender: Any) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
