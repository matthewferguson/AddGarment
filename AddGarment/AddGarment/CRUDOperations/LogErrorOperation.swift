//
//  LogErrorOperation.swift
//  AddGarment
//
//  Created by Matthew Ferguson on 8/15/21.
//

import Foundation
import CoreData
import DataFlowFunnelCD

/// Insert a Error Log into the Core Data Stack
/// Operation conformance
final class LogErrorOperation: Operation {
    
    /// error description to log
    var errorDescription:String
    /// error level , can be a priority from a sort on a fetch
    var levelTypeInt:Int64
    /// timeStamp of error
    var timeStamp:Date
    
    init( initErrorDesc: String, type:Int64, whenItOccured:Date) {
        self.errorDescription = initErrorDesc
        self.levelTypeInt = type
        self.timeStamp = whenItOccured
        super.init()
    }
    
    override func main() {
        
        /// [This property is] the text color of the label.
        guard !isCancelled else { return }
        
        // moc or managed object context
        let moc = DataFlowFunnel.shared.getPersistentContainerRef().viewContext
        let newError:ErrorLogs = ErrorLogs(context: moc)
    
        ///init properties
        newError.errorDescription = self.errorDescription
        newError.type = self.levelTypeInt
        newError.timeStamp = self.timeStamp
    
        moc.performAndWait
        {
            do{
                try moc.save()
            } catch {

                let fetchError = error as NSError
                let msg = "Error on saving the Garments MO in AddGarmentNameOperation: \(fetchError), \(fetchError.localizedDescription)"
                DataFlowFunnel.shared.addOperation(LogErrorOperation(initErrorDesc: msg, type: 2, whenItOccured: Date()))
                
            }
        }
        moc.reset()
    
    }
    
}
