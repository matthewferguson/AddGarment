//
//  GarmentAdd.swift
//  AddGarment
//
//  Created by Matthew Ferguson on 8/13/21.
//

import Foundation
import UIKit
import CoreData
import DataFlowFunnelCD

/// A view and view controller to allow for a new garment name to be added to the data flow.
/// UIViewController conformance
class GarmentAdd : UIViewController {
    
    /// interface builder connected input text field.
    @IBOutlet var inputGarmentName:UITextField!
    /// central location of staged garment name, String, being added.
    var stagedGarmentName:String = String()
    /// save button located on the navigation bar
    @IBOutlet var saveBarButton: UIBarButtonItem!

    
    /// As part of UIViewController, allows for view and subcomponent setup
    ///
    /// - Parameter value: na
    /// - Returns: na
    override func viewDidLoad() {
        inputGarmentName?.delegate = self
        customizeTheSubviews()
    }
 
    /// Customize the navigation bar, save button, and run-time updated garment
    /// name/save button enabled is set
    ///
    /// - Parameter value: none
    /// - Returns: none
    private func customizeTheSubviews(){
    
        navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.black,
            .font: UIFont(name: "Noteworthy-Bold", size: 15)!
        ]
        
        saveBarButton.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.blue, NSAttributedString.Key.font: UIFont(name: "Noteworthy-Bold", size: 15.0)!], for: .normal)
        
        saveBarButton.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.blue, NSAttributedString.Key.font: UIFont(name: "Noteworthy-Bold", size: 15.0)!], for: .selected)
        
        saveBarButton.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont(name: "Noteworthy-Bold", size: 15.0)!], for: .disabled)
        
        if stagedGarmentName.isEmpty {
            saveBarButton.isEnabled = false
        } else {
            saveBarButton.isEnabled = true
        }
        
    }
    
    
    
    /// IB connection save action.  This is the receiving action function starting a save.
    /// changes the save button state, addOperation to be loaded onto the DataFlowFunnel for data flow changes.
    ///
    /// - Parameter value: none
    /// - Returns: none, but loads a save on the core data stack as an insert. 
    @IBAction func saveGarmentName() {
        
        saveBarButton.isEnabled = false
        DataFlowFunnel.shared.addOperation(AddGarmentNameOperation(initName: stagedGarmentName))
        //DataFlowFunnel.shared.addOperation(FetchAndDescribeDataOperation()) // BUZ debug
        dismiss(animated: true, completion: nil)
    
    }
    
}
