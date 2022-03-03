//
//  File.swift
//  
//
//  Created by Kai on 2022/3/3.
//

import UIKit

public class GanttChart: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource {
    public var contextMenuConfiguration: ((GanttChartItem, Int) -> UIContextMenuConfiguration?)?
    public var chartConfigCache: GanttChartConfigurationCache!
    
    var layout: GanttCollectionViewLayout
    
    public var chartConfig: GanttChartConfiguration {
        chartConfigCache.configuration
    }
    
    public init(frame: CGRect) {
        let layout = GanttCollectionViewLayout()
        
        self.layout = layout
        
        super.init(frame: frame, collectionViewLayout: layout)
        
        delegate = self
        dataSource = self
        registerCells()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public extension GanttChart {
    func configure(using chartConfig: GanttChartConfiguration? = nil) {
        let chartConfig = chartConfig ?? chartConfigCache.configuration
        
        chartConfigCache = chartConfig.cached()
        layout.config = chartConfigCache
        reloadData()
    }
    
    func changeOrientation(size: CGSize) {
        frame = .init(origin: frame.origin, size: size)
        layout.changeOrientation()
    }
    
    func scrollsToToday() {
        let point = chartConfigCache.todayPoint(in: bounds, y: contentOffset.y)
        setContentOffset(point, animated: true)
    }
}

extension GanttChart {
    func registerCells() {
        for kind in GanttChartCellType.allCases {
            switch kind {
            case .itemCell:
                register(GanttChartItemCell.self,
                                        forCellWithReuseIdentifier: kind.rawValue)
            case .itemLabelCell:
                register(GanttChartItemLabelCell.self,
                                        forCellWithReuseIdentifier: kind.rawValue)
            default:
                register(UICollectionViewCell.self,
                                        forCellWithReuseIdentifier: kind.rawValue)
            }
        }
        
        register(UICollectionReusableView.self,
                                forSupplementaryViewOfKind: SupplementaryElementKind.todayVerticalLine.rawValue,
                                withReuseIdentifier: "1")
    }
}

