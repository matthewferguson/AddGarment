//
//  FetchAndDescribeData.swift
//  PondFishing
//
//  Created by Matthew Ferguson on 2/17/21.
//

import Foundation
import CoreData
import DataFlowFunnelCD


/// Fetch all tables and print out all for debug. 
/// Operation conformance
/// Try-Catch: If an error is thrown the catch will capture the error description, assign a type level integer for UX
///             or analytics data flow into web services, and a timeStamp.  This error will be placed in persistence
///             and listeners and business logic will handle announcements and UX controll.  This decouples the error,
///             captures the error, allows for navigation commands and popup views to be displayed micro-seconds later.
///             Modularization and de-coupling errors. 
final class FetchAndDescribeDataOperation: Operation {
    
    override init() {
        super.init()
    }

    /// Main entry point running this operation task as a thread
    ///
    /// - Parameter value: none
    /// - Returns: none
    /// Try-Catch: If an error is thrown the catch will capture the error description, assign a type level integer for UX
    ///             or analytics data flow into web services, and a timeStamp.  This error will be placed in persistence
    ///             and listeners and business logic will handle announcements and UX control.  This decouples the error,
    ///             captures the error, allows for navigation commands and popup views to be displayed micro-seconds later.
    ///             Modularization and de-coupling errors.
    override func main() {
        
        guard !isCancelled else { return }

        let managedContext =  DataFlowFunnel.shared.getPersistentContainerRef().viewContext
        
        print("Framework Context PersistentContainer viewContext ConcurrencyType: ")
        switch (managedContext.concurrencyType){
            case .mainQueueConcurrencyType:
                print("         .mainQueueConcurrencyType")
            case .privateQueueConcurrencyType:
                print("         .privateQueueConcurrencyType")
            case .confinementConcurrencyType:
                print("         .confinementConcurrencyType")
            @unknown default:
                fatalError()
        }
        
        let managedContext1 =  DataFlowFunnel.shared.getPersistentContainerRef().viewContext
        let fetchRequest = NSFetchRequest<ErrorLogs>(entityName: "ErrorLogs")
        managedContext1.performAndWait {
            do{
                print("Framework description call all ErrorLogs description")
                let errorlogs = try managedContext1.fetch(fetchRequest)
                for (index, singleLog) in errorlogs.enumerated()
                {
                    print("------- Single ErrorLog ----------")
                    print("ErrorLog at location index == \(index):")
                    print("     singleLog.errorDescription == \(String(describing: singleLog.errorDescription))" )
                    print("     singleLog.timeStamp == \(String(describing: singleLog.timeStamp))" )
                    print("     singleLog.type == \(String(describing: singleLog.type))" )
                }
                print("----------------------")
            } catch {
                let fetchError = error as NSError
                let msg = "FetchAndDescribeDataOperation Unable to perform NSFetchRequest<ErrorLogs>(entityName: 'ErrorLogs'): \(fetchError), \(fetchError.localizedDescription)"
                DataFlowFunnel.shared.addOperation(LogErrorOperation(initErrorDesc: msg, type: 1, whenItOccured: Date()))
            }
        }
        
        let fetchRequestGarments = NSFetchRequest<Garments>(entityName: "Garments")
        managedContext.performAndWait {
            do{
                
                print("Framework description call on Garments entity")
                let garments = try managedContext.fetch(fetchRequestGarments)
                for (index, garmentRecord) in garments.enumerated()
                {
                    print("     ---------- A Garment ------------")
                    print("     Garments at location index == \(index):")
                    print("         garmentRecord.name in Garments = \(String(describing: garmentRecord.name ))")
                    print("         garmentRecord.timeStamp  in Garments = \(String(describing: garmentRecord.timeStamp ))")
                    print("     ----------------------")
                }
                
            }catch {
                
                let fetchError = error as NSError
                let msg = "FetchAndDescribeDataOperation Unable to perform NSFetchRequest<Garments>: \(fetchError), \(fetchError.localizedDescription)"
                DataFlowFunnel.shared.addOperation(LogErrorOperation(initErrorDesc: msg, type: 2, whenItOccured: Date()))
                
            }
            
        }
        
    }
    
    
}
