//
//  ExtGarmentList+CoreData.swift
//  AddGarment
//
//  Created by Matthew Ferguson on 8/12/21.
//

import Foundation
import CoreData
import DataFlowFunnelCD

extension GarmentList: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        //print("CharacterList: controllerWillChangeContent")
        self.garmentTableView.beginUpdates()
    }
    
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        //this area can be used to update UI
       //print("CharacterList: controllerDidChangeContent")
        self.garmentTableView.endUpdates()
    }
    
    
    public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?)
    {
        switch (type) {
            case .insert:
                switch anObject {
                    case let garmentInsert as Garment:
                        
                        let garmentNode = GarmentNode(garmentName: garmentInsert.name)
                        
                        DispatchQueue.main.async {
                            self.addToGarments(with: garmentNode, sortCmd: self.isSortedByAlpha)
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

