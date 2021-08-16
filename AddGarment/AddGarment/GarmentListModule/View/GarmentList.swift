//
//  GarmentList.swift
//  AddGarment
//
//  Created by Matthew Ferguson on 8/12/21.
//

import Foundation
import UIKit
import CoreData
import DataFlowFunnelCD

/// A view that displays one or more lines of read-only text. [...]
/// UITableViewDelegate conformance
class GarmentList : UIViewController, UITableViewDelegate {
    
    /// [This property is] the text color of the label.
    @IBOutlet var garmentTableView: UITableView?
    /// [This property is] the text color of the label.
    @IBOutlet weak var sortFilterSegmentControl: UISegmentedControl!
    /// [This property is] the text color of the label.
    @IBOutlet var addBarButton: UIBarButtonItem?
    
    /// [This property is] the text color of the label.
    var garments: [GarmentNode] = []
    /// [This property is] the text color of the label.
    var isSortedByAlpha:Bool = true
    
    /// [This property is] the text color of the label.
    fileprivate lazy var fetchAllGarmentsRequestController: NSFetchedResultsController<Garments> = {
         
        let fetchRequestForGarments: NSFetchRequest<Garments> = Garments.fetchRequest()
         
        let sortDescriptor = NSSortDescriptor(key: "name", ascending:true)
        fetchRequestForGarments.sortDescriptors = [sortDescriptor]
         
        //Initialize Fetched Results Controller
        let fetchGarmentRecordRequest = NSFetchedResultsController(
             fetchRequest: fetchRequestForGarments,
             managedObjectContext:DataFlowFunnel.shared.getPersistentContainerRef().viewContext,
             sectionNameKeyPath: nil,
             cacheName: nil)

        fetchGarmentRecordRequest.delegate = self
        return fetchGarmentRecordRequest
    }()
    
    
    //MARK:- View Controller Lifecycle
    
    /// <#Description#>
    ///
    /// - Parameter value: <#value description#>
    /// - Returns: <#return value description#>
    override func viewDidLoad() {
        
        self.garments.removeAll()
        self.garmentTableView?.delegate = self
        
        setupFetchControllers()
        setupSubViews()
    }
    
    
    //MARK:- View Customization
    
    /// <#Description#>
    ///
    /// - Parameter value: <#value description#>
    /// - Returns: <#return value description#>
    private func setupSubViews() {
        
        self.sortFilterSegmentControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont(name: "Noteworthy-Bold", size: 13.0)!], for: .normal)
 
        self.sortFilterSegmentControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont(name: "Noteworthy-Bold", size: 13.0)!], for:.selected)

        self.sortFilterSegmentControl.selectedSegmentIndex = 0
        
        self.sortFilterSegmentControl.addTarget(self, action: #selector(sortCommandChange(sender:)), for: .valueChanged)
    
        // initial setup
        self.isSortedByAlpha = true
        
        self.navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.black,
            .font: UIFont(name: "Noteworthy-Bold", size: 18)!
        ]
        
    }

    
    //MARK:- Segment Control Support
    
    /// <#Description#>
    ///
    /// - Parameter value: <#value description#>
    /// - Returns: <#return value description#>
    @IBAction func sortCommandChange(sender:UISegmentedControl) {
        
        let selectedIndex = sender.selectedSegmentIndex
        if selectedIndex == 0 {
            self.isSortedByAlpha = true
            self.resortDataSource()
            self.garmentTableView!.reloadData()
        } else {
            self.isSortedByAlpha = false
            self.resortDataSource()
            self.garmentTableView!.reloadData()
        }
        
    }

    
    //MARK:- Data Source Support

    /// <#Description#>
    ///
    /// - Parameter value: <#value description#>
    /// - Returns: <#return value description#>
    private func resortDataSource() {
        
        let managedContextCharacter =  DataFlowFunnel.shared.getPersistentContainerRef().viewContext
        let fetchRequest = NSFetchRequest<Garments>(entityName: "Garments")
        
        // initalize common sortDescriptor
        var sortDescriptor: NSSortDescriptor = NSSortDescriptor()
        
        if self.isSortedByAlpha {
            sortDescriptor = NSSortDescriptor(key: "name", ascending:true)
            fetchRequest.sortDescriptors = [sortDescriptor]
        }else {
            sortDescriptor = NSSortDescriptor(key: "timeStamp", ascending:false)
            fetchRequest.sortDescriptors = [sortDescriptor]
        }
        
        managedContextCharacter.performAndWait {
            do{
                
                let collectionGarments = try managedContextCharacter.fetch(fetchRequest)
                if collectionGarments.count > 0 {
                    garments.removeAll()
                }
                
                for singleGarment in collectionGarments {
                    let singleGarment = GarmentNode(garmentName: singleGarment.name! )
                    self.garments.append(singleGarment)
                }
            } catch {
                let fetchError = error as NSError
                let msg = "GarmentList Unable to perform fetch resortDataSource(): \(fetchError), \(fetchError.localizedDescription)"
                DataFlowFunnel.shared.addOperation(LogErrorOperation(initErrorDesc: msg, type: 2, whenItOccured: Date()))
            }
        }
    }

    
    /// <#Description#>
    ///
    /// - Parameter value: <#value description#>
    /// - Returns: <#return value description#>
    func addToGarments(with garmentNode:GarmentNode) {
        
        DispatchQueue.main.async {
            self.garmentTableView!.beginUpdates()
            self.garments.append(garmentNode)
            self.garmentTableView!.insertRows(at: [IndexPath(row: self.garments.count-1, section: 0)], with: .fade)
            self.garmentTableView!.endUpdates()
        }
        
        DispatchQueue.main.async {
            self.garmentTableView!.beginUpdates()
            self.resortDataSource()
            self.garmentTableView!.endUpdates()
            self.garmentTableView!.reloadData()
        }
        
    }

    
    //MARK:- Core Data Fetch Controller/Event Support
    
    /// <#Description#>
    ///
    /// - Parameter value: <#value description#>
    /// - Returns: <#return value description#>
    private func setupFetchControllers() {
        do {
            try self.fetchAllGarmentsRequestController.performFetch()
            let garmentsCollection = self.fetchAllGarmentsRequestController.fetchedObjects!
            for (singleGarment) in garmentsCollection {
                let garmentNode = GarmentNode(garmentName: singleGarment.name! )
                self.garments.append(garmentNode)
            }
        } catch {
            let fetchError = error as NSError
            let msg = "GarmentList Unable to perform fetchAllGarmentsRequestController.performFetch: \(fetchError), \(fetchError.localizedDescription)"
            DataFlowFunnel.shared.addOperation(LogErrorOperation(initErrorDesc: msg, type: 1, whenItOccured: Date()))
        }
    }
    
    
    //MARK:- Navigation Support
    
    /// <#Description#>
    ///
    /// - Parameter value: <#value description#>
    /// - Returns: <#return value description#>
    @IBAction func openGarmentAdd(){
        
        let mainView:UIStoryboard = UIStoryboard(name: "GarmentAdd", bundle: nil)
        let myVC = mainView.instantiateViewController(withIdentifier: "GarminAdd_SBID") as! GarmentAdd
        let navController = UINavigationController(rootViewController: myVC)
        self.navigationController?.present(navController, animated: true, completion: nil)
    
    }

}
