//
//  GarmentListCustomCell.swift
//  AddGarment
//
//  Created by Matthew Ferguson on 8/12/21.
//

import Foundation
import UIKit

/// A view that displays one or more lines of read-only text. [...]
/// UITableViewDelegate conformance
public class GarmentListCustomCell: UITableViewCell {
    
    /// [This property is] the text color of the label.
    @IBOutlet var garmentName:UILabel!
    
    /// <#Description#>
    ///
    /// - Parameter value: <#value description#>
    /// - Returns: <#return value description#>
    override public func prepareForReuse() {
        super.prepareForReuse()
    }
    
}
