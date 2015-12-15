//
//  InfoItemViewController.swift
//  Skandiacup
//
//  Created by Bjørn Hoxmark on 15/12/15.
//  Copyright © 2015 Spline Development. All rights reserved.
//


import UIKit

class InfoItemViewController: UIViewController {
    var currentItem: RSSItem? {
        didSet{
            configureView()
        }
    }
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var headerLabel: UILabel!
    override func viewDidLoad() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
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
            if let bodytextview = self.textView{
                let htmlstring = item.itemDescription!
                //                let headerstring = item.title!
                
                //                print(headerstring)
                //                htmlstring = headerstring + htmlstring
                let bodytext: NSAttributedString
                
                do{
                    bodytext =  try NSAttributedString(data: htmlstring.dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: true)!, options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
                    
                    self.headerLabel.text = item.title!
                    self.headerLabel.font = UIFont(name: "Helvetica Neue", size: 20)
                    bodytextview.attributedText = bodytext
                    bodytextview.font = UIFont (name: "Helvetica Neue", size: 15)
                    //bodytextview.font = UIFont (name: "Adelle sans", size: 20)
                    
                    //                    bodytextview.textColor = UIColor.lightGrayColor()
                } catch _ as NSError{
                }
            }
        }
    }
}