//
//  WishListTableViewCell.swift
//  csci571Hw9
//
//  Created by 徐子祎 on 4/25/19.
//  Copyright © 2019 cs571. All rights reserved.
//

import UIKit

class WishListTableViewCell: UITableViewCell {
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var ship: UILabel!
    @IBOutlet weak var condition: UILabel!
    @IBOutlet weak var zipcode: UILabel!
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
