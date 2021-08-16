//
//  XCTestRemoveAllGarmentOperation.swift
//  AddGarment
//
//  Created by Matthew Ferguson on 8/14/21.
//

import Foundation
import CoreData
import DataFlowFunnelCD

/// A view that displays one or more lines of read-only text. [...]
/// UITableViewDelegate conformance
final class XCTestRemoveAllGarmentOperation: Operation {
    
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
        
        let moc = DataFlowFunnel.shared.getBackgroundManagedObjectContextRef()
        let fetchRequestUser : NSFetchRequest<Garments> = Garments.fetchRequest()
        moc.performAndWait {
            do{
                let resultsArray:Array<Garments> = try fetchRequestUser.execute()
                for singleGarment in resultsArray {
                    moc.delete(singleGarment)
                    try moc.save()
                }
            } catch {
                
                let fetchError = error as NSError
                let msg = "XCTestRemoveAllGarmentOperation Error on delete/save of the Garments MO after NSFetchRequest<Garments>: \(fetchError), \(fetchError.localizedDescription)"
                DataFlowFunnel.shared.addOperation(LogErrorOperation(initErrorDesc: msg, type: 1, whenItOccured: Date()))
                
            }
        }
        moc.reset()
        
    }
}
