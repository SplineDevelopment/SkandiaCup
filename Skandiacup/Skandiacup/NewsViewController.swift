//
//  NewsViewController.swift
//  Skandiacup
//
//  Created by Jørgen Wilhelmsen on 31/08/15.
//  Copyright © 2015 Spline Development. All rights reserved.
//

import UIKit

class NewsViewController: UIViewController, NSXMLParserDelegate {
    @IBOutlet weak var textBox: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func btnPressed(sender: AnyObject) {
        print(Date.getCurrentTimeInSoapFormat()+"\n")
        
        
        print(SharingManager.soap.getArena([1,2,3,10]))
        
        let soapMessage = "<soapenv:Envelope xmlns:soapenv='http://schemas.xmlsoap.org/soap/envelope/' xmlns:for='http://profixio.com/soap/tournament/ForTournamentExt.php'><soapenv:Header/><soapenv:Body><for:getTournamentMatchStatus><application_key>demo2015uefa</application_key><tournamentID>11</tournamentID><since>2015-09-03 09:00:00</since></for:getTournamentMatchStatus></soapenv:Body></soapenv:Envelope>"
        
//        let soapMessage2 = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><CelsiusToFahrenheit xmlns='http://www.w3schools.com/webservices/'><Celsius>10</Celsius></CelsiusToFahrenheit></soap:Body></soap:Envelope>"
        
        let request = NSMutableURLRequest(URL: NSURL(string: "http://profixio.com/soap/tournament/ForTournamentExt.php")!)
//        let request = NSMutableURLRequest(URL: NSURL(string: "http://www.w3schools.com/webservices/tempconvert.asmx")!)
        request.HTTPMethod = "POST"

        request.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue(String(soapMessage.characters.count), forHTTPHeaderField: "Content-Length")

        let postString = soapMessage
        var testString: AnyObject?
        
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil {
                print("error=\(error)")
                return
            }
            
            print("response = \(response)")
            
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
//            testString = NSString(data: data!, encoding: NSUTF8StringEncoding)
//            print("responseString = \(responseString)")
            let data = (responseString! as! NSString).dataUsingEncoding(NSUTF8StringEncoding)
            let xmlparser = NSXMLParser(data: data!)
            xmlparser.delegate = self
            xmlparser.parse()
        }
        task.resume()
        
//      let xmlstring = "<hei v='asdasd'>a</hei>"

//        let data = (testString! as! NSString).dataUsingEncoding(NSUTF8StringEncoding)
//        let xmlparser = NSXMLParser(data: data!)
//        xmlparser.delegate = self
//        xmlparser.parse()
    }

    func parser(parser: NSXMLParser,didStartElement elementName: String, namespaceURI: String?,
        qualifiedName qName: String?,attributes attributeDict: [String : String])
    {
        print("Element's name is \(elementName)")
//        print("Element's attributes are \(attributeDict)")
//        print("Element name is \(qName)")
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        print("Elements value is \(string)")
        print("\n\n")
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
