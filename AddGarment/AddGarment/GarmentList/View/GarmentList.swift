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

class GarmentList : UIViewController, UITableViewDelegate {
    
    @IBOutlet var garmentTableView: UITableView?
    
    @IBOutlet weak var sortFilterSegmentControl: UISegmentedControl!
    @IBOutlet var addBarButton: UIBarButtonItem?
    
    var garments: [GarmentNode] = []
    
    var isSortedByAlpha:Bool = true
    
    var contentionProtectionQueue:OperationQueue = OperationQueue()
    var reduceReloadQueue:OperationQueue = OperationQueue()
    
    //MARK:- View Controller Lifecycle
    
    override func viewDidLoad() {
        self.garments.removeAll()
        self.garmentTableView?.delegate = self
        
        contentionProtectionQueue.maxConcurrentOperationCount = 1
        reduceReloadQueue.maxConcurrentOperationCount = 1
        setupFetchControllers()
        setupSubViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    //MARK:- View Customization
    
    private func setupSubViews() {
        
        sortFilterSegmentControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont(name: "Noteworthy-Bold", size: 13.0)!], for: .normal)
 
        sortFilterSegmentControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont(name: "Noteworthy-Bold", size: 13.0)!], for:.selected)

        sortFilterSegmentControl.selectedSegmentIndex = 0
        
        self.sortFilterSegmentControl.addTarget(self, action: #selector(sortCommandChange(sender:)), for: .valueChanged)
        
        
        
        // initial setup
        self.isSortedByAlpha = true
        
        self.navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.black,
            .font: UIFont(name: "Noteworthy-Bold", size: 18)!
        ]
        
    }

    //MARK:- Segment Control Support
    
    @IBAction func sortCommandChange(sender:UISegmentedControl) {
        
        let selectedIndex = sender.selectedSegmentIndex
        if selectedIndex == 0 {
            self.isSortedByAlpha = true
            print("self.isSortedByAlpha = true")
            self.reSortDataSource()
        } else {
            self.isSortedByAlpha = false
            print("self.isSortedByAlpha = false")
            self.reSortDataSource()
        }
        
    }

    //MARK:- Data Source Support
    
    private func reSortDataSource()
    {
        ///place on the queue
        let reSortDataSourceOperation = BlockOperation { [self] in
            
            if self.isSortedByAlpha {
                
                let managedContextCharacter =  DataFlowFunnel.shared.getPersistentContainerRef().viewContext
                let fetchRequest = NSFetchRequest<Garments>(entityName: "Garments")
                
                let sortDescriptor = NSSortDescriptor(key: "name", ascending:true)
                fetchRequest.sortDescriptors = [sortDescriptor]
                
                managedContextCharacter.performAndWait {
                    
                    do{
                        print("Garment description call all Garment description")
                        let collectionGarments = try managedContextCharacter.fetch(fetchRequest)
                        print("collectionGarments count = \(collectionGarments.count)")
                        
                        if collectionGarments.count > 0 {
                            //garments.removeAll()
                        }
            
                        for (index, singleGarment) in collectionGarments.enumerated() {
                            print("------- Single Garment ----------")
                            print("Garment at location index == \(index):")
                            print("     singleGarment.singleGarment.name == \(String(describing: singleGarment.name))" )
                            print("     singleGarment.singleGarment.timeStamp == \(singleGarment.timeStamp! as Date)" )
                            print("----------------------")
                            
                            let sg = GarmentNode(garmentName: singleGarment.name )
                            self.garments.append(sg)
                            
                            self.garmentTableView!.beginUpdates()
                            self.garmentTableView!.insertRows(at: [IndexPath(row: garments.count-1, section: 0)], with: .automatic)
                            self.garmentTableView!.endUpdates()
                            
                            
                        }
                    } catch let error as NSError {
                        print("Failed to execute. \(error), \(error.userInfo)")
                    }
                }
                //BUZ let count = self.reduceReloadQueue.operationCount
                /*
                if (self.reduceReloadQueue.operationCount <= 0) {
                    let reloadTableView = BlockOperation {
                        DispatchQueue.main.async {
                            self.garmentTableView?.reloadData()
                        }
                    }
                    self.reduceReloadQueue.addOperation(reloadTableView)
                }
                 */
                
                //print("try")
            } else {
                
                
                let managedContextCharacter =  DataFlowFunnel.shared.getPersistentContainerRef().viewContext
                let fetchRequest = NSFetchRequest<Garments>(entityName: "Garments")
                
                let sortDescriptor = NSSortDescriptor(key: "timeStamp", ascending:false)
                fetchRequest.sortDescriptors = [sortDescriptor]
                
                managedContextCharacter.performAndWait {
                    
                    do{
                        print("Garment description call all Garment description")
                        let collectionGarments = try managedContextCharacter.fetch(fetchRequest)
                        print("collectionGarments count = \(collectionGarments.count)")
                        
                        if collectionGarments.count > 0 {
                            //garments.removeAll()
                        }
            
                        for (index, singleGarment) in collectionGarments.enumerated() {
                            print("------- Single Garment ----------")
                            print("Garment at location index == \(index):")
                            print("     singleGarment.character_id == \(String(describing: singleGarment.name))" )
                            print("     singleGarment.appearance_array == \(singleGarment.timeStamp!)" )
                            print("----------------------")
                            
                            let sg = GarmentNode(garmentName: singleGarment.name)
                            self.garments.append(sg)
                            
                            
                            self.garmentTableView!.beginUpdates()
                            self.garmentTableView!.insertRows(at: [IndexPath(row: garments.count-1, section: 0)], with: .automatic)
                            self.garmentTableView!.endUpdates()
  
                        }
                    } catch let error as NSError {
                        print("Failed to execute. \(error), \(error.userInfo)")
                    }
                }
                //BUZ
/*                if self.reduceReloadQueue.operationCount == 0 {
                    let reloadTableView = BlockOperation {
                        DispatchQueue.main.async {
                            self.garmentTableView?.reloadData()
                        }
                    }
                    self.reduceReloadQueue.addOperation(reloadTableView)
                }*/
            }
            
        }
        contentionProtectionQueue.addOperation(reSortDataSourceOperation) //add to funnel FIFO
    }
    

    func addToGarments(with garmentNode:GarmentNode, sortCmd sortByAlpha:Bool) {
        
        
        
        self.garments.append(garmentNode)
        self.garmentTableView!.beginUpdates()
        self.garmentTableView!.insertRows(at: [IndexPath(row: garments.count-1, section: 0)], with: .automatic)
        self.garmentTableView!.endUpdates()
        
        //self.reSortDataSource()
    }
    
    
    //MARK:- Core Data Fetch Controller/Event Support
    
    private func setupFetchControllers() {
        do
        {
            
            try self.fetchAllGarmentsRequestController.performFetch()
            let garmentsCollection = self.fetchAllGarmentsRequestController.fetchedObjects!
        
            for (singleGarment) in garmentsCollection {
                let garmentNode = GarmentNode(garmentName: singleGarment.name )
                self.garments.append(garmentNode)
            }
        
            if garments.count > 0 {
                
                self.reSortDataSource()
                //garmentTableView.reloadData()
                //garmentTableView.beginUpdates()
                //garmentTableView.endUpdates()
            }
            
        } catch {
            let fetchError = error as NSError
            print("GarmentNode unable to Perform Fetch Request: \(fetchError), \(fetchError.localizedDescription)")
        }
        
    }
    
    
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
    
    
    //MARK:- Navigation Support
    
    @IBAction func openGarmentAdd(){
        
        let mainView:UIStoryboard = UIStoryboard(name: "GarmentAdd", bundle: nil)
        let myVC = mainView.instantiateViewController(withIdentifier: "GarminAdd_SBID") as! GarmentAdd
        let navController = UINavigationController(rootViewController: myVC)
        self.navigationController?.present(navController, animated: true, completion: nil)
    
        //self.performSegue(withIdentifier: "GarmentList_GarmentAdd_Segue", sender: self)
    }
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "GarmentList_GarmentAdd_Segue"{
            
            /*
            let viewController:SearchCityResult = segue.destination as! SearchCityResult
            viewController.forecastCollection  = self.forecastCollection
            let backItem = UIBarButtonItem()
            backItem.title = searchString
            navigationItem.backBarButtonItem = backItem
             */
            
        }
        
    }
    
    
    
    
    
    

}

