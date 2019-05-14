//
//  SearchResultTableViewController.swift
//  csci571Hw9
//
//  Created by 徐子祎 on 4/21/19.
//  Copyright © 2019 cs571. All rights reserved.
//

import UIKit
import SwiftSpinner
import SwiftyJSON
import Toast_Swift

class SearchResultTableViewController: UITableViewController, SearchResultTableViewCellDelegate{
        
    
    var inputData = JSON()
    private var row = Int()
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
        //print (inputData)
        //SwiftSpinner.show("Searching...")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        SwiftSpinner.hide()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Search Results"
        
        let item = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = item
        testAlert()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inputData.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell", for: indexPath) as! SearchResultTableViewCell
        cell.titleField.text = inputData[indexPath.row]["title"].rawString()!
        cell.price.text = inputData[indexPath.row]["price"].rawString()!
        cell.ship.text = inputData[indexPath.row]["shipping"].rawString()!
        cell.zipcode.text = inputData[indexPath.row]["zipcode"].rawString()!
        cell.condition.text = inputData[indexPath.row]["condition"].rawString()!
        let imageUrl = inputData[indexPath.row]["imgUrl"].rawString()!
        let imgUrl = URL(string: imageUrl)
        let data = try? Data(contentsOf: imgUrl!)
        if let imageData = data{
            cell.imageField.image = UIImage(data: imageData)
        }
        cell.delegateCell = self
        
        let cellId = inputData[indexPath.row]["itemId"].rawString()!
        
        let defaultStand = UserDefaults.standard
        
        if defaultStand.array(forKey: "Ids") != nil{
            let ids = defaultStand.array(forKey: "Ids") as! [String]
            if ids.contains(cellId){
                cell.inWish = true
                cell.wishBtn.isChecked = true
            }
            else{
                cell.inWish = false
                cell.wishBtn.isChecked = false
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        row = indexPath.row
        self.performSegue(withIdentifier: "showDetail", sender: nil)
    }
    
    func testAlert(){
        let count = inputData.count
        
        if(count == 0){
            let alert = UIAlertController(title: "No Results!", message: "Failed to fetch search results", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {action in
                self.navigationController?.popViewController(animated: true)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? DetailTabBarController {
            controller.result = self.inputData[row]
        }
    }

    func didTapBtn(cell: SearchResultTableViewCell){
        if let indexPath = tableView.indexPath(for: cell) {
            //print("User did tap cell with index: \(indexPath.row)")
            let id = inputData[indexPath.row]["itemId"].rawString()!
            let item = inputData[indexPath.row]
            let name = inputData[indexPath.row]["title"].rawString()!
            let defaultStand = UserDefaults.standard
            
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(item){
                defaultStand.set(encoded, forKey: id)
            }
            
            if(cell.inWish == true){
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
    }
    
    
    
}
