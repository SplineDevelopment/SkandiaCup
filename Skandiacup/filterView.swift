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
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var ageSlider: UISlider!
    @IBOutlet weak var sexTextField: UITextField!
    var sexPicker: UIPickerView!
    var countryPicker: UIPickerView!
    
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
        self.addSubview(viewGUI)
    }
    @IBAction func ageSliderValueChanged(sender: UISlider) {
        ageLabel.text = "\(Int(sender.value))"
    }
    
    func setupDelegates(vc: TeamsViewController){
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
        ageLabel.text = "\(Int(ageSlider.value))"
        sexTextField.text = "Alle"
        countryTextField.text = "Alle"
    }
}