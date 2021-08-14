//
//  AppDelegate.swift
//  AddGarment
//
//  Created by Matthew Ferguson on 8/12/21.
//

import UIKit
import CoreData
import DataFlowFunnelCD


@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var testGarmentCollection:[String] = ["apple","orange","zoofruit","banana","stawberry","blueberries","mango","sogood","wannabefruit","green chili","hops"]
    
    var refDataFlowFunnel:DataFlowFunnel = DataFlowFunnel.shared

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.refDataFlowFunnel.setModelName(to: "AddGarmentModel" )
        self.refDataFlowFunnel.setTargetBundleIdentifier(bundleId: "com.matthewferguson.AddGarment")
        
        
        //DataFlowFunnel.shared.addOperation(FetchAndDescribeDataOperation())
        //DataFlowFunnel.shared.addOperation(RemoveAllGarmentOperation())
        //DataFlowFunnel.shared.addOperation(FetchAndDescribeDataOperation())
        DataFlowFunnel.shared.addOperation(XCTextLoadOperation(initNames: testGarmentCollection))
        //DataFlowFunnel.shared.addOperation(FetchAndDescribeDataOperation())
        
        sleep(5)
        //self.removeDataOnTerminate()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

