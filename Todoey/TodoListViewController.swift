//
//  ViewController.swift
//  Todoey
//
//  Created by 賈加平 on 2018/1/30.
//  Copyright © 2018年 賈加平. All rights reserved.
//

//TableViewController and ViewController is different Class

// 如果直接繼承UITableViewController 就不用指派delegate 與 conform to relative protocol

// 在TableViewController (mainstoryboard) 可以更改Accessory 改變check之後要做啥事
import UIKit

class TodoListViewController: UITableViewController {

    
    let itemArray=["Find Mike","Buy Eggos","Destroy Demogorgon"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        print("Q")
    }
    
    //MARK: Tableview Datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    // cell 長什麼樣子 與 cell 的內容值為何, By the way : indesPath.row starts from zero
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
        
    }
    
    //MARK: TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //print(itemArray[indexPath.row])
        
       // tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        //uncheck後的動畫，放掉滑鼠後的動畫
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

   


}

