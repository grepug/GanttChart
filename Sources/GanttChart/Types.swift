//
//  Types.swift
//  
//
//  Created by Kai on 2022/3/3.
//

import UIKit

public enum GanttChartCalendarScale: CaseIterable {
    case weeksAndDays, monthsAndDays
    
    var text: String {
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
        case .itemCell: return 10
        case .itemLabelCell: return 11
        default: return 9
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
    var startDate: Date
    var endDate: Date
    var title: String
    var progress: Double
    var color: UIColor
    
    var font: UIFont {
        .boldSystemFont(ofSize: 18)
    }
    
    var width: CGFloat {
        title.widthOfString(usingFont: font)
    }
    
    func apply(label: UILabel, in rect: CGRect) {
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
    case todayVerticalLine
    
    var zIndex: Int {
        switch self {
        case .todayVerticalLine: return 20
        }
    }
    
    var indexPath: IndexPath {
        switch self {
        case .todayVerticalLine: return [0, 0]
        }
    }
}
