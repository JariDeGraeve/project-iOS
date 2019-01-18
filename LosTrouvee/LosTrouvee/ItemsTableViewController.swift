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
        
        //show login and register buttons if no user is logged in
        //show logout and and buttons if user is logged in
        updateBarButtons()
        
        
        /*items = DummyData.getDummyItems().filter{
         (value:Item) -> Bool in
         if isLostList{
         return !value.found
         }else{
         return value.found
         }
         }*/
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
    
    @IBAction func unwindToItemList(segue : UIStoryboardSegue){
        updateBarButtons()
        if segue.identifier == "saveUnwind"{
            
            let addItemVC = segue.source as! AddItemTableViewController
            
            if let item = addItemVC.newItem {
                let newIndexPath = IndexPath(row: items.count, section: 0)
                items.append(item)
                let realm = try! Realm()
                try! realm.write {
                    realm.add(item)
                }
                
                tableView.insertRows(at: [newIndexPath], with: .automatic)
                
            }
        }
        
        //programatically change tab showed
        //        var tab = tabBarController?.viewControllers
        //        if isLostList {
        //            tabBarController!.selectedIndex = 0
        //            //tabBarController?.tabBar.selectedItem = tabBarController?.tabBar.items?[0]
        //        }else{
        //            tabBarController!.tabBarItem = tabBarController!.tabBar.items?[1]
        //            //tabBarController?.tabBar.selectedItem = tabBarController?.tabBar.items?[1]
        //        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "LostListToAdd":
            ((segue.destination as! UINavigationController).viewControllers[0] as! AddItemTableViewController).isLostItem = true
        case "LostListToLogin":
            ((segue.destination as! UINavigationController).viewControllers[0] as! LoginTableViewController).navFromLostList = true
        case "LostListToRegister":
            ((segue.destination as! UINavigationController).viewControllers[0] as! RegisterTableViewController).navFromLostList = true
        case "FoundListToAdd":
            ((segue.destination as! UINavigationController).viewControllers[0] as! AddItemTableViewController).isLostItem = false
        case "FoundListToLogin":
            ((segue.destination as! UINavigationController).viewControllers[0] as! LoginTableViewController).navFromLostList = false
        case "FoundListToRegister":
            ((segue.destination as! UINavigationController).viewControllers[0] as! RegisterTableViewController).navFromLostList = false
        default:
            return
        }
        
    }
    
}



