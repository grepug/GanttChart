//
//  GanttChartCollectionView+Delegate.swift
//  gantt-test
//
//  Created by Kai on 2022/3/2.
//

import UIKit

public extension GanttChart {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        chartConfigCache.collectionViewNumberOfSections()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        chartConfigCache.collectionViewNumberOfItem(in: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellType = chartConfigCache.cellType(at: indexPath)
        let kind = cellType.rawValue
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kind, for: indexPath)
        
        switch cellType {
        case .itemCell:
            let cell = cell as! GanttChartItemCell
            let item = chartConfigCache.chartItem(at: indexPath)
            
            cell.applyConfiguration(item: item)
        case .itemLabelCell:
            let cell = cell as! GanttChartItemLabelCell
            let item = chartConfigCache.chartItem(at: indexPath)
            
            cell.applyConfigurations(item: item)
        case .fixedHeaderCell:
            cell.contentConfiguration = chartConfigCache.fixedHeaderTopCellConfiguration(at: indexPath)
            cell.backgroundColor = .systemBackground
        case .bgCell, .fixedColumnCell:
            cell.contentConfiguration = GanttChartBgCellConfiguration(index: indexPath.section)
        case .fixedHeaderDayCell:
            let day = chartConfigCache.dayCell(at: indexPath)
            let textLabel: UILabel
            
            if let label = cell.contentView.subviews.first(where: { $0.tag == 1 }) as? UILabel {
                textLabel = label
            } else {
                textLabel = UILabel()
                textLabel.tag = 1
                cell.contentView.addSubview(textLabel)
                textLabel.frame = cell.contentView.bounds
                textLabel.textAlignment = .center
                textLabel.adjustsFontSizeToFitWidth = true
                textLabel.font = .preferredFont(forTextStyle: .footnote)
            }

            textLabel.text = "\(day.day)"
            cell.backgroundColor = .clear
        case .fixedFirstCell: break
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "1", for: indexPath)
        let kindEnum = SupplementaryElementKind(rawValue: kind)!

        switch kindEnum {
        case .todayVerticalLine:
            view.backgroundColor = .systemRed.withAlphaComponent(0.8)
        case .fixedHeaderDayBackground:
            view.backgroundColor = .systemBackground
            
            if view.layer.sublayers == nil {
                let borderLayer = CALayer()
                let borderThickness: CGFloat = 1
                borderLayer.backgroundColor = UIColor.separator.cgColor
                borderLayer.frame = .init(x: 0,
                                          y: view.bounds.height - borderThickness,
                                          width: view.bounds.width,
                                          height: borderThickness)
                view.layer.addSublayer(borderLayer)
            }
        }

        return view
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let cellType = chartConfigCache.cellType(at: indexPath)
        
        guard cellType == .itemCell else { return nil }
        
        let item = chartConfigCache.chartItem(at: indexPath)
        
        return contextMenuConfiguration?(item, indexPath.section - 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cellType = chartConfigCache.cellType(at: indexPath)
        
        switch cellType {
        case .itemLabelCell:
            let frame = chartConfigCache.cellFrame(at: indexPath)
            
            collectionView.setContentOffset(.init(x: frame.minX,
                                                  y: collectionView.contentOffset.y),
                                            animated: true)
        default: break
        }
    }
}
