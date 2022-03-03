//
//  GanttChartConfiguration.swift
//  
//
//  Created by Kai on 2022/3/3.
//

import UIKit

public struct GanttChartConfiguration: Hashable {
    public var calendarType: GanttChartCalendarScale
    public var items: [GanttChartItem]
    public var fixedHeaderHeight: CGFloat = 80
    public var fixedColumnWidth: CGFloat = 100
    public var bgCellHeight: CGFloat = 60
    public var itemHeight: CGFloat = 40
    public var widthPerDay: CGFloat = 30
    public var extraWidthPerDay: CGFloat = 0
    public var leadingExtraMonths: Int = 0
    public var trailingExtraMonths: Int = 0
    public var showingLeadingFixedColumn = true
    
    public func cached() -> GanttChartConfigurationCache {
        let startDate = chartStartDate
        let endDate = chartEndDate
        let bgCells = bgCells(startDate: startDate,
                              endDate: endDate)
        
        return .init(configuration: self,
              bgCells: bgCells,
              chartStartDate: startDate,
              chartEndDate: endDate)
    }
}

extension GanttChartConfiguration {
    var chartStartDate: Date {
        let startDate = items.map(\.startDate).min()!
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
        let endDate = items.map(\.endDate).max()!
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
        
        while date < endDate {
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
