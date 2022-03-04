//
//  GanttChartCycleFrameReusableView.swift
//  gantt-test
//
//  Created by Kai on 2022/3/2.
//

import UIKit

class GanttChartCycleFrameReusableView: UICollectionReusableView {
    lazy var frameView = UIView()
    lazy var dashedBorder = CAShapeLayer()
    
    private let thickness: CGFloat = 3
    private let extraOffset: CGFloat = 2
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(frameView)
        
        dashedBorder.strokeColor = UIColor.systemBlue.cgColor
        dashedBorder.lineDashPattern = [6, 2]
        dashedBorder.lineWidth = thickness
        dashedBorder.frame = bounds
        dashedBorder.fillColor = nil
        dashedBorder.path = UIBezierPath(rect: rectForPath(in: bounds)).cgPath
        layer.addSublayer(dashedBorder)
    }
    
    private func rectForPath(in rect: CGRect) -> CGRect {
        CGRect(x: 0,
               y: extraOffset,
               width: rect.width,
               height: rect.height - thickness * 2 - extraOffset)
    }
    
    func applyConfigurations() {
        frameView.frame = bounds
        dashedBorder.frame = rectForPath(in: bounds)
    }
}
