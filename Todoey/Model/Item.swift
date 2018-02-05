//
//  Item.swift
//  Todoey
//
//  Created by 賈加平 on 2018/2/5.
//  Copyright © 2018年 賈加平. All rights reserved.
//

//Core Data is oop database

import Foundation

 // 若要儲存物件到檔案中，要遵守 Encodable ，代表外部想要存的話，這個物件自己本身也要遵守可以被鞋入的協定

class Item:Encodable,Decodable{
    
    var title:String=""
    var done:Bool=false
    
}
