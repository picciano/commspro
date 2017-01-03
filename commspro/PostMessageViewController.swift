//
//  PostMessageViewController.swift
//  commspro
//
//  Created by Anthony Picciano on 1/3/17.
//  Copyright © 2017 Anthony Picciano. All rights reserved.
//

import UIKit

class PostMessageViewController: UIViewController {

    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var characterCountLabel: UILabel!
    @IBOutlet weak var postMessageButton: CommsButton!
    @IBOutlet weak var cancelButton: CommsButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
