//
//  ChatListCell.swift
//  XFindr
//
//  Created by Rajat on 3/27/17.
//  Copyright © 2017 Honey Maheshwari. All rights reserved.
//

import UIKit

class ChatListCell: UITableViewCell {

    @IBOutlet var imgUser: UIImageView!
    @IBOutlet var imgStatus: UIImageView!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblLastMessage: UILabel!
    @IBOutlet var imgArrow: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
