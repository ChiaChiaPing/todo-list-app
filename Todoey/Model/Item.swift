//
//  Item.swift
//  Todoey
//
//  Created by 賈加平 on 2018/2/9.
//  Copyright © 2018年 賈加平. All rights reserved.
//

import Foundation
import RealmSwift



class Item:Object{
    
    @objc dynamic var title:String=""
    @objc dynamic var done:Bool=false
    @objc dynamic var dateCreated:Date?
    
    //inverse relationships of Item : one to manu
    //Class.self代表他自己本身的型別，property relationship's name of  Category_to_Item
    var parentCategory=LinkingObjects(fromType: Category.self, property:"items" )
    
}
