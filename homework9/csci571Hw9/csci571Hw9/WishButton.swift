//
//  WishButton.swift
//  csci571Hw9
//
//  Created by 徐子祎 on 4/22/19.
//  Copyright © 2019 cs571. All rights reserved.
//

import UIKit

class WishButton: UIButton {

    // Images
    let checkedImage = UIImage(named: "wishListFilled")!.withRenderingMode(.alwaysTemplate) as UIImage
    let uncheckedImage = UIImage(named: "wishListEmpty")!.withRenderingMode(.alwaysTemplate) as UIImage
    
    // Bool property
    var isChecked: Bool = false {
        didSet{
            if isChecked == true {
                self.setImage(checkedImage, for: UIControl.State.normal)
                self.tintColor = UIColor.red
            } else {
                self.setImage(uncheckedImage, for: UIControl.State.normal)
                self.tintColor = UIColor.gray
            }
        }
    }
    
    override func awakeFromNib() {
        self.addTarget(self, action:#selector(buttonClicked(sender:)), for: UIControl.Event.touchUpInside)
        self.isChecked = false
    }
    
    @objc func buttonClicked(sender: UIButton) {
        if sender == self {
            isChecked = !isChecked
        }
    }

}
