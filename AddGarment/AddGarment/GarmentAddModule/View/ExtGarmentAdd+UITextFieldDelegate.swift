//
//  ExtGarmentAdd+UITextFieldDelegate.swift
//  AddGarment
//
//  Created by Matthew Ferguson on 8/15/21.
//

import Foundation
import UIKit
import CoreData
import DataFlowFunnelCD


/// extension of the GarmentAdd object to conform to
/// the Text Field Delegate methods to change and
/// capture the staged garment new name.
/// UITextFieldDelegate conformance
extension GarmentAdd: UITextFieldDelegate {

    //MARK:- TextField Delegate
    
    /// Text did change delegate.  grabs the latest inputed garment name.
    /// Manages the save button availability.
    ///
    /// - Parameter value: textField:UITextField updated
    /// - Returns: none
    func textFieldDidChangeSelection(_ textField: UITextField) {
        stagedGarmentName = textField.text!
        if stagedGarmentName.isEmpty {
            saveBarButton.isEnabled = false
        } else {
            saveBarButton.isEnabled = true
        }
    }
    
}

