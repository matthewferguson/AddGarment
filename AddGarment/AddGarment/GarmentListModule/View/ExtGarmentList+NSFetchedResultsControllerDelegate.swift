//
//  ExtGarmentList+CoreData.swift
//  AddGarment
//
//  Created by Matthew Ferguson on 8/12/21.
//

import Foundation
import CoreData
import DataFlowFunnelCD

/// extension of the GarmentList object to conform to
/// the Fetch Results Controller Delegate
/// NSFetchedResultsControllerDelegate conformance
extension GarmentList: NSFetchedResultsControllerDelegate {
    
    
    /// Protocal/Delegate function supporting the NSFetchedResultsControllerDelegate
    ///
    /// - Parameter value: https://developer.apple.com/documentation/coredata/nsfetchedresultscontrollerdelegate/1622296-controller
    /// - Returns: none
    public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?)
    {
        switch (type) {
            case .insert:
                switch anObject {
                    case let garmentInsert as Garments:
                        let garmentNode = GarmentNode(garmentName: garmentInsert.name! )
                        DispatchQueue.main.async {
                            self.addToGarments(with: garmentNode)
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

