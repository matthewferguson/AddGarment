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

/// GarmentList displays a sorted list of GarmentNodes.  Allows for
/// user interaction to request filtered sorted lists for display.
/// Also navigation request handled for the add a new garment.
/// UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate conformance
class GarmentList : UIViewController, UITableViewDelegate {
    
    /// garment table view
    @IBOutlet var garmentTableView: UITableView?
    /// segment controller for sort filter requests
    @IBOutlet weak var sortFilterSegmentControl: UISegmentedControl!
    /// navigation bar add garment button controller
    @IBOutlet var addBarButton: UIBarButtonItem?
    
    /// data source of garment list, sorted on command from sort segment control
    var garments: [GarmentNode] = []
    /// State boolean commanding the binary state of sort on the data structure
    var isSortedByAlpha:Bool = true
    
    /// Sets up the core data fetch controllers (subscribes)
    ///
    /// - Parameter value: none
    /// - Returns: none, but initializes the lazy load fetchAllGarmentsRequestController and processes the initial fetch.
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
    
    /// viewDidLoad initalization. init the data source
    /// for table view, table view delegate, setup the fetch controller,
    /// setupSubViews
    ///
    /// - Parameter value: none
    /// - Returns: none
    override func viewDidLoad() {
        
        self.garments.removeAll()
        self.garmentTableView?.delegate = self
        
        setupFetchControllers()
        setupSubViews()
    }
    
    
    //MARK:- View Customization
    
    /// setupSubViews - sort filter segment control look and feel, set the boolean sort variable,
    /// navigation bar font style.
    ///
    /// - Parameter value: none
    /// - Returns: none
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
    
    /// Sort command change delegate segment control callback.
    /// pulls the selection of segment index, then set the state,
    /// re-sort the data source, and reload.
    ///
    /// - Parameter value: a UISegmentedControl
    /// - Returns: none, process data source and sets state logic boolean.
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

    /// re-sort command on core data stack.  This is the crud request with sort discriptors.
    /// fetch the sorted data and load the data source for display on list view.
    ///
    /// - Parameter value: none
    /// - Returns: none, alters the data source from a sorted core data request.
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

    
    /// Add a new Garment as support to handling an insert event (fetch controller)
    ///
    ///
    /// - Parameter value: garmentNode:GarmentNode - node to insert
    /// - Returns: none, alters the view and data source.
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
    
    /// setupFetchControllers sets the fetchAllGarmentsRequestController, and pulls the initial load
    /// of listed garments.
    ///
    /// - Parameter value: none
    /// - Returns: none, pulls all garments
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
    
    /// openGarmentAdd navigates to the modal view GarmentAdd
    ///
    /// - Parameter value: none
    /// - Returns: none, navigation to modal view. 
    @IBAction func openGarmentAdd(){
        
        let mainView:UIStoryboard = UIStoryboard(name: "GarmentAdd", bundle: nil)
        let myVC = mainView.instantiateViewController(withIdentifier: "GarminAdd_SBID") as! GarmentAdd
        let navController = UINavigationController(rootViewController: myVC)
        self.navigationController?.present(navController, animated: true, completion: nil)
    
    }

}

