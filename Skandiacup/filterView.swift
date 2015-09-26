//
//  filterView.swift
//  Skandiacup
//
//  Created by Jørgen Wilhelmsen on 24/09/15.
//  Copyright © 2015 Spline Development. All rights reserved.
//

import UIKit

class filterView: UIView{
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet var viewGUI: filterView!
//    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var ageSlider: UISlider!
    @IBOutlet weak var sexTextField: UITextField!
    var sexPicker: UIPickerView!
    var countryPicker: UIPickerView!
    
    
//    init(_ coder: NSCoder? = nil) {
//        if let coder = coder {
//            super.init(coder: coder)!
//        } else {
//            super.init()
//        }
//    }
//    
//    required init(coder aDecoder: NSCoder) {
//        self.init(aDecoder)
////        super.init(coder: aDecoder)
//        NSBundle.mainBundle().loadNibNamed("filterView", owner: self, options: nil)
//        self.addSubview(viewGUI)
//    }
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        NSBundle.mainBundle().loadNibNamed("filterView", owner: self, options: nil)
//        self.addSubview(viewGUI)
//    }
//    
//    override init (frame : CGRect) {
//        super.init(frame : frame)
//        NSBundle.mainBundle().loadNibNamed("filterView", owner: self, options: nil)
//
////        addBehavior()
//    }
//    
//    convenience init () {
//        self.init(frame:CGRectZero)
//        NSBundle.mainBundle().loadNibNamed("filterView", owner: self, options: nil)
//    }
//    
//    required convenience init(coder aDecoder: NSCoder) {
//        self.init()
//        NSBundle.mainBundle().loadNibNamed("filterView", owner: self, options: nil)
////        fatalError("This class does not support NSCoding")
//    }
//   
    
    override init(frame: CGRect) { // for using CustomView in code
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init(coder aDecoder: NSCoder) { // for using CustomView in IB
        super.init(coder: aDecoder)!
        self.commonInit()
    }
    
    private func commonInit() {
        NSBundle.mainBundle().loadNibNamed("filterView", owner: self, options: nil)
        viewGUI.frame = self.bounds
//        viewGUI.autoresizingMask = .FlexibleHeight | .FlexibleWidth
        self.addSubview(viewGUI)
    }
    @IBAction func ageSliderValueChanged(sender: UISlider) {
        ageLabel.text = "\(Int(sender.value))"
    }
    
    func setupDelegates(vc: TeamsViewController){
//        self.searchBar.delegate = vc
        sexPicker = UIPickerView()
        sexPicker.accessibilityIdentifier = "sexPicker"
        countryPicker = UIPickerView()
        countryPicker.accessibilityIdentifier = "countryPicker"
        sexPicker.dataSource = vc
        sexPicker.delegate = vc
        sexTextField.delegate = vc
        countryPicker.dataSource = vc
        countryPicker.delegate = vc
        countryTextField.delegate = vc
        sexTextField.inputView = sexPicker
        countryTextField.inputView = countryPicker
    }
    
//    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        searchBar.endEditing(true)
//    }
}