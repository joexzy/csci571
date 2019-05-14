//
//  SimilarViewController.swift
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

class SimilarViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    @IBOutlet weak var sortBy: UISegmentedControl!
    @IBOutlet weak var order: UISegmentedControl!
    @IBOutlet weak var collection: UICollectionView!
    
    
    
    var rowData = JSON()
    var row = Array<JSON>()
    var orderArr = Array<JSON>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collection.delegate = self
        collection.dataSource = self
        
        if(sortBy.selectedSegmentIndex == 0){
            order.isUserInteractionEnabled = false
        }
        // Do any additional setup after loading the view.
    }
    

    func showTab(){
        row = rowData.arrayValue
        orderArr = row
        collection.reloadData()
        SwiftSpinner.hide()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    //code for collectionview
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return orderArr.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "similarCell", for: indexPath) as! SimilarCollectionViewCell
        cell.name.text = orderArr[indexPath.row]["name"].rawString()!
        cell.ship.text = "$" + orderArr[indexPath.row]["ship"].rawString()!
        
        cell.left.text = orderArr[indexPath.row]["left"].rawString()!
        if(cell.left.text == "0" || cell.left.text == "1"){
            cell.left.text = cell.left.text! + " Day Left"
        }
        else{
            cell.left.text = cell.left.text! + " Days Left"
        }
            
        cell.price.text = "$" + orderArr[indexPath.row]["price"].rawString()!
        
        let imageUrl = orderArr[indexPath.row]["imgUrl"].rawString()!
        let imgUrl = URL(string: imageUrl)
        let data = try? Data(contentsOf: imgUrl!)
        if let imageData = data{
            cell.image.image = UIImage(data: imageData)
        }
        
        cell.layer.cornerRadius = 5
        cell.layer.borderWidth = 1
        cell.layer.borderColor = #colorLiteral(red: 0.7058121562, green: 0.7059181929, blue: 0.7057976127, alpha: 1)
        
        return cell
    }
    
    /**
    func test(){
        let sorted = orderArr.sorted { $0["price"].doubleValue < $1["price"].doubleValue }
        print (sorted)
    }
 */
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let itemUrl = orderArr[indexPath.row]["itemUrl"].rawString()!
        if let url = NSURL(string: itemUrl){
            UIApplication.shared.openURL(url as URL)
        }
    }
    
    //MARK: actions
    @IBAction func pressToSort(_ sender: Any) {
        switch sortBy.selectedSegmentIndex
        {
        case 0:
            order.isUserInteractionEnabled = false
            orderArr = row
        case 1:
            order.isUserInteractionEnabled = true
            if(order.selectedSegmentIndex == 0){
                let sorted = orderArr.sorted { $0["name"].stringValue < $1["name"].stringValue}
                orderArr = sorted
            }
            else if(order.selectedSegmentIndex == 1){
                let sorted = orderArr.sorted { $0["name"].stringValue > $1["name"].stringValue}
                orderArr = sorted
            }
        case 2:
            order.isUserInteractionEnabled = true
            if(order.selectedSegmentIndex == 0){
                let sorted = orderArr.sorted { $0["price"].doubleValue < $1["price"].doubleValue}
                orderArr = sorted
            }
            else if(order.selectedSegmentIndex == 1){
                let sorted = orderArr.sorted { $0["price"].doubleValue > $1["price"].doubleValue}
                orderArr = sorted
            }
        case 3:
            order.isUserInteractionEnabled = true
            if(order.selectedSegmentIndex == 0){
                let sorted = orderArr.sorted { $0["left"].doubleValue < $1["left"].doubleValue}
                orderArr = sorted
            }
            else if(order.selectedSegmentIndex == 1){
                let sorted = orderArr.sorted { $0["left"].doubleValue > $1["left"].doubleValue}
                orderArr = sorted
            }
        case 4:
            order.isUserInteractionEnabled = true
            if(order.selectedSegmentIndex == 0){
                let sorted = orderArr.sorted { $0["ship"].doubleValue < $1["ship"].doubleValue}
                orderArr = sorted
            }
            else if(order.selectedSegmentIndex == 1){
                let sorted = orderArr.sorted { $0["ship"].doubleValue > $1["ship"].doubleValue}
                orderArr = sorted
            }
        default:
            break
        }
        collection.reloadData()
    }
    
    
}
