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
        super.init()//BUZ this might need to go after init of properties, or main launches on operation
        self.stagedNamesToAddCollection = Array(initNames)
        print( self.stagedNamesToAddCollection )
    }
    
    override func main() {
        
        guard !isCancelled else { return }
        for (singleGarmentName) in stagedNamesToAddCollection {
            //_ = index
            print(singleGarmentName)
            //print(index)
            DataFlowFunnel.shared.addOperation(AddGarmentNameOperation(initName: singleGarmentName))
        
        }
        
    }
}
