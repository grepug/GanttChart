//
//  GanttChartConfigurationCache.swift
//  
//
//  Created by Kai on 2022/3/3.
//

import UIKit

public struct GanttChartConfigurationCache: Hashable {
    public let configuration: GanttChartConfiguration
    let items: [GanttChartItem]
    let currentDate: Date = Date()
    let bgCells: [GanttBgCell]
    let chartStartDate: Date
    let chartEndDate: Date
    let itemHeight: CGFloat
}

public extension GanttChartConfigurationCache {
    func todayPoint(in frame: CGRect, y: CGFloat = 0) -> CGPoint {
        let beforeDays = Date.days(from: chartStartDate, to: currentDate) - 1
        let x = CGFloat(beforeDays) * configuration.widthPerDay + configuration.fixedColumnWidth - frame.width / 2
        
        return .init(x: x, y: y)
    }
    
    func chartItem(at indexPath: IndexPath) -> GanttChartItem {
        items[indexPath.section - 2]
    }
    
    func bgCell(at indexPath: IndexPath) -> GanttBgCell {
        bgCells[indexPath.item - 1]
    }
    
    func dayCell(at indexPath: IndexPath) -> GanttHeaderDayCell {
        dayCells[indexPath.item]
    }
    
    func cellType(at indexPath: IndexPath) -> GanttChartCellType {
        if indexPath.section == 0 && indexPath.item == 0 {
            return .fixedFirstCell
        }
        
        if indexPath.section == 0 {
            return .fixedHeaderCell
        }
        
        if indexPath.section == 1 {
            return .fixedHeaderDayCell
        }
        
        if indexPath.item == 0 {
            return .fixedColumnCell
        }
        
        let itemsCount = collectionViewNumberOfItem(in: indexPath.section)
        
        if indexPath.item == itemsCount - 1 {
            return .itemLabelCell
        }
        
        if indexPath.item == itemsCount - 2 {
            return .itemCell
        }
        
        return .bgCell
    }
    
    func cellFrame(at indexPath: IndexPath) -> CGRect {
        let section = indexPath.section
        let item = indexPath.item
        let normalizedSection = section - 2
        let normalizedItem = item - (configuration.showingLeadingFixedColumn ? 1 : 0)
        let cellType = cellType(at: indexPath)
        let fixedColumnWidth = configuration.fixedColumnWidth
        let fixedHeaderHeight = configuration.fixedHeaderHeight
        let widthPerDay = configuration.widthPerDay
        let extraWidthPerDay = configuration.extraWidthPerDay
        let bgCellHeight = configuration.bgCellHeight
        
        switch cellType {
        case .fixedFirstCell:
            return .init(x: 0,
                         y: 0,
                         width: fixedColumnWidth,
                         height: fixedHeaderHeight)
        case .fixedHeaderCell:
            return .init(x: fixedColumnWidth + calculateLeadingBgCellWidth(at: normalizedItem),
                         y: 0,
                         width: bgCellWidth(at: normalizedItem),
                         height: fixedHeaderHeight / 2)
        case .fixedHeaderDayCell:
            let dayCell = dayCells[item]
            let width = widthPerDay + extraWidthPerDay
            
            return .init(x: fixedColumnWidth + dayCell.x - extraWidthPerDay / 2,
                         y: fixedHeaderHeight / 2,
                         width: width,
                         height: fixedHeaderHeight / 2 - 1)
        case .fixedColumnCell:
            return .init(x: 0,
                         y: bgCellOffsetY(inSection: normalizedSection),
                         width: fixedColumnWidth,
                         height: bgCellHeight)
        case .bgCell:
            return .init(x: fixedColumnWidth + calculateLeadingBgCellWidth(at: normalizedItem),
                         y: bgCellOffsetY(inSection: normalizedSection),
                         width: bgCellWidth(at: normalizedItem),
                         height: bgCellHeight)
        case .itemCell:
            return itemFrame(inSection: normalizedSection)
        case .itemLabelCell:
            let itemFrame = itemFrame(inSection: normalizedSection)
            let item = chartItem(at: indexPath)
            
            return .init(x: itemFrame.minX,
                         y: itemFrame.minY,
                         width: min(UIScreen.main.bounds.width / 2, item.titleWidth) + 32,
                         height: itemHeight)
        }
    }
    
    func supplementaryElementForGroupFrames() -> [SupplementaryElement] {
        configuration.itemGroups.enumerated().compactMap { index, group in
            group.drawingFrame ?
                .init(kind: .groupFrame,
                      zIndex: 2,
                      indexPath: [2, index]) :
            nil
        }
    }
    
    var todayCellTextFont: UIFont {
        .preferredFont(forTextStyle: .footnote)
    }
    
    var todayCellText: String {
        String(Calendar.current.component(.day, from: Date()))
    }
    
    var todayCellTextWidth: CGFloat {
        todayCellText.widthOfString(usingFont: todayCellTextFont)
    }
    
