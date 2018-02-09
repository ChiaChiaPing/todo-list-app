//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by 賈加平 on 2018/2/8.
//  Copyright © 2018年 賈加平. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift


class CategoryTableViewController: UITableViewController {
    
    
    //bed smell：判斷是不好的，但是不是always這樣
    //強制執行，這樣就不樣做do catch
    let realm = try! Realm() //Realm()就很像是DB
    
    var categoryArray:Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategory()
    }

    //MARK: - Tableview DataSource method
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //1是因為要讓他可以呈現No Categories Add yet
        return categoryArray?.count ?? 1 // ??(假如是nil 做得事情)
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell=tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        //先判斷categoryArray是不是空直，不是就去取[]的值，如果是就做??後面的事情
        //有default values ?? 執行上會比較安全且嚴謹
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No Categories Added Yet"
        return cell
    }
  
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var categoryName=UITextField()
        
        let alert=UIAlertController(title: "Add new category", message:"" , preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: { TextField in
            
            TextField.placeholder="Enter your category name"
            categoryName=TextField
        })
        
        let action=UIAlertAction(title: "Add", style: .default) {
            (action) in
            //action帶自己本身
            
            if categoryName.text! == ""{
                print("Nothing Add")
            }else{
                let newCategory = Category()
                newCategory.name=categoryName.text!
                //self.categoryArray.append(newCategory)  // automatically updateing
                self.saveCategories(category:newCategory)
            }
        }
        
        alert.addAction(action)
        
        //彈出視窗(viewController)的動畫
        present(alert, animated: true, completion: nil)
       
   
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //去往哪裡，基本上在segue前一定會prepare當作是資料session的橋樑，用identifier去判別往哪一個view
        performSegue(withIdentifier: "goToItem", sender: self) //會自己執行下面的function prepare
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //去往哪裡之前的準備工作
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow{ // 回傳選擇哪一列
            destination.selectedCategory = categoryArray?[indexPath.row]
        }
    }
    
    //MARK: - Data Manipulation Methods
    func saveCategories(category:Category){
        do{
            //realm.write有兩種儲存方式，一種是直接在大括號裡面新增物件(資料)
            //二是建立一個物件，但沒有寫在write，然後透過add物件的方式寫入，但是基本上都要寫在writes()裡面
            try realm.write { //類似context.save，
                realm.add(category)
            }
            tableView.reloadData()
        }catch{
            print("---\(error)")
        }
    }
    func loadCategory(){
        // 讀取物件
        categoryArray = realm.objects(Category.self)
        tableView.reloadData() //Execute Datasource method
    }
}
