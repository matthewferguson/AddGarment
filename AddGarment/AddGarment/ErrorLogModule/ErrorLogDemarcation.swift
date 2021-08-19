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
    ///
    /// Try-Catch: If an error is thrown the catch will capture the error description, assign a type level integer for UX
    ///             or analytics data flow into web services, take a timeStamp, and place this into a DataFlowFunnelCD
    ///             Operation. This error will be placed in persistence and listeners and business logic will handle
    ///             announcements and UX control from various locations within the bundle. This decouples the error,
    ///             captures the error, allows for navigation commands and popup
    ///             views to be displayed micro-seconds later. Basically de-coupling errors from the catch.
    private func setupFetchControllersDemarc() {
        
        do {
            try self.fetchAllErrorLogsRequestController.performFetch()
            let priorityErrorCollection = self.fetchAllErrorLogsRequestController.fetchedObjects!
            for (singleErrorMsg) in priorityErrorCollection {
                /// normally this would be a spot to send logs of errors over the network, but print is sufficient for
                ///  for a short-term coding project. 
                print("ERRORLOG AddGarment Received == \(String(describing: singleErrorMsg.timeStamp)) : Level Type == \(singleErrorMsg.type) : Error Message == \(String(describing: singleErrorMsg.errorDescription))")
            }
        } catch {
            let fetchError = error as NSError
            let msg = "ErrorLogDemarcation Unable to Perform fetchAllErrorLogsRequestController: \(fetchError), \(fetchError.localizedDescription)"
            DataFlowFunnel.shared.addOperation(LogErrorOperation(initErrorDesc: msg, type: 2, whenItOccured: Date()))
        }
    }

    
}
