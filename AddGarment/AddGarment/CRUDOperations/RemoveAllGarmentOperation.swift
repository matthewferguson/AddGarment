//
//  RemoveAllGarmentOperation.swift
//  AddGarment
//
//  Created by Matthew Ferguson on 8/14/21.
//

import Foundation
import CoreData
import DataFlowFunnelCD


final class RemoveAllGarmentOperation: Operation {
    
    //var stagedNamesToAddCollection:[String] = []
    
    override init(){
        super.init()
    }
    
    
    /*init( initNames: [String]) {
        super.init()//BUZ this might need to go after init of properties, or main launches on operation
        self.stagedNamesToAddCollection = Array(initNames)
    }*/
    
    override func main() {
        
        guard !isCancelled else { return }
        
        let moc = DataFlowFunnel.shared.getBackgroundManagedObjectContextRef()
        //let moc = DataFlowFunnel.shared.getPersistentContainerRef().viewContext
        let fetchRequestUser : NSFetchRequest<Garments> = Garments.fetchRequest()
        moc.performAndWait {
            do{
                let resultsArray:Array<Garments> = try fetchRequestUser.execute()
                //let resultsArray = try fetchRequestUser.execute()
                for singleGarment in resultsArray {
                    moc.delete(singleGarment)
                    try moc.save()
                }
            } catch let error as NSError {
                print("Could not execute AppDelegate::fetchRequestUser. \(error), \(error.userInfo)")
            }
        }
        moc.reset()
        
    }
}
