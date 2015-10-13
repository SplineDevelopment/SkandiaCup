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
                var htmlstring = item.itemDescription!
//                let headerstring = item.title!
                
//                print(headerstring)
//                htmlstring = headerstring + htmlstring
                let bodytext: NSAttributedString
                
                do{
                    bodytext =  try NSAttributedString(data: htmlstring.dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: true)!, options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
                    
                    self.headerLabel.text = item.title!
                    bodytextview.attributedText = bodytext
                    bodytextview.font = UIFont (name: "Helvetica Neue", size: 12)
//                    bodytextview.textColor = UIColor.lightGrayColor()
                } catch _ as NSError{
                }
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
