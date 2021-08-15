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
        
        print("XCTestAddGarmentNameOperation adding a Garments Entry == \(stagedNameToAdd)")
        let managedContext = DataFlowFunnel.shared.getBackgroundManagedObjectContextRef()
        let newGarment:Garments = Garments(context: managedContext)
    
        ///init properties
        newGarment.name = self.stagedNameToAdd
        newGarment.timeStamp = Date()

        managedContext.performAndWait
        {
            do{
                print("AddGarmentNameOperation save()");
                try managedContext.save()
            } catch let error as NSError {
                print("Error on saving the Garments MO in AddGarmentNameOperation: == \(error),\(error.userInfo)")
            }
        }
        managedContext.reset()

    }

}
