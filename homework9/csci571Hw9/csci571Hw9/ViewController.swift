//
//  ViewController.swift
//  csci571Hw9
//
//  Created by 徐子祎 on 4/15/19.
//  Copyright © 2019 cs571. All rights reserved.
//

import UIKit
import McPicker
import Toast_Swift
import SwiftSpinner
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate{

    //MARK: Properties
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var locationSwitch: UISwitch!
    @IBOutlet weak var zipcode: UITextField!
    @IBOutlet weak var keywordTextField: UITextField!
    @IBOutlet weak var autocomplete: UITableView!
    
    @IBOutlet weak var distance: UITextField!
    
    @IBOutlet weak var mcTextField: McTextField!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var clearBtn: UIButton!
    
    @IBOutlet weak var wishListView: UIView!
    
    @IBOutlet weak var newbtn: CheckBox!
    @IBOutlet weak var usedBtn: CheckBox!
    @IBOutlet weak var unspecBtn: CheckBox!
    @IBOutlet weak var pickBtn: CheckBox!
    @IBOutlet weak var freeShipBtn: CheckBox!
    
    
    private var zipArr: [String] = Array()
    private var curLoc: String = ""
    private var input = JSON()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationSwitch.isOn = false;
        zipcode.text = ""
        zipcode.isHidden = true
        
        currentLocation(){(data) in
            self.curLoc = data
        }
        
        autocomplete.delegate = self
        autocomplete.dataSource = self
        zipcode.delegate = self
        
        zipcode.addTarget(self, action: #selector(acChanged(_:)), for: .editingChanged)
        
        self.autocomplete.register(UITableViewCell.self, forCellReuseIdentifier: "acView")
        autocomplete.layer.cornerRadius = 8
        autocomplete.layer.borderWidth = 2
        autocomplete.layer.borderColor = #colorLiteral(red: 0.7058121562, green: 0.7059181929, blue: 0.7057976127, alpha: 1)
        
        wishListView.isHidden = true
        autocomplete.isHidden = true
        
        let data: [[String]] = [["All", "Art", "Baby", "Books", "Clothing, Shoes & Accessories", "Computers/Tablets & Networking", "Health & Beauty", "Music", "Video Games & Consoles"]]
        let mcInputView = McPicker(data: data)
        mcTextField.inputViewMcPicker = mcInputView
        mcTextField.text = "All"
        mcTextField.doneHandler = { [weak mcTextField] (selections) in mcTextField?.text = selections[0]!
            //do somethin if user selects an option and taps done
        }
        
        mcTextField.cancelHandler = { [weak mcTextField] in
            //do something if user cancels
        }
        
        let item = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = item
        
        searchBtn.layer.cornerRadius = 5
        clearBtn.layer.cornerRadius = 5
        
    }
    
    //MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        zipcode.resignFirstResponder()
        return true
    }
    /**
    func textFieldDidEndEditing(_ textField: UITextField) {
    }
 */
    
    //MARK: Value Passing
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? SearchResultTableViewController {
            controller.inputData = self.input
        }
    }
    
    //MARK: Actions
    @IBAction func indexChange(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
            wishListView.isHidden = true
        case 1:
            wishListView.isHidden = false
        default:
            break
        }
    }
    
    @IBAction func zipcodeSwitch(_ sender: UISwitch) {
        if(locationSwitch.isOn){
            zipcode.isHidden = false
        }
        else{
            zipcode.isHidden = true
            autocomplete.isHidden = true
        }
    }
    
    @IBAction func pressSearch(_ sender: Any) {
        if(validation()){
            SwiftSpinner.show("Searching...")
            getResults()
            //performSegue(withIdentifier: "showSearchResult", sender: nil)
            //next step
        }
        else{
            //modify the search input
        }
    }
    
    @IBAction func pressClear(_ sender: Any) {
        locationSwitch.isOn = false;
        zipcode.text = ""
        zipcode.isHidden = true
        keywordTextField.text = ""
        autocomplete.isHidden = true
        distance.text = ""
        mcTextField.text = "All"
        newbtn.isChecked = false
        usedBtn.isChecked = false
        unspecBtn.isChecked = false
        pickBtn.isChecked = false
        freeShipBtn.isChecked = false
    }
    
    
    //code for autocomplete tableview
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return zipArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "acView", for: indexPath)
        cell.textLabel?.text = zipArr[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        zipcode.text = zipArr[indexPath.row]
        self.autocomplete.isHidden = true
    }
 
    
    
    
    //MARK: Help Funs
    func validation() -> Bool{
        if(locationSwitch.isOn){
            let temp = keywordTextField.text;
            let temp_handle = temp?.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
            let temp2 = zipcode.text
            let temp2_handle = temp2?.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
            
            if(temp_handle == "" && temp2_handle == ""){
                self.view.makeToast("Keyword and Zipcode are Mandatory")
                return false
            }
            else if(temp_handle == ""){
                self.view.makeToast("Keyword is Mandatory")
                return false
            }
            else if(temp2_handle == ""){
                self.view.makeToast("Zipcode is Mandatory")
                return false
            }
        }
        else{
            let temp = keywordTextField.text;
            let temp_handle = temp?.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
            if(temp_handle == ""){
                self.view.makeToast("Keyword is Mandatory")
                return false
            }
        }
        return true
    }
    
    /**
    func zipAc(){
        let zipcode = "9000"
        Alamofire.request("http://csci571-nodejs-xzy.us-west-1.elasticbeanstalk.com/geoname?pos=\(zipcode)").responseJSON {response in
            if(response.result.isSuccess){
                let json = JSON(response.result.value!)["postalCodes"]
                print(json)
                for x in json{
                    let pos = x.1["postalCode"]
                    self.zipArr.append(pos.rawString()!)
                    print(pos)
                    self.autocomplete.reloadData()
                }
            }
            else{
                print(response.result.error!)
            }

        }
    }
 */
    
    //update the autucomplete
    @objc func acChanged(_ textfield: UITextField){
        zipArr.removeAll()
        if(textfield.text == ""){
            self.autocomplete.isHidden = true
            return
        }
        
        let urlZip = textfield.text!
        
        Alamofire.request("http://csci571-nodejs-xzy.us-west-1.elasticbeanstalk.com/geoname?pos=\(urlZip)").responseJSON {response in
            if(response.result.isSuccess){
                //print("success")
                let json = JSON(response.result.value!)["postalCodes"]
                if(json.count == 0){
                    self.autocomplete.isHidden = true
                    return
                }
                //print(json)
                for x in json{
                    let pos = x.1["postalCode"]
                    self.zipArr.append(pos.rawString()!)
                    //print(pos)
                    self.autocomplete.reloadData()
                    self.autocomplete.isHidden = false
                }
                //print("success")
                //self.autocomplete.reloadData()
            }
            else{
                print(response.result.error!)
            }
        }
    }
    
    func currentLocation(completionHandler: @escaping (String) -> ()){
        var loc = String()
        Alamofire.request("http://ip-api.com/json").responseJSON {response in
            switch response.result {
            case .success:
                //print("success")
                let json = JSON(response.result.value!)["zip"].rawString()!
                loc = json
                completionHandler((loc as? String)!)
            case .failure:
                print(response.result.error!)
            }
        }
    }
    
    func getPara() -> String{
        var keyword = self.keywordTextField.text!
        keyword = keyword.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        var category = self.mcTextField.text!
        category = category.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        var para = "keyword=\(keyword)&category=\(category)&newCon="
        var distance = "10"
        if(newbtn.isChecked){
            para += "true"
        }
        else{
            para += "false"
        }
        para += "&used="
        if(usedBtn.isChecked){
            para += "true"
        }
        else{
            para += "false"
        }
        para += "&unspecified="
        if(unspecBtn.isChecked){
            para += "true"
        }
        else{
            para += "false"
        }
        para += "&localPick="
        if(pickBtn.isChecked){
            para += "true"
        }
        else{
            para += "false"
        }
        para += "&freeShip="
        if(freeShipBtn.isChecked){
            para += "true"
        }
        else{
            para += "false"
        }
        
        if(self.distance.text != ""){
            distance = self.distance.text!
        }
        para += "&distance=\(distance)"
        
        para += "&zipcode="
        if(locationSwitch.isOn){
            para += self.zipcode.text!
        }
        else{
            para += self.curLoc
        }
        
        return para
    }
    
    func getResults(){
        let para = getPara()
        let url = "http://csci571-nodejs-xzy.us-west-1.elasticbeanstalk.com/ebayFinding?" + para
        Alamofire.request(url).responseJSON {response in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                self.input = json
                self.performSegue(withIdentifier: "showSearchResult", sender: nil)
            case .failure:
                print(response.result.error!)
            }
        }
        
    }
    
    
    
    
    
}



