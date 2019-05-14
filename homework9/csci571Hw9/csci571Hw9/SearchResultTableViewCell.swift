//
//  SearchResultTableViewCell.swift
//  csci571Hw9
//
//  Created by 徐子祎 on 4/21/19.
//  Copyright © 2019 cs571. All rights reserved.
//

import UIKit
import Toast_Swift

protocol SearchResultTableViewCellDelegate: class{
    func didTapBtn(cell: SearchResultTableViewCell)
}

class SearchResultTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageField: UIImageView!
    @IBOutlet weak var titleField: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var ship: UILabel!
    @IBOutlet weak var zipcode: UILabel!
    @IBOutlet weak var condition: UILabel!
    @IBOutlet weak var wishBtn: WishButton!
    
    weak var delegateCell: SearchResultTableViewCellDelegate?
    var inWish = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func pressWishBtn(_ sender: Any) {
        inWish = !inWish
        delegateCell?.didTapBtn(cell: self)
    }

}
