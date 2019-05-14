//
//  PhotoViewController.swift
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

class PhotoViewController: UIViewController, UIScrollViewDelegate{
    @IBOutlet weak var photoScroll: UIScrollView!
    
    var input = JSON()
    var frame = CGRect(x:0,y:0,width:0,height:0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoScroll.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func showTab(){
        let picture = input
        let count = picture.count
        
        photoScroll.showsVerticalScrollIndicator = true
        photoScroll.showsHorizontalScrollIndicator = false
        
        for index in 0 ..< count{
            frame.origin.y = photoScroll.frame.size.height * CGFloat(0.75) * CGFloat(index)
            frame.size.width = photoScroll.frame.size.width
            frame.size.height = photoScroll.frame.size.height * CGFloat(0.75)
            
            let imgView = UIImageView(frame: frame)
            let imageUrl = picture[index]["link"].rawString()!
            let imgUrl = URL(string: imageUrl)
            let data = try? Data(contentsOf: imgUrl!)
            if let imageData = data{
                imgView.image = UIImage(data: imageData)
            }
            self.photoScroll.addSubview(imgView)
        }
        //print("loading finished")
        photoScroll.contentSize = CGSize(width: photoScroll.frame.size.width, height: photoScroll.frame.size.height * CGFloat(0.75) * CGFloat(count))
        SwiftSpinner.hide()
    }
}
