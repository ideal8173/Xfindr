//
//  ProfileGuestbookCell.swift
//  XFindr
//
//  Created by Rajat on 4/5/17.
//  Copyright © 2017 Honey Maheshwari. All rights reserved.
//

import UIKit

class ProfileGuestbookCell: UITableViewCell {

    @IBOutlet var imgProfile: UIImageView!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var lblDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
