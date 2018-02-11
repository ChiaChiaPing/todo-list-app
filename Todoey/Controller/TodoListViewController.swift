//
//  ViewController.swift
//  Todoey
//
//  Created by 賈加平 on 2018/1/30.
//  Copyright © 2018年 賈加平. All rights reserved.
//

/**SubClass from UITableViewController**/
    // TableViewController and ViewController is different Class
    // 如果直接繼承UITableViewController 就不用指派delegate 與 conform to relative protocol
    // 在TableViewController (mainstoryboard) 可以更改Accessory 改變check之後要做啥事
// Button也有不同種類，如 bar button item 就會是放在navigation bar

/**Debug Console and Breakpoint**/
    // 在Debug Console 可以搭配 Breakpoint 一步一步執行code(ex: step over) , breakpoint disappear after drag
    // alert => addTextField => click button action => alert.add(action)

/**Persistent Local StorageData **/
    //透過 UserDefaults 儲存資料但是存在自己的Application（就像是一個sandbox），裡面的資料與外部資料互不影響

/** method1: User's Defaults can be a local database interface to control local'sdata I/O **/
//SingleTon Object : UserDefaults is a interface of accessing user's default Database
    //存放方式為Key Value，所以他存放形式為.plist file，位置在 以simulator為主：資料存在device's UID/.../Application ID / Library / Preference/ .plist file


    //Write: self.defaults.set(self.itemArray, forKey: "ToDoListArray") //set 是重新寫入不是append
    // 內容可以存任何形式

    /* Read:if let items = defaults.array(forKey: "ToDoListArray") as? [String]  {
        itemArray = items
    } */
    //效能及儲存的資料型別有限，如果是要儲存多資料的話，可以用更好的工具 core data
    //例如：只能存一個物件，存放物件陣列就不行了

/** method2: Codable(custom plist) : another way of local's data in sandbox I/O **/
    // 首先，要先建立檔案的格式與路徑：FileManager.default.urls(for:.documentDirectory,in: .userDomainMask).first?

    // Encode:寫入 data have to confirm to Encodable
        // 建立 properlist => 編碼(Encode)(被寫入的資料要遵守Encodable) => 寫入(write)
        // let encoder=ProperListEncoder() => data=encoder.encode({owndata}) => data.write(to:path)
    // Decode:讀取  data have to confirm to Decodable
        //take reference to loadItem() below

/** method3:CoreData，get Access to AppDelegate Database更動完，Model(MVC)也要做更動 **/
    //"可透過FileManager.default.urls(for: .documentDirectory, in: .userDomainMask) 得知存放位置"

    //下面很像是temporary area
    //let context = (UIApplication.shared.delegate as AppDelegate).persistentContainer.viewContext;

    //一個DataModel就是一個persistentContinaer DB的概念
    //SQLite：關聯式資料庫管理系統，而persistentContainer 很像SQLlite 裡面 DB的概念
    //NSManageObject就像是：資料表中每一筆資料，每一筆資料在oop就很像是一個物件


import UIKit
import CoreData
import RealmSwift

class TodoListViewController: SwipeTableViewController {
    
    //auto-updateing of realm model，因為Results<Item>的關係
    var todoItems:Results<Item>? //建立CoreData後，可以假想這個Item就是一張資料表，裡面的每筆資料都代表每個物件
    let realm = try! Realm() //抓DB
    
    //若selectedCategory 獲得值的話，會執行下面動作，在屬性變化後，做什麼事情，willSet：在屬性變化前做什麼事情
    //指定變數的時候也可以給與值設定
    var selectedCategory:Category?{
        didSet{
            //print("QOO")
            loadItem()
        }
    }
    /**get Access to AppDelegate
   // let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext;
 **/
    
    //method2:another way to saving data in locals:(for 目錄格式, in 路徑).first?.appendingPathComponent("filename")
   
    
    //method1:let defaults = UserDefaults.standard
    override func viewDidLoad(){
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        loadItem()
    
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    /**-------------------------------------------------------------------------**/
    //MARK: Tableview Datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1 // No Items Add
    }
    
