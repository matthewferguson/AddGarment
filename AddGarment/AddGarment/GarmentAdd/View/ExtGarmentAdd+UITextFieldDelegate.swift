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

extension GarmentAdd: UITextFieldDelegate {

    //MARK:- TextField Delegate
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        stagedGarmentName = textField.text!
        if stagedGarmentName.isEmpty {
            saveBarButton.isEnabled = false
        } else {
            saveBarButton.isEnabled = true
        }
    }
    
}

