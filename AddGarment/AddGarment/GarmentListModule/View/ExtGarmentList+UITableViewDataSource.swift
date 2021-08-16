//
//  ExtGarmentList+UITableViewDataSource.swift
//  AddGarment
//
//  Created by Matthew Ferguson on 8/12/21.
//

import Foundation
import UIKit

/// A view that displays one or more lines of read-only text. [...]
/// UITableViewDelegate conformance
extension GarmentList: UITableViewDataSource {
    
    /// <#Description#>
    ///
    /// - Parameter value: <#value description#>
    /// - Returns: <#return value description#>
  func tableView(_ tableView: UITableView,numberOfRowsInSection section: Int) -> Int {
    return garments.count
  }
  
    /// <#Description#>
    ///
    /// - Parameter value: <#value description#>
    /// - Returns: <#return value description#>
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