    // cell 長什麼樣子 與 cell 的內容值為何, By the way : indesPath.row starts from zero
    // 只會在一開始view load時 會執行 然後執行每一列的內容
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row]{
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ?.checkmark :.none
        }else{
            cell.textLabel?.text="No Items Add"
        }
        return cell
    }
    
    //MARK: TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if let item = todoItems?[indexPath.row]{
            do{
                try realm.write {
                    item.done = !item.done //Update
                   //realm.delete(item) //Delete
                }
            }catch{
                print("Error Saving Status \(error)")
            }
        }
        //uncheck後的動畫，放掉滑鼠後的動畫
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData() //刷新
        //saveItem()// update local's data
    
    }
  
 /**-------------------------------------------------------------------------**/
    //MARK: Add new Item/work/thing
    // 沒有順序的執行 會一次全部執行
    override func updateModel(at indexPath: IndexPath) {
       
        if let item=todoItems?[indexPath.row]{
            do{
                try self.realm.write{
                    self.realm.delete(item)
                }
            }catch{
                print("-------\(error)")
            }
        }
    }
    @IBAction func addButtomPressed(_ sender: UIBarButtonItem) {
        
        // 建立一個溝通的local variables，直接傳 text不行，傳物件
        var workNameField = UITextField()
        
        // 彈出視窗
        let alert = UIAlertController(title: "Add New Todey Item", message:"", preferredStyle: .alert)
        
        //在視窗加入輸入textfield行為
        alert.addTextField(configurationHandler: {TextField in
            //placeholder 放預設值(灰色)
            TextField.placeholder = "Enter your worklist"
            workNameField=TextField
        })
        
        //點擊新增後會發生何事
        let action=UIAlertAction(title: "Add Item", style: .default, handler: { (action) in
            //what happen once user clicks addItemButton on our alert
            
            if workNameField.text! != ""{
                if let currentCategory = self.selectedCategory{
                    
                    do{
                        try self.realm.write{
                            let newItem = Item() //讀取哪一張資料表（類別）並建立一筆資料
                            newItem.title = workNameField.text!
                            newItem.dateCreated=Date()
                            currentCategory.items.append(newItem)
                        }
                    }catch{
                        print("----\(error)")
                    }
                }
            }
            
            self.tableView.reloadData()
            
        })
        
        // alert 加入 action
        alert.addAction(action)
        
        //alert 假想它是一個viewController 但是是小的視窗 => AlertController
        present(alert, animated: true, completion: nil)
   
    }
   /**-------------------------------------------------------------------------**/
    //MARK: Model manipulate method CRUD
    //save data : encode 在做check或是 uncheck 應該都要隨時與update local's data
    func saveItem(item:Item){
        do{
            try realm.write {
                realm.add(item)
            }
            //try context.save()
        }catch{
            print("Error saving context:\(error)")
        }
    
        tableView.reloadData()
    }
    
    //read data 假如沒有帶參數，可以給function預設值，很像python kwargs
    func loadItem(){
        //其實這裡沒有從資料庫抓，只是從指派過來的selectedCategory抓那個List
        //它sort 只是為了要讓items 蝠賀我們命名的型別Result<Item>
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
}

//MARK: SearchButton 開發如果都在同一個class 會很龐大，以下面做，這樣上面就不用繼承(很多會很醜)，下面方便寫也清楚
//NSPredicate就很像是Query，下條件抓資料，NSPredicate只有在Swift裡面有
//extension 裡面只能包含function

//Realm 的 Query 利用filter
extension TodoListViewController:UISearchBarDelegate{

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        //Filter更直觀如過濾Table 去執行query，
        todoItems = todoItems?.filter(NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
        
    }

    //MARK: DispatchQueue 執行緒的分工，如有些程式可以在背景處理就可以用多執行緒，但如果都在同一個thread，效率會很差
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count==0{
            loadItem()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    
    }
}
