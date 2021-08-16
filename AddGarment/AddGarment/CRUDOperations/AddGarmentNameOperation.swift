//
//  AddGarmentNameOperation.swift
//  AddGarment
//
//  Created by Matthew Ferguson on 8/14/21.
//

import Foundation
import CoreData
import DataFlowFunnelCD

/// A view that displays one or more lines of read-only text. [...]
/// UITableViewDelegate conformance
final class AddGarmentNameOperation: Operation {
    
    
    /// [This property is] the text color of the label.
    var stagedNameToAdd:String
    
    
    /// <#Description#>
    ///
    /// - Parameter value: <#value description#>
    /// - Returns: <#return value description#>
    init( initName: String) {
        self.stagedNameToAdd = initName
        super.init()
    }
    
    /// <#Description#>
    ///
    /// - Parameter value: <#value description#>
    /// - Returns: <#return value description#>
    override func main() {
        
        guard !isCancelled else { return }
        
            let managedContext = DataFlowFunnel.shared.getPersistentContainerRef().viewContext
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
                    let msg = "Error on saving the Garments MO in AddGarmentNameOperation: \(fetchError), \(fetchError.localizedDescription)"
                    DataFlowFunnel.shared.addOperation(LogErrorOperation(initErrorDesc: msg, type: 2, whenItOccured: Date()))
                    
                }
            }
            managedContext.reset()
    }
}
