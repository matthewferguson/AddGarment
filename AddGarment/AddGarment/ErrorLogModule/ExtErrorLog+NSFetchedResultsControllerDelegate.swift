//
//  ExtErrorLog+NSFetchedResultsControllerDelegate.swift
//  AddGarment
//
//  Created by Matthew Ferguson on 8/15/21.
//

import Foundation
import CoreData
import DataFlowFunnelCD

/// extension of the ErrorLogDemarcation object to conform to
/// the Fetch Results Controller Delegate
/// NSFetchedResultsControllerDelegate conformance
extension ErrorLogDemarcation: NSFetchedResultsControllerDelegate {
    
    
    /// Protocal/Delegate function supporting the NSFetchedResultsControllerDelegate
    ///
    /// - Parameter value: https://developer.apple.com/documentation/coredata/nsfetchedresultscontrollerdelegate/1622296-controller
    /// - Returns: none
    public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?)
    {
        switch (type) {
            case .insert:
                switch anObject {
                    case let errorlogInsert as ErrorLogs:
                        DispatchQueue.main.async {
                            /// normally this would be a spot to send logs of errors over the network, but print is sufficient for
                            ///  for a short-term coding project.
                            print("ErrorLog Received == \(String(describing: errorlogInsert.timeStamp)) : Level Type == \(errorlogInsert.type) : Error Message == \(String(describing: errorlogInsert.errorDescription))")
                        }
                    break
                    default:
                    break
                }
            break //.insert
            
            case .update:
            break //.update
        
            case .delete:
            break//.delete

            case .move:
            break //.move

            @unknown default:
                fatalError()
        }
    }
}
