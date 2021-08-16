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

/// A view that displays one or more lines of read-only text. [...]
/// UITableViewDelegate conformance
class GarmentAdd : UIViewController {
    
    /// [This property is] the text color of the label.
    @IBOutlet var inputGarmentName:UITextField!
    var stagedGarmentName:String = String()
    @IBOutlet var saveBarButton: UIBarButtonItem!

    
    /// <#Description#>
    ///
    /// - Parameter value: <#value description#>
    /// - Returns: <#return value description#>
    override func viewDidLoad() {
        inputGarmentName?.delegate = self
        customizeTheSubviews()
    }
 
    /// <#Description#>
    ///
    /// - Parameter value: <#value description#>
    /// - Returns: <#return value description#>
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
    
    
    
    /// <#Description#>
    ///
    /// - Parameter value: <#value description#>
    /// - Returns: <#return value description#>
    @IBAction func saveGarmentName() {
        
        saveBarButton.isEnabled = false
        DataFlowFunnel.shared.addOperation(AddGarmentNameOperation(initName: stagedGarmentName))
        //DataFlowFunnel.shared.addOperation(FetchAndDescribeDataOperation()) // BUZ debug
        dismiss(animated: true, completion: nil)
    
    }
    
}
