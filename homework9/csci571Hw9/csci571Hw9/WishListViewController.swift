//
//  WishListViewController.swift
//  csci571Hw9
//
//  Created by 徐子祎 on 4/25/19.
//  Copyright © 2019 cs571. All rights reserved.
//

import UIKit
import SwiftyJSON
import SwiftSpinner
import Toast_Swift
import Alamofire

class WishListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    @IBOutlet weak var wishTable: UITableView!
    
    @IBOutlet weak var noItem: UIView!
    @IBOutlet weak var hasItem: UIView!
    @IBOutlet weak var sumprice: UILabel!
    @IBOutlet weak var sumCount: UILabel!
    
    
    
    var dataArr = Array<JSON>()
    var num = Int()
    override func viewDidLoad() {
        wishTable.delegate = self
        wishTable.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        readData()
        wishTable.reloadData()
        testHearder()
        getText()
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func readData(){
        dataArr.removeAll()
        let defaultStand = UserDefaults.standard
        if defaultStand.array(forKey: "Ids") != nil{
            let ids = defaultStand.array(forKey: "Ids") as! [String]
            for id in ids{
                if let dataFrom = defaultStand.object(forKey: id) as? Data {
                    let decoder = JSONDecoder()
                    if let data = try? decoder.decode(JSON.self, from: dataFrom) {
                    dataArr.append(data)
                    }
                }
            }
        }
    }
    
    func clearDefaults(){
        let userDefaults = UserDefaults.standard
        let dics = userDefaults.dictionaryRepresentation()
        for key in dics.keys {
            userDefaults.removeObject(forKey: key)
        }
        userDefaults.synchronize()
    }

    
    //code for wishtable
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "wishCell", for: indexPath) as! WishListTableViewCell
        cell.itemName.text = dataArr[indexPath.row]["title"].rawString()!
        cell.price.text = dataArr[indexPath.row]["price"].rawString()!
        cell.ship.text = dataArr[indexPath.row]["shipping"].rawString()!
        cell.zipcode.text = dataArr[indexPath.row]["zipcode"].rawString()!
        cell.condition.text = dataArr[indexPath.row]["condition"].rawString()!
        let imageUrl = dataArr[indexPath.row]["imgUrl"].rawString()!
        let imgUrl = URL(string: imageUrl)
        let data = try? Data(contentsOf: imgUrl!)
        if let imageData = data{
            cell.img.image = UIImage(data: imageData)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        num = indexPath.row
        self.performSegue(withIdentifier: "showDetail2", sender: nil)

    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let id = dataArr[indexPath.row]["itemId"].rawString()!
            let name = dataArr[indexPath.row]["title"].rawString()!
            dataArr.remove(at: indexPath.row)
            wishTable.deleteRows(at: [indexPath], with: .fade)
            
            let message = name + " was removed from wishList"
            self.view.window?.makeToast(message)
            
            let defaultStand = UserDefaults.standard
            
            if var ids = defaultStand.object(forKey: "Ids") as? [String]{
                if(ids.contains(id)){
                    if let index = ids.index(of: id) {
                        ids.remove(at: index)
                        defaultStand.set(ids, forKey: "Ids")
                        
                    }
                }
            }
        }
        else if editingStyle == .insert{
        }
        getText()
        testHearder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? DetailTabBarController {
            controller.result = self.dataArr[num]
        }
    }
    
    func testHearder(){
        if(dataArr.count == 0){
            noItem.isHidden = false
            hasItem.isHidden = true
            wishTable.isHidden = true
        }
        else{
            noItem.isHidden = true
            hasItem.isHidden = false
            wishTable.isHidden = false
        }
    }
    
    func getText(){
        var sum = 0.00
        let count = dataArr.count
        if(count == 1){
            sumCount.text = "WishList Total(\(count) item):"
        }
        else if(count > 1){
            sumCount.text = "WishList Total(\(count) items):"
        }
        if(count > 0){
            for item in dataArr{
                let temp = item["price"].rawString()!
                let start = temp.index(temp.startIndex, offsetBy: 1)
                let substr = temp[start...]
                let price = Double(String(substr))
                sum = sum + price!
            }
            sumprice.text = "$" + String(sum)
        }
    }
    
    
    
    
    
    
    
    
}
