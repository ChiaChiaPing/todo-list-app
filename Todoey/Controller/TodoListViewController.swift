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

/** User's Defaults can be a local database interface to control local'sdata I/O **/
//SingleTon Object : UserDefaults is a interface of accessing user's default Database
    //存放方式為Key Value，所以他存放形式為.plist file，位置在 以simulator為主：資料存在device's UID/.../Application ID / Library / Preference/ .plist file


    //Write: self.defaults.set(self.itemArray, forKey: "ToDoListArray") //set 是重新寫入不是append
    // 內容可以存任何形式

    /* Read:if let items = defaults.array(forKey: "ToDoListArray") as? [String]  {
        itemArray = items
    } */
    //


import UIKit

class TodoListViewController: UITableViewController {

    var itemArray:[Item]=[]
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad(){
        super.viewDidLoad()
       
        let newItem=Item()
        newItem.title="Mike"
        itemArray.append(newItem)
        
        let newItem1=Item()
        newItem1.title="Kevin"
        itemArray.append(newItem1)
        
        let newItem2=Item()
        newItem2.title="Chia"
        itemArray.append(newItem2)
        
        
        // read local's Data form sandbox's
        if let items = defaults.object(forKey: "itemArray")  as?  [Item]  { //as:轉型 !強制 ?選擇性
            itemArray = items
        }
    
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    //MARK: Tableview Datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    // cell 長什麼樣子 與 cell 的內容值為何, By the way : indesPath.row starts from zero
    // 只會在一開始view load時 會執行 然後執行每一列的內容
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item=itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ?.checkmark :.none
        
        return cell
        
    }
    
    //MARK: TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // itemArray[indexPath.row]  select哪一列
        //如果bool互相切換，可以用下面的表示
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        //uncheck後的動畫，放掉滑鼠後的動畫
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        //因為上面那個function只會在載入畫面時執行，所以這邊有變動，就要reload(再次呼叫上面)，畫面重整的概念
        tableView.reloadData()
    }
    
    //MARK: Add new Item/work/thing
    // 沒有順序的執行 會一次全部執行
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
            if (workNameField.text?.isEmpty)!{//這裡的text一定有值
                print("No work added")
            }else{
                let temp = Item();
                temp.title=workNameField.text!
                self.itemArray.append(temp)
                
                //set key:value 不過set：重新寫入，內容可以存任何形式
                do{
                    try self.defaults.set(self.itemArray, forKey: "itemArray")
                }catch{
                    print("QQ")
                }
                
                self.tableView.reloadData()
            }
        })
        
        // alert 加入 action
        alert.addAction(action)
        
        //alert 假想它是一個viewController 但是是小的視窗 => AlertController
        present(alert, animated: true, completion: nil)
        
    }

}

