//
//  XCTestRemoveAllErrorLogOperation.swift
//  AddGarment
//
//  Created by Matthew Ferguson on 8/14/21.
//

import Foundation
import CoreData
import DataFlowFunnelCD

/// A view that displays one or more lines of read-only text. [...]
/// UITableViewDelegate conformance
final class XCTestRemoveAllErrorLogOperation: Operation {
 
    /// <#Description#>
    ///
    /// - Parameter value: <#value description#>
    /// - Returns: <#return value description#>
    override init(){
        super.init()
    }
    
    
    /// <#Description#>
    ///
    /// - Parameter value: <#value description#>
    /// - Returns: <#return value description#>
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
