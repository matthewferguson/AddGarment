//
//  XCTestRemoveAllGarmentOperation.swift
//  AddGarment
//
//  Created by Matthew Ferguson on 8/14/21.
//

import Foundation
import CoreData
import DataFlowFunnelCD


final class XCTestRemoveAllGarmentOperation: Operation {
    
    override init(){
        super.init()
    }
    
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
            } catch let error as NSError {
                print("Could not execute AppDelegate::fetchRequestUser. \(error), \(error.userInfo)")
            }
        }
        moc.reset()
        
    }
}
