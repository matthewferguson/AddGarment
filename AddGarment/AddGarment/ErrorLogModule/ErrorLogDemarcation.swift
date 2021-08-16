//
//  ErrorLogDemarcation.swift
//  AddGarment
//
//  Created by Matthew Ferguson on 8/15/21.
//

import Foundation
import CoreData
import DataFlowFunnelCD

/// Demarcation and receiver of ErrorLog. An Object that is used to receive and handle error messages for
/// logging, web services analytics, and other business logic involved.
/// NSObject conformance
class ErrorLogDemarcation : NSObject {
    
    
    /// fetchAllErrorLogsRequestController represents a live event subscription for CRUD operations
    /// on the ErrorLogs table in the core data stack. This is the filtered fetch event for that table.
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
    
    /// Init the object and setup the core data fetch controllers.
    ///
    /// - Parameter value: none
    /// - Returns: void, but initalizes the object
    override init(){
        super.init()
        self.setupFetchControllersDemarc()
    }
    
    /// Sets up the core data fetch controllers (subscribes)
    ///
    /// - Parameter value: none
    /// - Returns: none, but initializes the lazy load fetchAllErrorLogsRequestController and processes the initial fetch. 
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
