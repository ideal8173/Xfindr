//
//  SelectionCell.swift
//  XFindr
//
//  Created by Rajat on 4/6/17.
//  Copyright © 2017 Honey Maheshwari. All rights reserved.
//

import UIKit

class SelectionCell: UITableViewCell {

    @IBOutlet var imgCheckUncheck: UIImageView!
    @IBOutlet var lblName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
