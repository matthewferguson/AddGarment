//
//  FetchAndDescribeData.swift
//  PondFishing
//
//  Created by Matthew Ferguson on 2/17/21.
//

import Foundation
import CoreData
import DataFlowFunnelCD

final class FetchAndDescribeDataOperation: Operation {
    
    override init() {
        super.init()
    }

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
            }catch let error as NSError {
                print("Failed to execute AppDelegate::removeUserData. \(error), \(error.userInfo)")
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
            }catch let error as NSError {
                print("Failed to execute AppDelegate::removeUserData. \(error), \(error.userInfo)")
            }
        }
        
    }
    
    
}
