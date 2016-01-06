//
//  filterView.swift
//  Skandiacup
//
//  Created by Jørgen Wilhelmsen on 24/09/15.
//  Copyright © 2015 Spline Development. All rights reserved.
//

import UIKit

class filterView: UIView{
    @IBOutlet var viewGUI: filterView!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var sexTextField: UITextField!
    var sexPicker: UIPickerView!
    var countryPicker: UIPickerView!
    @IBOutlet weak var countryLabel: UILabel!
    
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
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
        countryLabel.text = SharingManager.locale.countryLabel
        genderLabel.text = SharingManager.locale.genderLabel
        searchTextField.text = SharingManager.locale.searchBoxPlaceholder
        searchTextField.textColor = UIColor.grayColor()
        searchTextField.clearButtonMode = UITextFieldViewMode.WhileEditing
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
        searchTextField.delegate = vc
        sexTextField.inputView = sexPicker
        countryTextField.inputView = countryPicker
        sexTextField.text = SharingManager.locale.all
        countryTextField.text = SharingManager.locale.all
    }
}