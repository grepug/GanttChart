//
//  GanttChartCollectionView+Delegate.swift
//  gantt-test
//
//  Created by Kai on 2022/3/2.
//

import UIKit

public extension GanttChart {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        chartConfig.items.count + 2
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
