//
//  GanttChartBgCellConfiguration.swift
//  gantt-test
//
//  Created by Kai on 2022/3/1.
//

import UIKit

struct GanttChartBgCellConfiguration: UIContentConfiguration {
    var index: Int
    
    func makeContentView() -> UIView & UIContentView {
        View(configuration: self)
    }
    
    func updated(for state: UIConfigurationState) -> Self {
        self
    }
}

extension GanttChartBgCellConfiguration {
    class View: UIView & UIContentView {
        typealias Config = GanttChartBgCellConfiguration
        
        lazy var borderLayer = CALayer()
        
        var configuration: UIContentConfiguration {
            didSet {
                let config = configuration as! Config
                
                apply(config: config)
            }
        }
        
        var config: Config {
            configuration as! Config
        }
        
        init(configuration: Config) {
            self.configuration = configuration
            super.init(frame: .zero)
            
            setupViews(config: configuration)
            apply(config: configuration)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}

extension GanttChartBgCellConfiguration.View {
    func setupViews(config: Config) {
        borderLayer.backgroundColor = UIColor.systemGray5.cgColor
        layer.addSublayer(borderLayer)
    }
    
    func apply(config: Config) {
//        borderLayer.frame = .init(x: bounds.width - 2,
//                                  y: 0,
//                                  width: 2,
//                                  height: bounds.height)
        
//        if config.index % 2 != 0 {
//            backgroundColor = .init {
//                $0.userInterfaceStyle == .dark ? .secondarySystemBackground : .systemGroupedBackground
//            }
//        } else {
//            backgroundColor = .systemBackground
//        }
    }
}

