//
//  PostTableViewCell.swift
//  commspro
//
//  Created by Anthony Picciano on 1/3/17.
//  Copyright © 2017 Anthony Picciano. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var senderNameLabel: UILabel!
    @IBOutlet weak var createDateLabel: UILabel!
    @IBOutlet weak var plaintextLabel: UILabel!
    
    static var df: DateFormatter!
    
    var post: Post? {
        didSet {
            senderNameLabel.text = post?.sender.name as String?
            createDateLabel.text = format(date: post?.created)
            plaintextLabel.text = post?.plaintext
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    fileprivate func format(date: Date?) -> String? {
        guard let date = date else {
            return nil
        }
        
        if PostTableViewCell.df == nil {
            let df = DateFormatter()
            df.dateStyle = .medium
            df.timeStyle = .short
            
            PostTableViewCell.df = df
        }
        
        return PostTableViewCell.df.string(from: date)
    }

}
