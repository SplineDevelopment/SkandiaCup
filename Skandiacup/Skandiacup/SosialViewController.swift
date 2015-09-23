//
//  SosialViewController.swift
//  Skandiacup
//
//  Created by Bjørn Hoxmark on 04/09/15.
//  Copyright © 2015 Spline Development. All rights reserved.
//

import UIKit

class SosialViewController: UIViewController {

    @IBOutlet weak var testImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func completion(data : NSData) {
        testImage.image = UIImage(data: data)
    }
    
    override func viewDidAppear(animated: Bool) {
        SharingManager.data.getPhotoObject(1) { (photoObject) -> () in
            NSURLSession.sharedSession().dataTaskWithURL(photoObject.url!) { (data, response, error) in
                print(data)
                print(error)
                print(response)
                self.completion(data!)
                }.resume()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
