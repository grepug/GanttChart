//
//  GanttChartConfiguration.swift
//  
//
//  Created by Kai on 2022/3/3.
//

import UIKit

public struct GanttChartConfiguration: Hashable {
    public var calendarType: GanttChartCalendarScale
    public var itemGroups: [GanttChartItemGroup]
    public var fixedHeaderHeight: CGFloat
    public var fixedColumnWidth: CGFloat
    public var bgCellHeight: CGFloat
    public var itemHeightRatio: CGFloat
    public var widthPerDay: CGFloat {
        switch calendarType {
        case .weeksAndDays:
            return 40
        case .monthsAndDays:
            return 16
        }
    }
    public var extraWidthPerDay: CGFloat
    public var leadingExtraMonths: Int
    public var trailingExtraMonths: Int
    public var showingLeadingFixedColumn: Bool
    public var backgroundColor: UIColor?
    public var disableScroll = false
    
    public init(itemGroups: [GanttChartItemGroup],
                calendarType: GanttChartCalendarScale = .monthsAndDays,
                fixedHeaderHeight: CGFloat = 50,
                fixedColumnWidth: CGFloat = 100,
                bgCellHeight: CGFloat = 48,
                itemHeightRatio: CGFloat = 0.7,
                widthPerDay: CGFloat = 40,
                extraWidthPerDay: CGFloat = 0,
                leadingExtraMonths: Int = 0,
                trailingExtraMonths: Int = 0,
                showingLeadingFixedColumn: Bool = true,
                backgroundColor: UIColor? = nil,
                disableScroll: Bool = false) {
        self.calendarType = calendarType
        self.itemGroups = itemGroups
        self.fixedHeaderHeight = fixedHeaderHeight
        self.fixedColumnWidth = fixedColumnWidth
        self.bgCellHeight = bgCellHeight
        self.itemHeightRatio = itemHeightRatio
        self.extraWidthPerDay = extraWidthPerDay
        self.leadingExtraMonths = leadingExtraMonths
        self.trailingExtraMonths = trailingExtraMonths
        self.showingLeadingFixedColumn = showingLeadingFixedColumn
        self.backgroundColor = backgroundColor
        self.disableScroll = disableScroll
    }
    
    public func cached() -> GanttChartConfigurationCache {
        let current = Date()
        let oneYearBefore = Calendar.current.date(byAdding: .year, value: -1, to: current)!
        let oneYearAfter = Calendar.current.date(byAdding: .year, value: 1, to: current)!
        /// 甘特图仅显示两年
        let endDate = min(oneYearAfter, chartEndDate)
        let oneDayBeforeEndDate = Calendar.current.date(byAdding: .day, value: -1, to: endDate)!
        let startDate = min(max(oneYearBefore, chartStartDate), oneDayBeforeEndDate)
        let bgCells = bgCells(startDate: startDate, endDate: endDate)
        let items = itemGroups.flatMap(\.items)
        let itemHeight = bgCellHeight * itemHeightRatio
        
        return .init(configuration: self,
                     items: items,
                     bgCells: bgCells,
                     chartStartDate: startDate,
                     chartEndDate: endDate,
                     itemHeight: itemHeight)
    }
}

extension GanttChartConfiguration {
    var chartStartDate: Date {
        let startDate = itemGroups.map(\.startDate).min() ?? Date()
        let startOfMonth = startDate.startOfMonth()
        
        switch calendarType {
        case .weeksAndDays:
            return Self.firstWeekDay(of: startOfMonth)
        case .monthsAndDays:
            return Calendar.current.date(byAdding: .month,
                                         value: leadingExtraMonths,
                                         to: startOfMonth)!
        }
    }
    
    var chartEndDate: Date {
        let endDate = itemGroups.map(\.endDate).max() ?? Date()
        let dateOfTrailingMonth = Calendar.current.date(byAdding: .month,
                                                        value: trailingExtraMonths,
                                                        to: endDate)!

        return dateOfTrailingMonth.endOfMonth()
    }
    
    static func firstWeekDay(of date: Date) -> Date {
        var date = date
        var day = Calendar.current.dateComponents([.weekday], from: date).weekday!
        
        while day != 2 {
            date = Calendar.current.date(byAdding: .day, value: -1, to: date)!
            day = Calendar.current.dateComponents([.weekday], from: date).weekday!
        }
        
        return date
    }
    
    func bgCells(startDate: Date, endDate: Date) -> [GanttBgCell] {
        var date = startDate
        var cells: [GanttBgCell] = []
        let twoYearsAfterStartDate = Calendar.current.date(byAdding: .year, value: 2, to: startDate)!
        let normalizedEndDate = min(endDate, twoYearsAfterStartDate)
        
        while date < normalizedEndDate {
            let days = date.daysInMonth()
            let width = CGFloat(days) * widthPerDay
            
            cells.append(.init(width: width, dateOfStart: date))
            
            switch calendarType {
            case .monthsAndDays:
                date = Calendar.current.date(byAdding: .month, value: 1, to: date)!
            case .weeksAndDays:
                date = Calendar.current.date(byAdding: .day, value: 7, to: date)!
            }
        }
        
        return cells
    }
}
