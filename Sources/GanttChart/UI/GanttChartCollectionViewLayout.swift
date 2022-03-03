//
//  GanttCollectionViewLayout.swift
//  gantt-test
//
//  Created by Kai on 2022/2/28.
//

import UIKit

class GanttCollectionViewLayout: UICollectionViewLayout {
    typealias Attributes = GanttChartCollectionViewLayoutAttributes
    
    var config: GanttChartConfigurationCache! {
        didSet {
            shouldPrepare = true
        }
    }
    
    override init() {
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var shouldPrepare = false
    private var cachedAttributesArr: [[Attributes]] = []
    private var cachedFrames: [[CGRect]] = []
    private var cachedSupplementaryViewAttributesArr: [SupplementaryElementKind: Attributes] = [:]
    
    func changeOrientation() {
        shouldPrepare = true
    }
    
    override var collectionViewContentSize: CGSize {
        config?.collectionViewContentSize ?? .zero
    }
    
    override func prepare() {
        guard let collectionView = collectionView else {
            return
        }
        
        guard shouldPrepare else { return }
        
        shouldPrepare = false
        cachedAttributesArr.removeAll()
        cachedFrames.removeAll()
        cachedSupplementaryViewAttributesArr.removeAll()
        
        prepareItems(collectionView: collectionView)
        prepareSupplementaryElements()
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        cachedAttributesArr[indexPath.section][indexPath.item]
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let collectionView = collectionView, let config = config else { return nil }
        
        var attributesArr: [UICollectionViewLayoutAttributes] = []
        
        for section in 0..<collectionView.numberOfSections {
            var currentItemCellAttributes: Attributes?
            
            for item in 0..<collectionView.numberOfItems(inSection: section) {
                let indexPath = IndexPath(item: item, section: section)
                let cellType = config.cellType(at: indexPath)
                let attributes = cachedAttributesArr[indexPath.section][indexPath.item]
                let frame = cachedFrames[indexPath.section][indexPath.item]
                
                switch cellType {
                case .fixedFirstCell, .fixedHeaderCell, .fixedHeaderDayCell:
                    let extraOffsetY = cellType == .fixedHeaderDayCell ?
                    config.configuration.fixedHeaderHeight / 2 : 0
                    
                    layoutHeaderCells(attributes: attributes,
                                      initialFrame: frame,
                                      extraOffsetY: extraOffsetY)
                    
                    attributesArr.append(attributes)
                case .itemCell:
                    currentItemCellAttributes = attributes
                    
                    if frame.intersects(rect) {
                        attributesArr.append(attributes)
                    }
                case .itemLabelCell:
                    layoutItemLabelCell(itemCellAttributes: currentItemCellAttributes!,
                                        itemLabelCellOriginalFrame: frame,
                                        itemLabelCellAttributes: attributes,
                                        in: rect,
                                        at: indexPath)
                    
                    attributesArr.append(attributes)
                default:
                    if frame.intersects(rect) {
                        attributesArr.append(attributes)
                    }
                }
            }
        }
        
        for (kind, attributes) in cachedSupplementaryViewAttributesArr {
            if kind == .fixedHeaderDayBackground {
                let initialFrame = config.supplementaryViewFrame(for: kind)
                
                layoutHeaderCells(attributes: attributes,
                                  initialFrame: initialFrame,
                                  extraOffsetY: config.configuration.fixedHeaderHeight / 2)
                attributesArr.append(attributes)
            } else {
                if attributes.frame.intersects(rect) {
                    attributesArr.append(attributes)
                }
            }
        }
        
        return attributesArr
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        true
    }
}

private extension GanttCollectionViewLayout {
    func prepareItems(collectionView: UICollectionView) {
        for section in 0..<collectionView.numberOfSections {
            var sectionArributes: [Attributes] = []
            var sectionFrames: [CGRect] = []
            
            for item in 0..<collectionView.numberOfItems(inSection: section) {
                let indexPath = IndexPath(item: item, section: section)
                let attributes = Attributes(forCellWith: indexPath)
                let frame = config.cellFrame(at: indexPath)
                let cellType = config.cellType(at: indexPath)
                
                attributes.frame = frame
                attributes.zIndex = cellType.zIndex
                
                sectionArributes.append(attributes)
                sectionFrames.append(frame)
            }
            
            cachedAttributesArr.append(sectionArributes)
            cachedFrames.append(sectionFrames)
        }
    }
    
    func prepareSupplementaryElements() {
        for kind in SupplementaryElementKind.allCases {
            let frame = config.supplementaryViewFrame(for: kind)
            let attributes = Attributes(forSupplementaryViewOfKind: kind.rawValue, with: kind.indexPath)
            
            attributes.frame = frame
            attributes.zIndex = kind.zIndex
            
            cachedSupplementaryViewAttributesArr[kind] = attributes
        }
    }
}

private extension GanttCollectionViewLayout {
    func layoutItemLabelCell(itemCellAttributes: Attributes,
                             itemLabelCellOriginalFrame: CGRect,
                             itemLabelCellAttributes: Attributes,
                             in rect: CGRect,
                             at indexPath: IndexPath) {
        let collectionView = collectionView!
        let collectionViewOffsetX = collectionView.contentOffset.x
        let collectionViewWidth = collectionView.bounds.width
        let collectionViewTrailingOffsetX = collectionViewOffsetX + collectionViewWidth
        let labelFrame = itemLabelCellAttributes.frame
        let rect = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
        let itemCellFrame = itemCellAttributes.frame
        let itemIntersectedFrame = itemCellFrame.intersection(rect)
        
        let x: CGFloat
        let itemCellLabelOffsetX: CGFloat
        let showingLabelOnItemCell: Bool
        
        if itemIntersectedFrame.width > labelFrame.width {
            showingLabelOnItemCell = true
            
            x = -1000
            itemCellLabelOffsetX = max(0, collectionViewOffsetX - itemCellFrame.minX)
        } else {
            showingLabelOnItemCell = false
            itemCellLabelOffsetX = 0
            
            if itemIntersectedFrame.width > 0 {
                if collectionViewOffsetX > itemCellFrame.minX {
                    x = itemCellFrame.maxX
                } else {
                    x = itemCellFrame.minX - labelFrame.width
                }
            }
            
            else if collectionViewOffsetX > itemCellFrame.maxX {
                x = collectionViewOffsetX
            }
            
            else {
                x = collectionViewTrailingOffsetX - labelFrame.width
            }
        }
        
        itemLabelCellAttributes.frame = CGRect(x: x,
                                               y: labelFrame.minY,
                                               width: labelFrame.width,
                                               height: labelFrame.height)
        itemLabelCellAttributes.showingLabelOnItemCell = showingLabelOnItemCell
        itemCellAttributes.itemCellLabelOffsetX = itemCellLabelOffsetX
        itemCellAttributes.showingLabelOnItemCell = showingLabelOnItemCell
    }
}

private extension GanttCollectionViewLayout {
    func layoutHeaderCells(attributes: Attributes,
                           initialFrame: CGRect,
                           extraOffsetY: CGFloat) {
        let collectionView = collectionView!
        let collectionViewOffsetY = collectionView.contentOffset.y
        let initialOffsetY = -collectionView.adjustedContentInset.top
        
        if collectionViewOffsetY > initialOffsetY {
            let newFrame = CGRect(x: initialFrame.minX,
                                  y: collectionViewOffsetY - initialOffsetY + extraOffsetY,
                                  width: initialFrame.width,
                                  height: initialFrame.height)
            attributes.frame = newFrame
        } else {
            attributes.frame = initialFrame
        }
    }
}
