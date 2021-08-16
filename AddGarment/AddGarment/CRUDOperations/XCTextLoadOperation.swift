//
//  XCTextLoadOperation.swift
//  AddGarment
//
//  Created by Matthew Ferguson on 8/14/21.
//

import Foundation
import CoreData
import DataFlowFunnelCD



/// A view that displays one or more lines of read-only text. [...]
/// UITableViewDelegate conformance
final class XCTextLoadOperation: Operation {
    
    /// [This property is] the text color of the label.
    var stagedNamesToAddCollection:[String] = []
    /// <#Description#>
    ///
    /// - Parameter value: <#value description#>
    /// - Returns: <#return value description#>
    init( initNames: [String]) {
        self.stagedNamesToAddCollection = Array(initNames)
        super.init()
    }
    /// <#Description#>
    ///
    /// - Parameter value: <#value description#>
    /// - Returns: <#return value description#>
    override func main() {
        
        guard !isCancelled else { return }
        for (singleGarmentName) in stagedNamesToAddCollection {
            DataFlowFunnel.shared.addOperation(XCTestAddGarmentNameOperation(initName: singleGarmentName))
        }
        
    }
}
