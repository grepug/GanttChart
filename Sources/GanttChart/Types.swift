//
//  Types.swift
//  
//
//  Created by Kai on 2022/3/3.
//

import UIKit

public enum GanttChartCalendarScale: CaseIterable {
    case weeksAndDays, monthsAndDays
    
    public var text: String {
        switch self {
        case .weeksAndDays: return "周视图"
        case .monthsAndDays: return "月视图"
        }
    }
}

public enum GanttChartCellType: String, CaseIterable {
    case fixedFirstCell,
         fixedHeaderCell,
         fixedHeaderDayCell,
         fixedColumnCell,
         bgCell,
         itemCell,
         itemLabelCell
    
    var zIndex: Int {
        switch self {
        case .fixedHeaderCell, .fixedFirstCell, .fixedHeaderDayCell: return 10
        case .itemCell: return 2
        case .itemLabelCell: return 2
        default: return 1
        }
    }
}

enum GattCharSection {
    case fixedHeader, content
}

struct GanttChartCycle {
    var startDate: Date
    var endDate: Date
}

public struct GanttChartItem: Identifiable, Hashable {
    public var id = UUID()
    public var startDate: Date
    public var endDate: Date
    public var title: String
    public var progress: Double
    public var color: UIColor
    
    public var font: UIFont {
        .boldSystemFont(ofSize: 18)
    }
    
    public var width: CGFloat {
        title.widthOfString(usingFont: font)
    }
    
    public init(id: UUID = UUID(),
                startDate: Date,
                endDate: Date,
                title: String,
                progress: Double,
                color: UIColor) {
        self.id = id
        self.startDate = startDate
        self.endDate = endDate
        self.title = title
        self.progress = progress
        self.color = color
    }
    
    public func apply(label: UILabel, in rect: CGRect) {
        let padding: CGFloat = 16
        
        label.font = font
        label.text = title
        label.frame = CGRect(x: padding,
                             y: 0,
                             width: width,
                             height: rect.height)
    }
}

public struct GanttBgCell: Hashable {
    var width: CGFloat
    var dateOfStart: Date
}

public struct GanttHeaderDayCell {
    var x: CGFloat
    var date: Date
    
    var day: Int {
        Calendar.current.dateComponents([.day], from: date).day!
    }
}

public enum SupplementaryElementKind: String, CaseIterable {
    case todayVerticalLine, fixedHeaderDayBackground
    
    var zIndex: Int {
        switch self {
        case .todayVerticalLine: return 20
        case .fixedHeaderDayBackground: return 9
        }
    }
    
    var indexPath: IndexPath {
        switch self {
        case .todayVerticalLine: return [0, 0]
        case .fixedHeaderDayBackground: return [1, 0]
        }
    }
}
