//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by 賈加平 on 2018/2/8.
//  Copyright © 2018年 賈加平. All rights reserved.
//

import UIKit
import CoreData


class CategoryTableViewController: UITableViewController {

    var categoryArray:[Category]=[]
    
    let context=(UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategory()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    

    }

    //MARK: - Tableview DataSource method
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell=tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        cell.textLabel?.text = categoryArray[indexPath.row].name
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
                let newCategory = Category(context:self.context)
                newCategory.name=categoryName.text
                self.categoryArray.append(newCategory)
                self.save()
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
            destination.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
    //MARK: - Data Manipulation Methods
    func save(){
        
        do{
            try context.save()
            tableView.reloadData()
        }catch{
            print("---\(error)")
        }
    }
    func loadCategory(){
        
        let request:NSFetchRequest<Category> = Category.fetchRequest()
        
        do{
            categoryArray = try context.fetch(request)
            tableView.reloadData()
        }catch{
            print("--\(error)----")
        }
        
    }
    
    
}
