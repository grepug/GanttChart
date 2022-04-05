//
//  File.swift
//  
//
//  Created by Kai on 2022/4/5.
//

import Foundation
import UIKit

class GanttChartCollectionViewLayoutSupplementaryViewInvalidationContext: UICollectionViewLayoutInvalidationContext {
    var config: GanttChartConfigurationCache?
    
//    init(config: GanttChartConfigurationCache) {
//        self.config = config
//    }
    
    override var invalidateEverything: Bool {
        true
    }
    
    override var invalidatedSupplementaryIndexPaths: [String : [IndexPath]]? {
        var result: [String: [IndexPath]] = [:]
        
        result[SupplementaryElement.Kind.groupFrame.rawValue] = []
        
        for item in config?.supplementaryElementForGroupFrames() ?? [] {
            result[item.kind.rawValue]?.append(item.indexPath)
        }
        
        
        return result
    }
}
