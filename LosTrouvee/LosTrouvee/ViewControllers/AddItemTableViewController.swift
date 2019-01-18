//
//  AddItemTableViewController.swift
//  LosTrouvee
//
//  Created by Jari De Graeve on 26/12/2018.
//  Copyright © 2018 Jari De Graeve. All rights reserved.
//

import UIKit

class AddItemTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource,
UITextViewDelegate{
    
    var isLostItem: Bool = true
    var categories: [String] = []
    var isCategoryPickerHidden = true
    var isDatePickerHidden = true
    
    var newItem: Item?
    
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var categorySelectedLabel: UILabel!
    @IBOutlet weak var categoryPicker: UIPickerView!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dateSelectedLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var placeNameTextField: UITextField!
    @IBOutlet weak var placeStreetTextField: UITextField!
    @IBOutlet weak var placeNrTextField: UITextField!
    @IBOutlet weak var placePostalTextField: UITextField!
    @IBOutlet weak var placeCityTextField: UITextField!
    
    @IBOutlet weak var contactFirstameTextField: UITextField!
    @IBOutlet weak var contactLastnameTextField: UITextField!
    @IBOutlet weak var contactEmailTextField: UITextField!
    @IBOutlet weak var contactMobileTextField: UITextField!
    @IBOutlet weak var contactTelTextField: UITextField!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isLostItem {
            navigationItem.title = "New lost item"
            dateLabel.text = "Lost on"
        } else {
            navigationItem.title = "New found item"
            dateLabel.text = "Found on"
        }
        datePicker.maximumDate = Date()
        
        updateDateSelected(date: datePicker.date)
        
        for cat in Category.allCases {
            if cat.rawValue != "other"{
                let catString = cat.rawValue
                var catStringUpper = ""
                catStringUpper.append(catString[0].uppercased())
                catStringUpper.append(catString.substring(fromIndex: 1))
                categories.append(catStringUpper)
            }
        }
        categories.sort()
        categories.insert("Other", at: 0)
        
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        categoryPicker.selectRow(0, inComponent: 0, animated: false)
        
        updateSaveButtonState()
        hideKeyboardWhenTappedAround()
    }
    
    @IBAction func textEditingChanged(_ sender: Any) {
        updateSaveButtonState()
    }
    
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        updateDateSelected(date: datePicker.date)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        (segue.destination as! ItemsTableViewController).isLostList = true
        guard segue.identifier == "saveUnwind" else {return}
        
        let title = titleTextField.text!
        let category = Category.init(rawValue: categorySelectedLabel.text!.lowercased())!
        let timestamp = datePicker.date
        let description = descriptionTextView.text!
        let placeName = placeNameTextField.text!
        let street = placeStreetTextField.text!
        let nr = placeNrTextField.text!
        let postal = placePostalTextField.text!
        let city = placeCityTextField.text!
        let firstname = contactFirstameTextField.text!
        let lastname = contactLastnameTextField.text!
        let email = contactEmailTextField.text!
        let tel = contactTelTextField.text!
        let mobile = contactMobileTextField.text!
        
        let place = Place(postalCode: postal, city: city, street: street, nr: nr, name: placeName)
        let contact = Contact(firstname: firstname, lastname: lastname, email: email, tel: tel, mobile: mobile)
        newItem = Item(title: title, itemDescription: description, found: !isLostItem, category: category, place: place, contact: contact, timestamp: timestamp, userEmail: "degraevejari@live.be")
    }
    
    private func updateDateSelected(date: Date){
        dateSelectedLabel.text = Item.timeStampDateFormatter.string(from: date)
    }
    
    private func updateSaveButtonState(){
        saveButton.isEnabled = validateInput()
    }
    
    private func validateInput() -> Bool{
        if titleTextField.text == nil || titleTextField.text == "" {
            return false
        }
        if descriptionTextView.text == nil || descriptionTextView.text == "" {
            return false
        }
        if placeStreetTextField.text == nil || placeStreetTextField.text == "" {
            return false
        }
        if placePostalTextField.text == nil || placePostalTextField.text == "" {
            return false
        }
        if placeCityTextField.text == nil || placeCityTextField.text == "" {
            return false
        }
        if contactFirstameTextField.text == nil || contactFirstameTextField.text == "" {
            return false
        }
        if contactLastnameTextField.text == nil || contactLastnameTextField.text == "" {
            return false
        }
        if contactEmailTextField.text == nil || !isValidEmail(testStr:  contactEmailTextField.text!) {
            return false
        }
        if contactTelTextField.text != nil && contactTelTextField.text != ""  && !isValidTelNr(testStr: contactTelTextField.text!) {
            return false
        }
        if contactMobileTextField.text != nil && contactMobileTextField.text != ""  && !isValidTelNr(testStr: contactMobileTextField.text!) {
            return false
        }
        return true
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func isValidTelNr(testStr:String) -> Bool {
        let telRegex = "^[0-9]+$"
        
        let telTest = NSPredicate(format:"SELF MATCHES %@", telRegex)
        return telTest.evaluate(with: testStr)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let normalCellHeight = CGFloat(44)
        let mediumCellHeight = CGFloat(150)
        let largeCellHeight = CGFloat(200)

        
        switch (indexPath) {
        case [0,1]: //Category-Picker cell
            return isCategoryPickerHidden ? normalCellHeight : largeCellHeight
        case [0,2]: //DatePicker cell
            return isDatePickerHidden ? normalCellHeight : largeCellHeight
        case [1,0]: //Description cell
            return mediumCellHeight
        default:
            return normalCellHeight
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath {
        case [0,1]:
            isCategoryPickerHidden = !isCategoryPickerHidden
            categorySelectedLabel.textColor = isCategoryPickerHidden ? .black : tableView.tintColor
            tableView.beginUpdates()
            tableView.endUpdates()
        case [0,2]:
            isDatePickerHidden = !isDatePickerHidden
            dateSelectedLabel.textColor = isDatePickerHidden ? .black : tableView.tintColor
            tableView.beginUpdates()
            tableView.endUpdates()
        default:
            break
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
    // The data to return fopr the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categorySelectedLabel.text = categories[row]
    }
    
    
    func textViewDidChange(_ textView: UITextView) {
        updateSaveButtonState()
    }
    
}


