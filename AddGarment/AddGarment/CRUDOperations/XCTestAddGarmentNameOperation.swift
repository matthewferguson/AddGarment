//
//  XCTestAddGarmentNameOperation.swift
//  AddGarment
//
//  Created by Matthew Ferguson on 8/14/21.
//

import Foundation
import CoreData
import DataFlowFunnelCD




final class XCTestAddGarmentNameOperation: Operation
{
    
    var stagedNameToAdd:String
    
    init( initName: String) {
        self.stagedNameToAdd = initName
        super.init()
    }
    
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
