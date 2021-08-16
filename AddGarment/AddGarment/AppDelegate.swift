//
//  AppDelegate.swift
//  AddGarment
//
//  Created by Matthew Ferguson on 8/12/21.
//

import UIKit
import CoreData
import DataFlowFunnelCD

/// A view that displays one or more lines of read-only text. [...]
/// UITableViewDelegate conformance
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var fishingBoatBackgroundProcessing:ErrorLogDemarcation?
    var refDataFlowFunnel:DataFlowFunnel = DataFlowFunnel.shared

    /// <#Description#>
    ///
    /// - Parameter value: <#value description#>
    /// - Returns: <#return value description#>
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.refDataFlowFunnel.setModelName(to: "AddGarmentModel" )
        self.refDataFlowFunnel.setTargetBundleIdentifier(bundleId: "com.matthewferguson.AddGarment")
        
  
        //DataFlowFunnel.shared.addOperation(FetchAndDescribeDataOperation())
        
        // start the error log operations
        self.fishingBoatBackgroundProcessing = ErrorLogDemarcation()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    /// <#Description#>
    ///
    /// - Parameter value: <#value description#>
    /// - Returns: <#return value description#>
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    /// <#Description#>
    ///
    /// - Parameter value: <#value description#>
    /// - Returns: <#return value description#>
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

