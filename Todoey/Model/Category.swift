//
//  Category.swift
//  Todoey
//
//  Created by 賈加平 on 2018/2/9.
//  Copyright © 2018年 賈加平. All rights reserved.
//

import Foundation
import RealmSwift

//資料庫 建立表(建立物件及屬性後，還要設置兩者關係)
class Category: Object {
    
    //monitor variable while app is runing
    @objc dynamic var name:String=""
    // Build Realtionship one to many
    //每一個category有很多items
    let items=List<Item>()

}
