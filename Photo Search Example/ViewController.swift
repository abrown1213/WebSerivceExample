
//
//  ViewController.swift
//  Calling Instagram
//
//  Created by Kira Godshall on 12/1/15.
//  Copyright © 2015 Kira Godshall. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UISearchBarDelegate {


    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchInstagramByHashtag("ocean")

    }
    
    func searchInstagramByHashtag(searchString:String) {
        let manager = AFHTTPRequestOperationManager()
        manager.GET( "https://api.instagram.com/v1/tags/\(searchString)/media/recent?client_id=5457d1cfece84945afd3c93a3aa48bf6",
            parameters: nil,
            success: { (operation: AFHTTPRequestOperation!,responseObject: AnyObject!) in
                print("JSON: " + responseObject.description)
                if let dataArray = responseObject["data"] as? [AnyObject] {
                    var urlArray:[String] = []
                    for dataObject in dataArray {
                        if let imageURLString = dataObject.valueForKeyPath("images.standard_resolution.url") as? String {
                            urlArray.append(imageURLString)
                        }
                    }
                    let imageWidth = self.view.frame.width
                    self.scrollView.contentSize = CGSizeMake(imageWidth, imageWidth * CGFloat(dataArray.count))
                    
                    for var i = 0; i < urlArray.count; i++ {
                        let imageView = UIImageView(frame: CGRectMake(0, imageWidth*CGFloat(i), imageWidth, imageWidth))
                        imageView.setImageWithURL( NSURL(string: urlArray[i]))
                        self.scrollView.addSubview(imageView)
                    }
                
                }
            },
            failure: { (operation: AFHTTPRequestOperation!,error: NSError!) in
                print("Error: " + error.localizedDescription)
                
        })
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        for subview in self.scrollView.subviews {
            subview.removeFromSuperview()
        }
            searchBar.resignFirstResponder()
            searchInstagramByHashtag(searchBar.text!)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

