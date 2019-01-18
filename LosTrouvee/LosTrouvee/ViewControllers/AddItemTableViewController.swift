//
//  AddItemTableViewController.swift
//  LosTrouvee
//
//  Created by Jari De Graeve on 26/12/2018.
//  Copyright © 2018 Jari De Graeve. All rights reserved.
//

import UIKit
import FirebaseAuth

class AddItemTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource,
UITextViewDelegate{
    
    var isLostItem: Bool = true
    var categories: [String] = []
    var isCategoryPickerHidden = true
    var isDatePickerHidden = true
    
    var item: Item?
    
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
    @IBOutlet weak var foundButton: UIBarButtonItem!
    
    var editingEnabled = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        if let item = item {
            //details item
            
            let user = Auth.auth().currentUser
            if user != nil && user!.email! == item.userEmail {
                //correct user => show save button and enable editing
                self.navigationItem.rightBarButtonItems = [saveButton,foundButton]
                enableEditing(true)
                
            } else {
                //if incorrect user => hide save button and disable editing
                self.navigationItem.rightBarButtonItems = nil
                enableEditing(false)
                fillOrHideEmptyFields(for: item)
            }
            
            updateInputFields(with: item)
            
        } else {
            //new item
            editingEnabled = true
            self.navigationItem.rightBarButtonItems = [saveButton]
            if isLostItem {
                navigationItem.title = "New lost item"
            } else {
                navigationItem.title = "New found item"
            }
            
            categoryPicker.selectRow(0, inComponent: 0, animated: false)
            
            if let user = Auth.auth().currentUser {
                contactEmailTextField.text = user.email
            }
            
        }
        
        if isLostItem {
            dateLabel.text = "Lost on"
        } else {
            dateLabel.text = "Found on"
        }
        datePicker.maximumDate = Date()
        updateDateSelected(date: datePicker.date)
        
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
        (segue.destination as! ItemsTableViewController).isLostList = isLostItem
        guard segue.identifier == "saveUnwind" else {return}
        if item == nil {
            (segue.destination as! ItemsTableViewController).isLostList = true
        }
        
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
        
        let userEmail = Auth.auth().currentUser!.email!
        
        let place = Place(postalCode: postal, city: city, street: street, nr: nr, name: placeName)
        let contact = Contact(firstname: firstname, lastname: lastname, email: email, tel: tel, mobile: mobile)
        item = Item(title: title, itemDescription: description, found: !isLostItem, category: category, place: place, contact: contact, timestamp: timestamp, userEmail: userEmail)
    }
    
    private func fillOrHideEmptyFields(for item: Item){
        if(item.place!.placeName.isEmpty){
            placeNameTextField.placeholder = "No name available"
        }
        if(item.place!.nr.isEmpty){
            placeNrTextField.isHidden = true
        }
        if(item.contact!.mobile.isEmpty && item.contact!.tel.isEmpty){
            contactMobileTextField.placeholder = "No mobile number"
            contactTelTextField.placeholder = "No telephone number"
        }else if(item.contact!.mobile.isEmpty){
            contactMobileTextField.isHidden = true
        }else if(item.contact!.tel.isEmpty){
            contactTelTextField.isHidden = true
        }
    }
    
    private func enableEditing(_ enabled: Bool){
        editingEnabled = enabled
        titleTextField.isEnabled = enabled
        categoryPicker.isHidden = !enabled
        datePicker.isHidden = !enabled
        descriptionTextView.isEditable = enabled
        placeNameTextField.isEnabled = enabled
        placeNrTextField.isEnabled = enabled
        placeStreetTextField.isEnabled = enabled
        placePostalTextField.isEnabled = enabled
        placeCityTextField.isEnabled = enabled
        contactMobileTextField.isEnabled = enabled
        contactTelTextField.isEnabled = enabled
        contactEmailTextField.isEnabled = enabled
        contactFirstameTextField.isEnabled = enabled
        contactLastnameTextField.isEnabled = enabled
    }
    private func updateInputFields(with item: Item){
        let category = item.categoryRaw[0].uppercased() + item.categoryRaw.substring(fromIndex: 1)
        
        navigationItem.title = item.title
        titleTextField.text = item.title
        categorySelectedLabel.text = category
        categoryPicker.selectRow(categories.firstIndex(of: category)!, inComponent: 0, animated: false)
        datePicker.date = item.timestamp
        descriptionTextView.text = item.itemDescription
        placeNameTextField.text = item.place!.placeName
        placeStreetTextField.text = item.place!.street
        placeNrTextField.text = item.place!.nr
        placePostalTextField.text = item.place!.postalCode
        placeCityTextField.text = item.place!.city
        contactFirstameTextField.text = item.contact!.firstname
        contactLastnameTextField.text = item.contact!.lastname
        contactEmailTextField.text = item.contact!.email
        contactTelTextField.text = item.contact!.tel
        contactMobileTextField.text = item.contact!.mobile
    }
    
    private func updateDateSelected(date: Date){
        dateSelectedLabel.text = Item.timeStampDateFormatter.string(from: date)
    }
    
    private func updateSaveButtonState(){
        // controle op currentUser is puur een extra laag veiligheid
        if saveButton != nil {
            saveButton.isEnabled = validateInput() && Auth.auth().currentUser != nil
        }
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
        if editingEnabled {
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


