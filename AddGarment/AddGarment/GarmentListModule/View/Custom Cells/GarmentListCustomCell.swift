//
//  GarmentListCustomCell.swift
//  AddGarment
//
//  Created by Matthew Ferguson on 8/12/21.
//

import Foundation
import UIKit

/// A view that represents a cell in a list
/// UITableViewCell conformance
public class GarmentListCustomCell: UITableViewCell {
    
    /// garmentName is the Label and label text shown within the cell view.
    @IBOutlet var garmentName:UILabel!
    
    /// PrepareForReuse is a caching request to manage the memory for view.
    /// Helps reduce the reloading of cells if not necessary.
    ///
    /// - Parameter value: none
    /// - Returns: none
    override public func prepareForReuse() {
        super.prepareForReuse()
    }
    
}
