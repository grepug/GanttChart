//
//  GanttChartCollectionViewLayoutAttributes.swift
//  gantt-test
//
//  Created by Kai on 2022/3/1.
//

import UIKit

final class GanttChartCollectionViewLayoutAttributes: UICollectionViewLayoutAttributes {
    var showingLabelOnItemCell = false
    var itemCellLabelOffsetX: CGFloat = 0
    
    override func copy(with zone: NSZone?) -> Any {
        guard let copiedAttributes = super.copy(with: zone) as? GanttChartCollectionViewLayoutAttributes else {
            return super.copy(with: zone)
        }
        
        copiedAttributes.showingLabelOnItemCell = showingLabelOnItemCell
        copiedAttributes.itemCellLabelOffsetX = itemCellLabelOffsetX
        return copiedAttributes
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let otherAttributes = object as? GanttChartCollectionViewLayoutAttributes else {
            return false
        }
        
        if otherAttributes.showingLabelOnItemCell != showingLabelOnItemCell ||
            otherAttributes.itemCellLabelOffsetX != itemCellLabelOffsetX {
            return false
        }
        
        return super.isEqual(object)
    }
}
