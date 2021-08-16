//
//  ExtErrorLog+NSFetchedResultsControllerDelegate.swift
//  AddGarment
//
//  Created by Matthew Ferguson on 8/15/21.
//

import Foundation
import CoreData
import DataFlowFunnelCD

/// A view that displays one or more lines of read-only text. [...]
/// UITableViewDelegate conformance
extension ErrorLogDemarcation: NSFetchedResultsControllerDelegate {
    
    
    /// <#Description#>
    ///
    /// - Parameter value: <#value description#>
    /// - Returns: <#return value description#>
    public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?)
    {
        switch (type) {
            case .insert:
                switch anObject {
                    case let errorlogInsert as ErrorLogs:
                        DispatchQueue.main.async {
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
