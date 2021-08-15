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

class GarmentAdd : UIViewController {
    
    @IBOutlet var inputGarmentName:UITextField!
    var stagedGarmentName:String = String()
    @IBOutlet var saveBarButton: UIBarButtonItem!

    override func viewDidLoad() {
        inputGarmentName?.delegate = self
        customizeTheSubviews()
    }
 
    
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
    
    @IBAction func saveGarmentName() {
        
        print("saveGarmentName = '\(stagedGarmentName)' ")
        saveBarButton.isEnabled = false
        DataFlowFunnel.shared.addOperation(AddGarmentNameOperation(initName: stagedGarmentName))
        DataFlowFunnel.shared.addOperation(FetchAndDescribeDataOperation()) // BUZ debug
        dismiss(animated: true, completion: nil)
    }
    
}



extension GarmentAdd: UITextFieldDelegate {
    
    
    //MARK:- TextField Delegate
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        //print("textFieldDidChangeSelection=\(textField.text!)")
        stagedGarmentName = textField.text!
        if stagedGarmentName.isEmpty {
            saveBarButton.isEnabled = false
        } else {
            saveBarButton.isEnabled = true
        }
    }
    
  /*
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool
    {
        print(range)
        print(string)
        print(textField.text!)
        return true;
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        print("textFieldShouldBeginEditing")
        print("textField name = \(String(describing: textField.text))")
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        print("textFieldDidBeginEditing")
        print("textField name = \(String(describing: textField.text))")
    }

    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        print("textFieldDidEndEditing")
        print("textField name = \(String(describing: textField.text))")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        print("textFieldShouldReturn")
        print("textField name = \(String(describing: textField.text))")
        textField.resignFirstResponder()
        return true
    }
 */
    
}

