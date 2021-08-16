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


/// A view that displays one or more lines of read-only text. [...]
/// UITableViewDelegate conformance
extension GarmentAdd: UITextFieldDelegate {

    //MARK:- TextField Delegate
    
    /// <#Description#>
    ///
    /// - Parameter value: <#value description#>
    /// - Returns: <#return value description#>
    func textFieldDidChangeSelection(_ textField: UITextField) {
        stagedGarmentName = textField.text!
        if stagedGarmentName.isEmpty {
            saveBarButton.isEnabled = false
        } else {
            saveBarButton.isEnabled = true
        }
    }
    
}

