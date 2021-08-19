//
//  XCTestAddGarmentNameOperation.swift
//  AddGarment
//
//  Created by Matthew Ferguson on 8/14/21.
//

import Foundation
import CoreData
import DataFlowFunnelCD



/// A view that displays one or more lines of read-only text. [...]
/// UITableViewDelegate conformance
final class XCTestAddGarmentNameOperation: Operation
{
    
    var stagedNameToAdd:String
    
    init( initName: String) {
        self.stagedNameToAdd = initName
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
    
        let managedContext = DataFlowFunnel.shared.getBackgroundManagedObjectContextRef()
        let newGarment:Garments = Garments(context: managedContext)
    
        ///init properties
        newGarment.name = self.stagedNameToAdd
        newGarment.timeStamp = Date()

        managedContext.performAndWait
        {
            do{
                try managedContext.save()
            } catch {
                
                let fetchError = error as NSError
                let msg = "Error on save of the Garments MO in XCTestAddGarmentNameOperation: \(fetchError), \(fetchError.localizedDescription)"
                DataFlowFunnel.shared.addOperation(LogErrorOperation(initErrorDesc: msg, type: 1, whenItOccured: Date()))
                
            }
        }
        managedContext.reset()

    }

}
