//
//  GanttChartItemLabelCell.swift
//  gantt-test
//
//  Created by Kai on 2022/3/2.
//

import UIKit

class GanttChartItemLabelCell: UICollectionViewCell {
    lazy var label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(label)
        label.textAlignment = .center
    }
    
    func applyConfigurations(item: GanttChartItem) {
        item.apply(label: label, in: bounds)
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        
        let attributes = layoutAttributes as! GanttChartCollectionViewLayoutAttributes
        
        if attributes.showingLabelOnItemCell {
            label.textColor = .white
        } else {
            label.textColor = .label
        }
    }
}
