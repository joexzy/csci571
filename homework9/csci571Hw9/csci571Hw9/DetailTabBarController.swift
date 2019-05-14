//
//  DetailTabBarController.swift
//  csci571Hw9
//
//  Created by 徐子祎 on 4/22/19.
//  Copyright © 2019 cs571. All rights reserved.
//

import UIKit
import SwiftyJSON
import SwiftSpinner
import Toast_Swift
import Alamofire

class DetailTabBarController: UITabBarController{
    
    private var fb = UIBarButtonItem()
    private var addWish = UIBarButtonItem()
    private var inWishList = false
    var result = JSON()
    
    private var infoLoaded = false
    private var shipLoaded = false
    private var photoLoaded = false
    private var similarLoaded = false
    
    override func viewWillAppear(_ animated: Bool) {
        testBtn()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passInfo()
        fb = UIBarButtonItem(image: UIImage(named: "facebook"), style: .plain, target: self, action: #selector(fbShare))
        addWish = UIBarButtonItem(image: UIImage(named: "wishListEmpty"), style: .plain, target: self, action: #selector(pressWish))
        self.navigationItem.rightBarButtonItems = [addWish, fb]
    }
    
    @objc func fbShare(){
        let ebayUrl = result["itemUrl"].rawString()!
        if(ebayUrl == "NA"){
            return
        }
        var tag = "&hashtag=#CSCI571Spring2019Ebay"
        tag = tag.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let thing = result["title"].rawString()!
        let price = result["price"].rawString()!
        var quote = "&quote=Buy " + thing + " for " + price + " from Ebay!"
        quote = quote.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let fbUrl = "https://www.facebook.com/sharer/sharer.php?u=" + ebayUrl + quote + tag
        if let url = NSURL(string: fbUrl){
            UIApplication.shared.openURL(url as URL)
        }
    }
    
    @objc func pressWish(){
        inWishList = !inWishList
        
        let id = result["itemId"].rawString()!
        let name = result["title"].rawString()!
        
        let defaultStand = UserDefaults.standard
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(result){
            defaultStand.set(encoded, forKey: id)
        }
        
        if(inWishList){
            addWish.image = UIImage(named: "wishListFilled")
            if var ids = defaultStand.object(forKey: "Ids") as? [String]{
                if(!ids.contains(id)){
                    ids.append(id)
                    let message = name + " was added to the wishList"
                    self.view.window?.makeToast(message)
                }
                defaultStand.set(ids, forKey: "Ids")
            }
            else{
                let ids = [id]
                defaultStand.set(ids, forKey:"Ids")
                let message = name + " was added to the wishList"
                self.view.window?.makeToast(message)
            }
        }
        else{
            addWish.image = UIImage(named: "wishListEmpty")
            if var ids = defaultStand.object(forKey: "Ids") as? [String]{
                if(ids.contains(id)){
                    print(ids)
                    if let index = ids.index(of: id) {
                        ids.remove(at: index)
                        print(ids)
                        let message = name + " was removed from wishList"
                        self.view.window?.makeToast(message)
                        defaultStand.set(ids, forKey: "Ids")
                    }
                }
            }
            else{
                return
            }
        }
    }
    
    func passInfo(){
        if(infoLoaded){
            return
        }
        infoLoaded = true
        SwiftSpinner.show("Fetching Product Details...")
        let id = result["itemId"].rawString()!
        let para = "id=" + id
        let url = "http://csci571-nodejs-xzy.us-west-1.elasticbeanstalk.com/info?" + para
        
        Alamofire.request(url).responseJSON {response in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                let vc = self.viewControllers![0] as! ProductInfoViewController
                vc.input = json
                vc.showTab()
            case .failure:
                print(response.result.error!)
            }
        }
    }
    
    func passShip(){
        if(shipLoaded){
            return
        }
        shipLoaded = true
        SwiftSpinner.show("Fetching Shipping Data...")
        let id = result["itemId"].rawString()!
        var ship = result["shipping"].rawString()!
        if(ship == "FREE SHIPPING"){
            ship = "FREE"
        }
        let para = "id=" + id + "&ship=" + ship
        let url = "http://csci571-nodejs-xzy.us-west-1.elasticbeanstalk.com/shipping?" + para
        
        Alamofire.request(url).responseJSON {response in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                let vc = self.viewControllers![1] as! ShippingViewController
                vc.input = json
                vc.showTab()
            case .failure:
                print(response.result.error!)
            }
        }
    }
    
    func passPhoto(){
        if(photoLoaded){
            return
        }
        photoLoaded = true
        SwiftSpinner.show("Fetching Google Images...")
        var title = result["title"].rawString()!
        title = title.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let para = "title=" + title
        let url = "http://csci571-nodejs-xzy.us-west-1.elasticbeanstalk.com/photos?" + para
        
        Alamofire.request(url).responseJSON {response in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                let vc = self.viewControllers![2] as! PhotoViewController
                vc.input = json
                vc.showTab()
            case .failure:
                print(response.result.error!)
            }
        }
    }
    
    func passSimiler(){
        if(similarLoaded){
            return
        }
        similarLoaded = true
        SwiftSpinner.show("Fetching Similar Items...")
        let id = result["itemId"].rawString()!
        let para = "id=" + id
        let url = "http://csci571-nodejs-xzy.us-west-1.elasticbeanstalk.com/similar?" + para
        
        Alamofire.request(url).responseJSON {response in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                let vc = self.viewControllers![3] as! SimilarViewController
                
                vc.rowData = json
                vc.showTab()
            case .failure:
                print(response.result.error!)
            }
        }
    }

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let itemTitle = tabBar.selectedItem!.title!
        if(itemTitle == "Shipping"){
            passShip()
        }
        if(itemTitle == "Photos"){
            passPhoto()
        }
        if(itemTitle == "Similar"){
            passSimiler()
        }
    }
    
    func testBtn(){
        let id = result["itemId"].rawString()!
        let defaultStand = UserDefaults.standard
        if defaultStand.array(forKey: "Ids") != nil{
            let ids = defaultStand.array(forKey: "Ids") as! [String]
            if ids.contains(id){
                inWishList = true
                addWish.image = UIImage(named: "wishListFilled")
            }
        }
    }


    
 
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
