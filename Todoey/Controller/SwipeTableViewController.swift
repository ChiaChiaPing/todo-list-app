//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by 賈加平 on 2018/2/10.
//  Copyright © 2018年 賈加平. All rights reserved.
//

import UIKit
import SwipeCellKit


//之前的做法是寫在同一個Class但是Extension，可是當很多類別都會用到的時候，它就可以做為服類別或是介面，共同去存取
//寫一個父類別或介面給大家繼承
class SwipeTableViewController: UITableViewController,SwipeTableViewCellDelegate {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight=CGFloat(80)
    }
    
    //MARK: TableView Datasource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //如果不能cast，就去mainstoryboard，背後應該會自動加載，手動去繼承SwipeTableViewCell
        let cell=tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        cell.delegate=self
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        guard orientation == .right else { return nil }
        
        //當orientation做完，執行下面的action
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            
            print("Delete Self")
            self.updateModel(at: indexPath)

        }
        
        // customize the action appearance, action呈現方式
        deleteAction.image = UIImage(named: "Delete_Icon")
        
        return [deleteAction]
        
    }
    
    // optional customerize swipe representation 他可以同時包含很多種呈現方式
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        var options = SwipeTableOptions()
        options.expansionStyle = .destructive
        //options.transitionStyle = .border
        return options
    }
    
    //提供一個function 去給子類別實作
    func updateModel(at indexPath:IndexPath){
        //update data Model
    }
    

   

}
