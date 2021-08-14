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

class GarmentList : UIViewController {
    
    @IBOutlet var garmentTableView: UITableView?
    
    @IBOutlet weak var sortFilterSegmentControl: UISegmentedControl!
    @IBOutlet var addBarButton: UIBarButtonItem?
    
    var garments: [GarmentNode] = []
    
    var isSortedByAlpha:Bool = true
    
    var contentionProtectionQueue:OperationQueue = OperationQueue()
    
    //MARK:- View Controller Lifecycle
    
    override func viewDidLoad() {
        contentionProtectionQueue.maxConcurrentOperationCount = 1
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
        
        
        /*
        if garments.count <= 0 {
            self.garmentTableView?.isHidden = false
        }
        else {
            self.garmentTableView?.isHidden = false
        } */
        
        
        
        
        
        /*
        self.btnLookup?.layer.cornerRadius = 6
        self.btnLookup?.layer.borderWidth = 1
        self.btnLookup?.layer.borderColor = UIColor.getCustomDarkGreyColor().cgColor
        self.btnLookup?.layer.masksToBounds = true
        self.btnLookup?.clipsToBounds = true
        self.btnLookup?.backgroundColor = UIColor.clear
        */
    
        /*
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController?.navigationBar.barTintColor = UIColor.getCustomPurpleColor()
        view.backgroundColor = UIColor.getCustomLightGreyColor()
        */
        
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
                            garments.removeAll()
                        }
            
                        for (index, singleGarment) in collectionGarments.enumerated() {
                            print("------- Single Garment ----------")
                            print("Garment at location index == \(index):")
                            print("     singleGarment.character_id == \(String(describing: singleGarment.name))" )
                            print("     singleGarment.appearance_array == \(singleGarment.timeStamp!)" )
                            print("----------------------")
                            
                            let sg = GarmentNode(garmentName: singleGarment.name, timeStamp: singleGarment.timeStamp)
                            self.garments.append(sg)
                        }
                    } catch let error as NSError {
                        print("Failed to execute. \(error), \(error.userInfo)")
                    }
                }
                
                if self.contentionProtectionQueue.operationCount == 0 {
                    let reload = BlockOperation {
                        self.garmentTableView?.reloadData()
                    }
                    self.contentionProtectionQueue.addOperation(reload)
                }
                
            } else {
                
                
                let managedContextCharacter =  DataFlowFunnel.shared.getPersistentContainerRef().viewContext
                let fetchRequest = NSFetchRequest<Garments>(entityName: "Garments")
                
                let sortDescriptor = NSSortDescriptor(key: "timeStamp", ascending:true)
                fetchRequest.sortDescriptors = [sortDescriptor]
                
                managedContextCharacter.performAndWait {
                    
                    do{
                        print("Garment description call all Garment description")
                        let collectionGarments = try managedContextCharacter.fetch(fetchRequest)
                        print("collectionGarments count = \(collectionGarments.count)")
                        
                        if collectionGarments.count > 0 {
                            garments.removeAll()
                        }
            
                        for (index, singleGarment) in collectionGarments.enumerated() {
                            print("------- Single Garment ----------")
                            print("Garment at location index == \(index):")
                            print("     singleGarment.character_id == \(String(describing: singleGarment.name))" )
                            print("     singleGarment.appearance_array == \(singleGarment.timeStamp!)" )
                            print("----------------------")
                            
                            let sg = GarmentNode(garmentName: singleGarment.name, timeStamp: singleGarment.timeStamp)
                            self.garments.append(sg)
                            
                        }
                    } catch let error as NSError {
                        print("Failed to execute. \(error), \(error.userInfo)")
                    }
                }
                
                if self.contentionProtectionQueue.operationCount == 0 {
                    let reload = BlockOperation {
                        self.garmentTableView?.reloadData()
                    }
                    self.contentionProtectionQueue.addOperation(reload)
                }
            }
            
        }
        contentionProtectionQueue.addOperation(reSortDataSourceOperation) //add to funnel FIFO
    }
    

    func addToGarments(with garmentNode:GarmentNode, sortCmd sortByAlpha:Bool) {
        self.garments.append(garmentNode)
        self.reSortDataSource()
    }
    
    
    //MARK:- Core Data Fetch Controller/Event Support
    
    private func setupFetchControllers() {
        do
        {
            self.garments.removeAll()
            try self.fetchAllGarmentsRequestController.performFetch()
            let garmentsCollection = self.fetchAllGarmentsRequestController.fetchedObjects!
        
            for (singleGarment) in garmentsCollection {
                let garmentNode = GarmentNode(garmentName: singleGarment.name)
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
    
    func openGarmentAdd(){
        self.performSegue(withIdentifier: "GarmentList_GarmentAdd_Segue", sender: self)
    }
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "SearchCity_SearchCityResult_Segue"{
            let viewController:SearchCityResult = segue.destination as! SearchCityResult
            viewController.forecastCollection  = self.forecastCollection
            let backItem = UIBarButtonItem()
            backItem.title = searchString
            navigationItem.backBarButtonItem = backItem
        }
        
    }
    
    
    
    
    
    

}

