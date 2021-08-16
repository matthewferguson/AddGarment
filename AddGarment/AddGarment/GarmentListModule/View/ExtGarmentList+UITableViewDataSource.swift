//
//  ExtGarmentList+UITableViewDataSource.swift
//  AddGarment
//
//  Created by Matthew Ferguson on 8/12/21.
//

import Foundation
import UIKit

/// Extension for UITableViewDataSource conformance.  Extends the building of the table view.
/// UITableViewDataSource conformance
extension GarmentList: UITableViewDataSource {
    
    /// numberOfRowsInSection - sets the number inside the data source.
    ///
    /// - Parameter value: tableview, section
    /// - Returns: integer count within the data source
  func tableView(_ tableView: UITableView,numberOfRowsInSection section: Int) -> Int {
    return garments.count
  }
  
    /// cellForRowAt constructs the individual Custome Garment Cells.  Receives a call back for each cell.
    ///
    /// - Parameter value: tableView, indexPath
    /// - Returns: UITableViewCell
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    var cell = self.garmentTableView?.dequeueReusableCell(withIdentifier: "CustomGarmentListCell_SBID") as? GarmentListCustomCell
    if cell == nil {
        cell = UITableViewCell(style:.default, reuseIdentifier:"CustomGarmentListCell_SBID") as? GarmentListCustomCell
    }
    let singleGarment = self.garments[indexPath.item]
    cell?.garmentName.text = singleGarment.garmentName
    return cell!
  }
    
}



