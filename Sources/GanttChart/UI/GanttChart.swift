//
//  File.swift
//  
//
//  Created by Kai on 2022/3/3.
//

import UIKit

public class GanttChart: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource {
    public var contextMenuConfiguration: ((GanttChartItem, Int) -> UIContextMenuConfiguration?)?
    public var itemCellSelectionHandler: ((GanttChartItem, Int) -> Void)?
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
        bounces = false
        showsHorizontalScrollIndicator = false
        registerCells()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public extension GanttChart {
    func configure(using chartConfig: GanttChartConfiguration? = nil, reloading: Bool = false) {
        let chartConfig = chartConfig ?? chartConfigCache.configuration
        chartConfigCache = chartConfig.cached()
        layout.config = chartConfigCache
        layout.invalidateLayout()
        
        if let color = chartConfig.backgroundColor {
            backgroundColor = color
        }
        
        isScrollEnabled = !chartConfig.disableScroll
        
        if reloading {
            reloadData()
        }
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
        
        for kind in SupplementaryElement.Kind.allCases {
            switch kind {
            case .groupFrame:
                register(GanttChartCycleFrameReusableView.self,
                         forSupplementaryViewOfKind: kind.rawValue,
                         withReuseIdentifier: "1")
            default:
                register(UICollectionReusableView.self,
                         forSupplementaryViewOfKind: kind.rawValue,
                         withReuseIdentifier: "1")
            }
            
        }
    }
}