    func supplementaryViewFrame(_ element: SupplementaryElement) -> CGRect {
        switch element.kind {
        case .groupFrame:
            let index = element.indexPath.item
            let group = configuration.itemGroups[index]
            let itemCount = group.items.count
            let cycleStartDate = group.startDate
            let beforeDays = Date.days(from: chartStartDate, to: cycleStartDate) - 1
            let x = CGFloat(beforeDays) * configuration.widthPerDay + configuration.fixedColumnWidth
            let padding: CGFloat = 16
            let borderThickness: CGFloat = 3
            let width = group.maxItemWidth(widthPerDay: configuration.widthPerDay,
                                           aligningToLastNumber: configuration.calendarType == .weeksAndDays) + padding * 2
            let y = configuration.fixedHeaderHeight + height(aboveGroupIndex: index)
            let height = height(forItems: itemCount) + borderThickness

            return .init(x: x - padding,
                         y: y,
                         width: width,
                         height: height)
        case .fixedHeaderDayBackground:
            return .init(x: 0,
                         y: configuration.fixedHeaderHeight / 2,
                         width: collectionViewContentSize.width,
                         height: configuration.fixedHeaderHeight / 2)
        case .todayVerticalLine:
            let beforeDays = Date.days(from: chartStartDate, to: currentDate) - 1
            let lineWidth: CGFloat = 1
            let widthPerDay = configuration.widthPerDay
            let x = CGFloat(beforeDays) * widthPerDay + configuration.fixedColumnWidth + todayCellTextWidth / 2 - lineWidth
            
            return .init(x: x,
                         y: configuration.fixedHeaderHeight,
                         width: lineWidth,
                         height: collectionViewContentSize.height - configuration.fixedHeaderHeight)
        }
    }
}

// MARK: for Collection View
extension GanttChartConfigurationCache {
    func collectionViewNumberOfItem(in section: Int) -> Int {
        if section == 0 {
            return bgCells.count + 1
        }
        
        if section == 1 {
            return dayCells.count
        }
        
        return bgCells.count + 3
    }
    
    func collectionViewNumberOfSections() -> Int {
        items.count + 2
    }
    
    var collectionViewContentSize: CGSize {
        let width = configuration.fixedColumnWidth + CGFloat(numberOfDays) * configuration.widthPerDay
        let height = configuration.fixedHeaderHeight + CGFloat(items.count) * configuration.bgCellHeight

        return .init(width: width, height: height)
    }
    
    func fixedHeaderTopCellConfiguration(at indexPath: IndexPath) -> UIContentConfiguration {
        let date = bgCell(at: indexPath).dateOfStart
        var config = UIListContentConfiguration.cell()
        let components = Calendar.current.dateComponents([.month, .year, .weekOfYear], from: date)
        let month = components.month!
        let year = components.year!

        config.directionalLayoutMargins = .zero
        config.imageToTextPadding = 0
        config.textToSecondaryTextVerticalPadding = 0
        config.textToSecondaryTextHorizontalPadding = 0
        config.textProperties.font = .preferredFont(forTextStyle: .headline)
        
        switch configuration.calendarType {
        case .monthsAndDays:
            let yearText = month == 1 ? "\(year)年" : ""
            config.text = yearText + "\(month)月"
        case .weeksAndDays:
            let week = components.weekOfYear!
            let yearText = week == 1 ? "\(year + 1)年" : ""
            config.text = yearText + "第\(week)周"
        }
        
        return config
    }
    
    func fixedHeaderTopCellText(at indexPath: IndexPath) -> String {
        let date = bgCell(at: indexPath).dateOfStart
        let components = Calendar.current.dateComponents([.month, .year, .weekOfYear], from: date)
        let month = components.month!
        let year = components.year!
        let text: String
        let yearText = month == 1 ? "\(year)年" : ""

        text = yearText + "\(month)月"

        return text
    }
}

private extension GanttChartConfigurationCache {
    func height(forItems numberOfItems: Int) -> CGFloat {
        configuration.bgCellHeight * CGFloat(numberOfItems)
    }
    
    func height(aboveGroupIndex index: Int) -> CGFloat {
        var _height = CGFloat.zero
        
        for i in 0..<index {
            _height += height(forItems: configuration.itemGroups[i].items.count)
        }
        
        return _height
    }
    
    func calculateLeadingBgCellWidth(at index: Int) -> CGFloat {
        var width = CGFloat.zero
        
        for i in 0..<index {
            width += bgCellWidth(at: i)
        }
        
        return width
    }
    
    func itemFrame(inSection index: Int) -> CGRect {
        let item = items[index]
        let widthPerDay = configuration.widthPerDay
        let beforeDays = Date.days(from: chartStartDate, to: item.startDate) - 1
        let x: CGFloat = widthPerDay * CGFloat(beforeDays) + configuration.fixedColumnWidth
        let y: CGFloat = bgCellOffsetY(inSection: index) + (configuration.bgCellHeight - itemHeight) / 2
        let width = itemWidth(inSection: index)

        return .init(x: x,
                     y: y,
                     width: width,
                     height: itemHeight)
    }
    
    func bgCellOffsetY(inSection index: Int) -> CGFloat {
        var y: CGFloat = configuration.fixedHeaderHeight
        y += CGFloat(index) * configuration.bgCellHeight
        
        return y
    }
    
    func itemWidth(inSection index: Int) -> CGFloat {
        let item = items[index]
        let aligningToLastNumber = configuration.calendarType == .weeksAndDays
        
        return item.width(widthPerDay: configuration.widthPerDay,
                          aligningToLastNumber: aligningToLastNumber)
    }
    
    var numberOfDays: Int {
        Date.days(from: chartStartDate, to: chartEndDate)
    }
    
    var dayCells: [GanttHeaderDayCell] {
        var date = chartStartDate
        var cells: [GanttHeaderDayCell] = []
        var x: CGFloat = 0
        
        while date < chartEndDate {
            cells.append(.init(x: x, date: date))
            
            switch configuration.calendarType {
            case .monthsAndDays:
                date = Calendar.current.date(byAdding: .day, value: 7, to: date)!
                x += configuration.widthPerDay * 7
            case .weeksAndDays:
                date = Calendar.current.date(byAdding: .day, value: 1, to: date)!
                x += configuration.widthPerDay
            }
        }
        
        return cells
    }
    
    func bgCellWidth(at index: Int = 0) -> CGFloat {
        switch configuration.calendarType {
        case .weeksAndDays: return configuration.widthPerDay * 7
        case .monthsAndDays: return bgCells[index].width
        }
    }
}
