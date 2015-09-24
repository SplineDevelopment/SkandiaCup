//
//  filterView.swift
//  Skandiacup
//
//  Created by Jørgen Wilhelmsen on 24/09/15.
//  Copyright © 2015 Spline Development. All rights reserved.
//

import UIKit

class filterView: UIView, UISearchBarDelegate{
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet var viewGUI: filterView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var ageSlider: UISlider!
    @IBOutlet weak var sexTextField: UITextField!
    var sexPicker: UIPickerView!
    var countryPicker: UIPickerView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        NSBundle.mainBundle().loadNibNamed("filterView", owner: self, options: nil)
        self.addSubview(viewGUI)
    }
    
    @IBAction func ageSliderValueChanged(sender: UISlider) {
        ageLabel.text = "\(Int(sender.value))"
    }
    
    func setupDelegates(vc: TeamsViewController){
        self.searchBar.delegate = vc
        sexPicker = UIPickerView()
        sexPicker.restorationIdentifier = "sexPicker"
        countryPicker = UIPickerView()
        countryPicker.restorationIdentifier = "countryPicker"
        sexPicker.dataSource = vc
        sexPicker.delegate = vc
        sexTextField.delegate = vc
        countryPicker.dataSource = vc
        countryPicker.delegate = vc
        countryTextField.delegate = vc
        sexTextField.inputView = sexPicker
        countryTextField.inputView = countryPicker
    }
}
