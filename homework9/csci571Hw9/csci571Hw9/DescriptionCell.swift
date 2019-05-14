//
//  DescriptionCell.swift
//  csci571Hw9
//
//  Created by 徐子祎 on 4/24/19.
//  Copyright © 2019 cs571. All rights reserved.
//

import UIKit

class DescriptionCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var value: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
