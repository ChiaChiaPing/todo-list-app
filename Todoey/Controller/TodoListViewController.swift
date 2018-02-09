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

class TodoListViewController: UITableViewController {
    
    var itemArray:[Item]=[] //建立CoreData後，可以假想這個Item就是一張資料表，裡面的每筆資料都代表每個物件
    
    
    //若selectedCategory 獲得值的話，會執行下面動作，在屬性變化後，做什麼事情，willSet：在屬性變化前做什麼事情
    //指定變數的時候也可以給與值設定
    var selectedCategory:Category?{
        didSet{
            loadItem()
        }
    }
    // //get Access to AppDelegate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext;
    
    //method2:another way to saving data in locals:(for 目錄格式, in 路徑).first?.appendingPathComponent("filename")
   
    
    //method1:let defaults = UserDefaults.standard
    override func viewDidLoad(){
        super.viewDidLoad()
       print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        /*
         let dataFilePath=FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.plist")*/
        
        loadItem()
        
        /** UserDefaults:read local's Data form sandbox's **/
        // if let items = defaults.object(forKey: "itemArray")  as?  [Item]  { //as:轉型 !強制 ?選擇性
           // itemArray = items
        //
    
        // Do any additional setup after loading the view, typically from a nib.
       
    
    }
    
    /**-------------------------------------------------------------------------**/
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

        //context.delete(itemArray[indexPath.row])//刪除DB的資料，但仍保有itemArray的索引位置，所以需要下面那欄
        //itemArray.remove(at: indexPath.row) //因為是Swift Array本身的function
        
        //Data Model Update:setValue, forkey represent 資料表的 Fields
        //update可以直接不用透過context直接去改值
        //itemArray[indexPath.row].setValue("Complete", forKey: "title") //cordData的function
        
        // itemArray[indexPath.row]  select哪一列
        //如果bool互相切換，可以用下面的表示
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        //uncheck後的動畫，放掉滑鼠後的動畫
        tableView.deselectRow(at: indexPath, animated: true)
        
        saveItem()// update local's data
        
        //因為上面那個function只會在載入畫面時執行，所以這邊有變動，就要reload(再次呼叫上面)，畫面重整的概念
        //tableView.reloadData(), 這裡註解是因為 saveItem 已經包含 reloadData
    }
  
 /**-------------------------------------------------------------------------**/
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
                
                //Create 一筆資料，相較於一個物件
                let newItem = Item(context:self.context) //讀取哪一張資料表且讀取格式
                newItem.title = workNameField.text!
                newItem.done=false //因為CoreData 的 Item Entity 的done 不是 option => 不能是空值
                newItem.parentCategory=self.selectedCategory
                self.itemArray.append(newItem)
                self.saveItem()
                
                
                //set key:value 不過set：重新寫入，內容可以存任何形式
                //self.defaults.set(self.itemArray, forKey: "itemArray")
            }
        })
        
        // alert 加入 action
        alert.addAction(action)
        
        //alert 假想它是一個viewController 但是是小的視窗 => AlertController
        present(alert, animated: true, completion: nil)
   
    }
   /**-------------------------------------------------------------------------**/
    //MARK: Model manipulate method CRUD
    //save data : encode 在做check或是 uncheck 應該都要隨時與update local's data
    func saveItem(){
        do{
            try context.save()
            //loadItem()
        }catch{
            print("Error saving context:\(error)")
        }
    
        tableView.reloadData()
    }
    
    //read data 假如沒有帶參數，可以給function預設值，很像python kwargs
    func loadItem(with request:NSFetchRequest<Item> = Item.fetchRequest(),predicate:NSPredicate? = nil){
     
        //設定query一定有對於類別的query,這裏paretnCategory.name 是指item.relationship.name
        let categoryPredicate = NSPredicate(format: "parentCategory.name CONTAINS %@", (selectedCategory?.name)!)
        
        //1. 為了程式的精簡性
        //2.
        if let additionPredicate = predicate{
            //有點像是一個裝很多query的容器，你下的指令有在這個容器內就可以執行，當有兩個query一起下條件的時候都可以 AND
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,additionPredicate])
        }else{
            request.predicate=categoryPredicate
        }

        
        do{
            itemArray = try context.fetch(request)//讀取：讀取Core Data資料
        }catch{
            print("--\(error)--")
        }
    
        tableView.reloadData()
        
    }
}

//MARK: SearchButton 開發如果都在同一個class 會很龐大，以下面做，這樣上面就不用繼承(很多會很醜)，下面方便寫也清楚
//NSPredicate就很像是Query，下條件抓資料，NSPredicate只有在Swift裡面有
//extension 裡面只能包含function
extension TodoListViewController:UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        //讀取前的動作，先丟出讀取需求，Item 假想他就是一個資料表
        let request:NSFetchRequest<Item> = Item.fetchRequest() //抓取資料表
        
        //Query: CoreData query %Variables, @ is any character，cd表式搜尋字串開頭到結尾都要與內容一樣才會回傳
        let predicate=NSPredicate(format: "title CONTAINS[cd] %@",searchBar.text!)
        
        //Sort Description: 排序資料
        request.sortDescriptors=[NSSortDescriptor(key: "title", ascending: true)]
        loadItem(with: request,predicate:predicate)
       
    }
    
    //MARK: DispatchQueue 執行緒的分工，如有些程式可以在背景處理就可以用多執行緒，但如果都在同一個thread，效率會很差
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText==""{
            loadItem()
            //只有UI繪製，介面數據刷新才用主thread，其他任何行為應用非主thread
            //把他抓到mainthread來執行
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    
    }
    
    
    
    
}







