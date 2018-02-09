//
//  AppDelegate.swift
//  Todoey
//
//  Created by 賈加平 on 2018/1/30.
//  Copyright © 2018年 賈加平. All rights reserved.
//  Relationship between os and application

import UIKit
import CoreData
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        /**
        //local data's storage location
        //每個device都有一個專屬的UID，而底下每個Application又有它專屬的ID（在那個sandbox）
        //以simulator為主：資料存在device's UID/.../Application ID / Library / Preference/ .plist file**/
        //print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as String)
        
       //print(Realm.Configuration.defaultConfiguration.fileURL)
        
        do{
            let _ = try Realm() // getting Realm Database
        }catch{
            print("----\(error)")
        }
        
        print("didFinishedLaunchedWithOptions")
        
        return true
    }
    
    //被迫跑到bg，與下方很像
    func applicationWillResignActive(_ application: UIApplication) {
        //當在foreground有Application在跑時，若有發生interrupt，該Application 會跑到bg，那這個方法就是在預防跑到bg時，資料有所遺失
        print("interruption")
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    //user 主動的切到bg 相較之下 => Application被迫切到bg
    func applicationDidEnterBackground(_ application: UIApplication) {
        print("-applicationDidEnterBackground-")
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    // MARK: - Core Data stack
    
    //lazy 省下記憶題空間，當需要的時候才會佔用時間與資源去執行
    //NSPersistentContainer 存放所有資料,default is SQLite database
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        //context : like git's staging working area
        let context = persistentContainer.viewContext //可以不斷更新資料直到滿意
        if context.hasChanges {
            do {
                try context.save() //類似commit 然後儲存
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }


}

