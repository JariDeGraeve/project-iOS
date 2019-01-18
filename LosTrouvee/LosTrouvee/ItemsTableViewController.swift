//
//  ItemsTableViewController.swift
//  
//
//  Created by Jari De Graeve on 28/11/2018.
//

import UIKit
import RealmSwift
import FirebaseAuth

class ItemsTableViewController: UITableViewController {
    
    @IBOutlet var logoutButton: UIBarButtonItem!
    @IBOutlet var loginButton: UIBarButtonItem!
    @IBOutlet var registerButton: UIBarButtonItem!
    @IBOutlet var addButton: UIBarButtonItem!
    
    var items = [Item]()
    //var items: Results<Item>!
    var isLostList : Bool = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let title = navigationItem.title
        if title == "Lost items" {
            isLostList = true
        }else{
            isLostList = false
        }
        items = Array(try! Realm().objects(Item.self)).filter{
            (value:Item) -> Bool in
            if isLostList{
                return !value.found
            }else{
                return value.found
            }
        }
        updateBarButtons()
      
    }
    @IBAction func logoutAction(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        }
        catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initial = storyboard.instantiateInitialViewController()
        UIApplication.shared.keyWindow?.rootViewController = initial
     
    }
    
    func updateBarButtons(){
        if(Auth.auth().currentUser == nil){
            self.navigationItem.leftBarButtonItems = [self.loginButton, self.registerButton]
            self.navigationItem.rightBarButtonItems = nil
        }else {
            self.navigationItem.leftBarButtonItems = [self.logoutButton]
            self.navigationItem.rightBarButtonItems = [self.addButton]
            print((Auth.auth().currentUser?.email)!)
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : ItemTableViewCell
        if  isLostList {
            cell = tableView.dequeueReusableCell(withIdentifier: "LostItemCellIdentifier", for: indexPath) as! ItemTableViewCell
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "FoundItemCellIdentifier", for: indexPath) as! ItemTableViewCell
        }
        
        // Configure the cell...
        let item = items[indexPath.row]
        cell.update(with: item)
        cell.showsReorderControl = true
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let user = Auth.auth().currentUser
        return user != nil && user!.email! == items[indexPath.row].userEmail
           
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let realm = try! Realm()
            try! realm.write {
                realm.delete(items[indexPath.row])
            }
            items.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    @IBAction func unwindToItemList(segue : UIStoryboardSegue){
        updateBarButtons()
        if segue.identifier == "saveUnwind"{
            
            let addItemVC = segue.source as! AddItemTableViewController
            
            if let item = addItemVC.item {
                let realm = try! Realm()
                
                if let selectedIndexPath = tableView.indexPathForSelectedRow {
                    //updated item
                    try! realm.write {
                        realm.delete(items[selectedIndexPath.row])
                        realm.add(item)
                    }
                    items[selectedIndexPath.row] = item
                    tableView.reloadRows(at: [selectedIndexPath], with: .none)
                    
                }else{
                    //added item
                    let newIndexPath = IndexPath(row: items.count, section: 0)
                    items.append(item)
                    try! realm.write {
                        realm.add(item)
                    }
                    if isLostList && !item.found {
                        tableView.insertRows(at: [newIndexPath], with: .automatic)
                    }else{
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let initial = storyboard.instantiateInitialViewController()
                        UIApplication.shared.keyWindow?.rootViewController = initial
                    }
                }
            }
        }else if segue.identifier == "foundUnwind"{
            let addItemVC = segue.source as! AddItemTableViewController
            if let item = addItemVC.item {
                let realm = try! Realm()
                
                try! realm.write {
                    realm.delete(item)
                }
                let selectedIndexPath = tableView.indexPathForSelectedRow!
                items.remove(at: selectedIndexPath.row)
                tableView.deleteRows(at: [selectedIndexPath], with: .none)
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "LostListToAdd":
            ((segue.destination as! UINavigationController).viewControllers[0] as! AddItemTableViewController).isLostItem = true
            break
        case "LostListToLogin":
            ((segue.destination as! UINavigationController).viewControllers[0] as! LoginTableViewController).navFromLostList = true
            break
        case "LostListToRegister":
            ((segue.destination as! UINavigationController).viewControllers[0] as! RegisterTableViewController).navFromLostList = true
            break
        case "FoundListToAdd":
            ((segue.destination as! UINavigationController).viewControllers[0] as! AddItemTableViewController).isLostItem = false
            break
        case "FoundListToLogin":
            ((segue.destination as! UINavigationController).viewControllers[0] as! LoginTableViewController).navFromLostList = false
            break
        case "FoundListToRegister":
            ((segue.destination as! UINavigationController).viewControllers[0] as! RegisterTableViewController).navFromLostList = false
            break
        case "ListToDetails":
            let selectedItem = items[tableView.indexPathForSelectedRow!.row]
            (segue.destination as! AddItemTableViewController).item = selectedItem
            (segue.destination as! AddItemTableViewController).isLostItem = !selectedItem.found
            break
        default:
            return
        }
        
    }
    
}



