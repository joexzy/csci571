//
//  ProductInfoViewController.swift
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

class ProductInfoViewController: UIViewController, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var pageCtrlView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var desIcon: UIImageView!
    @IBOutlet weak var desLab: UILabel!
    @IBOutlet weak var desTabView: UITableView!
    
    var input = JSON()
    var frame = CGRect(x:0,y:0,width:0,height:0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageCtrlView.delegate = self
        desTabView.delegate = self
        desTabView.dataSource = self
        
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func showTab(){
        showImage()
        pageControl.currentPage = 0
        
        let name = input[0]["title"].rawString()!
        self.name.text = name
        self.name.numberOfLines = 3
        
        let price = input[0]["price"].rawString()!
        self.price.text = price
        
        let des = input[0]["description"]
        if(des.count == 0){
            desIcon.isHidden = true
            desLab.isHidden = true
            desTabView.isHidden = true
        }
        else{
            desIcon.isHidden = false
            desLab.isHidden = false
            desTabView.isHidden = false
        }
        
        desTabView.reloadData()
        SwiftSpinner.hide()
        
    }
    
    func showImage(){
        let picture = input[0]["pictureURL"]
        let count = picture.count
        pageControl.numberOfPages = count
        pageCtrlView.showsVerticalScrollIndicator = false
        pageCtrlView.showsHorizontalScrollIndicator = false
        
        for index in 0 ..< count{
            frame.origin.x = pageCtrlView.frame.size.width * CGFloat(index)
            frame.size = pageCtrlView.frame.size
            
            let imgView = UIImageView(frame: frame)
            let imageUrl = picture[index].rawString()!
            let imgUrl = URL(string: imageUrl)
            let data = try? Data(contentsOf: imgUrl!)
            if let imageData = data{
                imgView.image = UIImage(data: imageData)
            }
            self.pageCtrlView.addSubview(imgView)
        }
        
        pageCtrlView.contentSize = CGSize(width:(pageCtrlView.frame.size.width * CGFloat(count)), height: pageCtrlView.frame.size.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNum = pageCtrlView.contentOffset.x / pageCtrlView.frame.size.width
        pageControl.currentPage = Int(pageNum)
    }
    
    //for description tableview
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let des = input[0]["description"]
        let count = des.count
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let des = input[0]["description"]
        let cell = tableView.dequeueReusableCell(withIdentifier: "desCell", for: indexPath) as! DescriptionCell
        cell.name.text = des[indexPath.row]["Name"].rawString()!
        cell.value.text = des[indexPath.row]["Value"][0].rawString()!
        return cell
    }
    
    
}
