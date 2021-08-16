//
//  ErrorLogDemarcation.swift
//  AddGarment
//
//  Created by Matthew Ferguson on 8/15/21.
//

import Foundation
import CoreData
import DataFlowFunnelCD

class ErrorLogDemarcation : NSObject {
    
    fileprivate lazy var fetchAllErrorLogsRequestController: NSFetchedResultsController<ErrorLogs> = {
         let fetchRequestForLogs: NSFetchRequest<ErrorLogs> = ErrorLogs.fetchRequest()
        
         let sortDescriptor = NSSortDescriptor(key: "type", ascending:true)
        fetchRequestForLogs.sortDescriptors = [sortDescriptor]
        
         //Initialize Fetched Results Controller
         let fetchAllErrorLogRecordRequest = NSFetchedResultsController(
             fetchRequest: fetchRequestForLogs,
             managedObjectContext:DataFlowFunnel.shared.getPersistentContainerRef().viewContext,
             sectionNameKeyPath: nil,
             cacheName: nil)

        fetchAllErrorLogRecordRequest.delegate = self
         return fetchAllErrorLogRecordRequest
    }()
    
    
    override init(){
        super.init()
        self.setupFetchControllersDemarc()
    }
    
    
    private func setupFetchControllersDemarc() {
        
        do {
            try self.fetchAllErrorLogsRequestController.performFetch()
            let priorityErrorCollection = self.fetchAllErrorLogsRequestController.fetchedObjects!
            for (singleErrorMsg) in priorityErrorCollection {
                print("ERRORLOG AddGarment Received == \(String(describing: singleErrorMsg.timeStamp)) : Level Type == \(singleErrorMsg.type) : Error Message == \(String(describing: singleErrorMsg.errorDescription))")
            }
        } catch {
            let fetchError = error as NSError
            let msg = "ErrorLogDemarcation Unable to Perform fetchAllErrorLogsRequestController: \(fetchError), \(fetchError.localizedDescription)"
            DataFlowFunnel.shared.addOperation(LogErrorOperation(initErrorDesc: msg, type: 2, whenItOccured: Date()))
        }
    }

    
}
