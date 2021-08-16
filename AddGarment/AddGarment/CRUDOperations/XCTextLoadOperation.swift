//
//  XCTextLoadOperation.swift
//  AddGarment
//
//  Created by Matthew Ferguson on 8/14/21.
//

import Foundation
import CoreData
import DataFlowFunnelCD




final class XCTextLoadOperation: Operation {
    
    var stagedNamesToAddCollection:[String] = []
    
    init( initNames: [String]) {
        self.stagedNamesToAddCollection = Array(initNames)
        super.init()
    }
    
    override func main() {
        
        guard !isCancelled else { return }
        for (singleGarmentName) in stagedNamesToAddCollection {
            DataFlowFunnel.shared.addOperation(XCTestAddGarmentNameOperation(initName: singleGarmentName))
        }
        
    }
}
