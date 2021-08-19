//
//  XCTestRemoveAllErrorLogOperation.swift
//  AddGarment
//
//  Created by Matthew Ferguson on 8/14/21.
//

import Foundation
import CoreData
import DataFlowFunnelCD


final class XCTestRemoveAllErrorLogOperation: Operation {
 
    override init(){
        super.init()
    }
    
    
    /// Main entry point running this operation task as a thread
    ///
    /// - Parameter value: none
    /// - Returns: none
    /// Try-Catch: If an error is thrown the catch will capture the error description, assign a type level integer for UX
    ///             or analytics data flow into web services, take a timeStamp, and place this into a DataFlowFunnelCD
    ///             Operation. This error will be placed in persistence and listeners and business logic will handle
    ///             announcements and UX control from various locations within the bundle. This decouples the error,
    ///             captures the error, allows for navigation commands and popup
    ///             views to be displayed micro-seconds later. Basically de-coupling errors from the catch.
    override func main() {
        
        guard !isCancelled else { return }
        
        let moc = DataFlowFunnel.shared.getPersistentContainerRef().viewContext
        let fetchRequestUser : NSFetchRequest<ErrorLogs> = ErrorLogs.fetchRequest()
        moc.performAndWait {
            do{
                let resultsArray:Array<ErrorLogs> = try fetchRequestUser.execute()
                for singleGarment in resultsArray {
                    moc.delete(singleGarment)
                    try moc.save()
                }
            } catch let error as NSError {
                
                let fetchError = error as NSError
                let msg = "Error on delete the ErrorLogs MO in RemoveAllErrorLogOperation: \(fetchError), \(fetchError.localizedDescription)"
                DataFlowFunnel.shared.addOperation(LogErrorOperation(initErrorDesc: msg, type: 2, whenItOccured: Date()))

            }
        }
        
    }
}
