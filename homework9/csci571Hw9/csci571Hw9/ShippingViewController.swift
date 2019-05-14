//
//  ShippingViewController.swift
//  csci571Hw9
//
//  Created by 徐子祎 on 4/24/19.
//  Copyright © 2019 cs571. All rights reserved.
//

import UIKit
import SwiftyJSON
import SwiftSpinner
import Toast_Swift
import Alamofire

class ShippingViewController: UIViewController{

    @IBOutlet weak var sellerSection: UIStackView!
    
    @IBOutlet weak var storeName: UIView!
    @IBOutlet weak var feedbackScore: UIView!
    @IBOutlet weak var popularity: UIView!
    @IBOutlet weak var feedbackStar: UIView!
    
    @IBOutlet weak var storeBtn: UIButton!
    @IBOutlet weak var feedbackScoreLab: UILabel!
    @IBOutlet weak var popularityLab: UILabel!
    @IBOutlet weak var feedbackStarImg: UIImageView!
    
    @IBOutlet weak var shipSection: UIStackView!
    
    @IBOutlet weak var shipCost: UIView!
    @IBOutlet weak var globalShip: UIView!
    @IBOutlet weak var handle: UIView!
    
    @IBOutlet weak var shipCostLab: UILabel!
    @IBOutlet weak var globalShipLab: UILabel!
    @IBOutlet weak var handleLab: UILabel!
    
    @IBOutlet weak var returnSection: UIStackView!
    
    @IBOutlet weak var policy: UIView!
    @IBOutlet weak var refundMode: UIView!
    @IBOutlet weak var returnWithin: UIView!
    @IBOutlet weak var paidBy: UIView!
    
    @IBOutlet weak var policyLab: UILabel!
    @IBOutlet weak var refundModeLab: UILabel!
    @IBOutlet weak var returnWithinLab: UILabel!
    @IBOutlet weak var paidByLab: UILabel!
    
    var input = JSON()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func showTab(){
        showAll()
        showSeller()
        showShip()
        showReturn()
        SwiftSpinner.hide()
    }
    
    func showAll(){
        sellerSection.isHidden = false
        shipSection.isHidden = false
        returnSection.isHidden = false
        
        storeName.isHidden = false
        feedbackScore.isHidden = false
        popularity.isHidden = false
        feedbackStar.isHidden = false
        
        shipCost.isHidden = false
        globalShip.isHidden = false
        handle.isHidden = false
        
        policy.isHidden = false
        refundMode.isHidden = false
        returnWithin.isHidden = false
        paidBy.isHidden = false
    }
    
    func showSeller(){
        
        let seller = input[0]["seller"]
        
        if (seller.count == 0){
            sellerSection.isHidden = true
        }
        
        if seller["storeName"].rawString() != "null"{
            let yourAttributes : [NSAttributedString.Key: Any] = [
                NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17),
                NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue]
            
            let attributeString = NSMutableAttributedString(string: seller["storeName"].rawString()!, attributes: yourAttributes)
            
            storeBtn.setAttributedTitle(attributeString, for: .normal)
            //storeBtn.setTitle(seller["storeName"].rawString(), for: UIControl.State.normal)
            
        }
        else{
            storeName.isHidden = true
        }
        
        if seller["feedbackScore"].rawString() != "null"{
            feedbackScoreLab.text = seller["feedbackScore"].rawString()
        }
        else{
            feedbackScore.isHidden = true
        }
        
        if seller["popularity"].rawString() != "null"{
            popularityLab.text = seller["popularity"].rawString()
        }
        else{
            popularity.isHidden = true
        }
        
        if seller["star"].rawString() != "null"{
            let icon = seller["starIcon"].rawString()
            let color = seller["starColor"].rawString()
            feedbackStarImg.image = UIImage(named: icon!)!.withRenderingMode(.alwaysTemplate)
            
            if(color == "Red" || color == "red"){
                feedbackStarImg.tintColor = UIColor.red
            }
            if(color == "Green" || color == "green"){
                feedbackStarImg.tintColor = UIColor.green
            }
            if(color == "Blue" || color == "blue"){
                feedbackStarImg.tintColor = UIColor.blue
            }
            if(color == "Yellow" || color == "yellow"){
                feedbackStarImg.tintColor = UIColor.yellow
            }
            if(color == "Purple" || color == "purple"){
                feedbackStarImg.tintColor = UIColor.purple
            }
            if(color == "Turquoise" || color == "turquoise"){
                feedbackStarImg.tintColor = #colorLiteral(red: 0, green: 0.9914394021, blue: 1, alpha: 1)
            }
            if(color == "silver" || color == "Sliver"){
                feedbackStarImg.tintColor = #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)
            }
        }
        else{
            feedbackStar.isHidden = true
        }
    }
    
    func showShip(){
        let ship = input[0]["shipping"]
        
        if(ship.count == 0){
            shipSection.isHidden = true
        }
        
        if ship["shipCost"].rawString() != "null" {
            shipCostLab.text = ship["shipCost"].rawString()
        }
        else{
            shipCost.isHidden = true
        }
        
        if ship["global"].rawString() != "null"{
            globalShipLab.text = ship["global"].rawString()
        }
        else{
            globalShip.isHidden = true
        }
        
        if ship["handle"].rawString() != "null"{
            handleLab.text = ship["handle"].rawString()
        }
        else{
            handle.isHidden = true
        }
    }
    
    func showReturn(){
        let ret = input[0]["return"]
        
        if(ret.count == 0){
            returnSection.isHidden = true
        }
        
        if ret["policy"].rawString() != "null"{
            policyLab.text = ret["policy"].rawString()
        }
        else{
            policy.isHidden = true
        }
        
        if ret["refund"].rawString() != "null"{
            refundModeLab.text = ret["refund"].rawString()
        }
        else{
            refundMode.isHidden = true
        }
        
        if ret["returnWithin"].rawString() != "null"{
            returnWithinLab.text = ret["returnWithin"].rawString()
        }
        else{
            returnWithin.isHidden = true
        }
        
        if ret["paidBy"].rawString() != "null"{
            paidByLab.text = ret["paidBy"].rawString()
        }
        else{
            paidBy.isHidden = true
        }
    }
    
    //MARK: actions
    
    @IBAction func linkToWebsite(_ sender: Any) {
        if input[0]["seller"]["storeUrl"].rawString() != "null"{
            let siteUrl = input[0]["seller"]["storeUrl"].rawString()
            if let url = NSURL(string: siteUrl!){
                UIApplication.shared.openURL(url as URL)
            }
        }
    }
    
}
