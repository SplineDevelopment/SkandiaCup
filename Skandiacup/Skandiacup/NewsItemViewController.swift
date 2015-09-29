//
//  NewsItemViewController.swift
//  Skandiacup
//
//  Created by Jørgen Wilhelmsen on 29/09/15.
//  Copyright © 2015 Spline Development. All rights reserved.
//

import UIKit

class NewsItemViewController: UIViewController {
    var currentItem: RSSItem? {
        didSet{
            configureView()
        }
    }

    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func configureView(){
        if let item = self.currentItem{
            if let view = self.webView{
                print("Images: \(item.imagesFromContent)")
                print("Images: \(item.imagesFromItemDescription)")
                
                view.loadRequest(NSURLRequest(URL: item.link!))
//                view.loadHTMLString("\(item.link!)", baseURL: nil)
            }
        }
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}