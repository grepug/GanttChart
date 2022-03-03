//
//  GanttChartItemCell.swift
//  gantt-test
//
//  Created by Kai on 2022/3/1.
//

import UIKit

class GanttChartItemCell: UICollectionViewCell {
    lazy var progressView = UIView()
    lazy var label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(progressView)
        contentView.layer.cornerRadius = 12
        contentView.addSubview(label)
        label.textColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        
        let attributes = layoutAttributes as! GanttChartCollectionViewLayoutAttributes
        let labelOffsetX = attributes.itemCellLabelOffsetX
        
        label.frame = CGRect(x: labelOffsetX + 16,
                             y: 0,
                             width: label.bounds.width,
                             height: label.bounds.height)
        label.isHidden = !attributes.showingLabelOnItemCell
    }
    
    func applyConfiguration(item: GanttChartItem) {
        contentView.backgroundColor = item.color.withAlphaComponent(0.5)
        
        let width = item.progress * bounds.width
        
        progressView.backgroundColor = item.color
        progressView.frame = CGRect(x: 0,
                                    y: 0,
                                    width: width,
                                    height: bounds.height)
        progressView.roundCorners(corners: [.topLeft, .bottomLeft], radius: 12)
        item.apply(label: label, in: bounds)
    }
}
