//
//  AppDelegate.swift
//  Todoey
//
//  Created by 賈加平 on 2018/1/30.
//  Copyright © 2018年 賈加平. All rights reserved.
//  Relationship between os and application

import UIKit

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
        //在終止前想要save data的話
       print("-ApplicationWillTerminate-")
    }


}

