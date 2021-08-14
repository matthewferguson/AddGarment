//
//  AddGarmentNameOperation.swift
//  AddGarment
//
//  Created by Matthew Ferguson on 8/14/21.
//

import Foundation
import CoreData
import DataFlowFunnelCD




final class AddGarmentNameOperation: Operation {
    
    var stagedNameToAdd:String?
    
    init( initName: String) {
        self.stagedNameToAdd = initName
        super.init()
    }
    
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
                    print("AddGarmentNameOperation save()");
                    try managedContext.save()
                } catch let error as NSError {
                    print("Error on saving the Garments MO in AddGarmentNameOperation: == \(error),\(error.userInfo)")
                }
            }
            managedContext.reset()
        usleep(500)
    }
}
