//
//  Types.swift
//  
//
//  Created by Kai on 2022/3/3.
//

import UIKit

public enum GanttChartCalendarScale: Int, CaseIterable {
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
        case .itemCell: return 3
        case .itemLabelCell: return 3
        default: return 1
        }
    }
}

public struct GanttChartItemGroup: Hashable {
    public var items: [GanttChartItem]
    public var drawingFrame = false
    
    var startDate: Date {
        items.map(\.startDate).min()!
    }
    
    var endDate: Date {
        items.map(\.endDate).max()!
    }
    
    public init(items: [GanttChartItem],
                drawingFrame: Bool = false) {
        self.items = items
        self.drawingFrame = drawingFrame
    }
}

public struct GanttChartItem: Identifiable, Hashable {
    public var id = UUID()
    public var startDate: Date
    public var endDate: Date
    public var title: String
    public var progress: Double
    public var color: UIColor
    
    public var font: UIFont {
        .systemFont(ofSize: 14)
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

public struct SupplementaryElement: Hashable {
    public let kind: Kind
    public let zIndex: Int
    public let indexPath: IndexPath
}

public extension SupplementaryElement {
    enum Kind: String, CaseIterable {
        case todayVerticalLine, fixedHeaderDayBackground, groupFrame
    }
}

public extension SupplementaryElement {
    static let todayVerticalLine: Self = .init(kind: .todayVerticalLine, zIndex: 20, indexPath: [0, 0])
    static let fixedHeaderDayBackground: Self = .init(kind: .fixedHeaderDayBackground, zIndex: 9, indexPath: [1, 0])
    
    static let staticCases: [Self] = [.todayVerticalLine, .fixedHeaderDayBackground]
}
