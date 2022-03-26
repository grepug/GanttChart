//
//  GanttChartView.swift
//  
//
//  Created by Kai on 2022/3/11.
//

import SwiftUI
import UIKit

public struct GanttChartView: UIViewRepresentable {
    @Binding public var config: GanttChartConfiguration
    
    public typealias UIViewType = GanttChart
    
    public func makeUIView(context: Context) -> GanttChart {
        let chart = GanttChart(frame: .zero)
        
        DispatchQueue.main.async {
            chart.scrollsToToday()
        }
        
        return chart
    }
    
    public func updateUIView(_ uiView: GanttChart, context: Context) {
        uiView.configure(using: config, reloading: true)
    }
    
    public init(config: Binding<GanttChartConfiguration>) {
        self._config = config
    }
}

public struct GanttChartTextView: View {
    @State private var config: GanttChartConfiguration = {
        let date1 = "2022-01-01 12:00:00".toDate()!
        let date2 = "2022-02-28 13:00:00".toDate()!
        
        let date3 = "2022-02-05 12:00:00".toDate()!
        let date4 = "2022-04-01 13:00:00".toDate()!
        
        let date5 = "2022-01-20 12:00:00".toDate()!
        let date6 = "2022-03-05 13:00:00".toDate()!
        
        let date7 = "2021-12-05 12:00:00".toDate()!
        let date8 = "2022-04-28 13:00:00".toDate()!
        
        let itemsGroup1: GanttChartItemGroup = .init(items: [
            .init(startDate: date1, endDate: date2, title: "第一个目标第一个目标第一个目标第一个目标第一个目标", progress: 0.5, color: .green),
            .init(startDate: date3, endDate: date4, title: "健康身体棒1", progress: 0.2, color: .systemGreen),
            .init(startDate: date5, endDate: date6, title: "健康身体棒2", progress: 0.8, color: .systemBlue),
            .init(startDate: date7, endDate: date8, title: "健康身体棒3", progress: 0.3, color: .systemPurple),
        ], drawingFrame: true)
        
        return .init(itemGroups: [itemsGroup1])
    }()
    
    public var body: some View {
        GanttChartView(config: $config)
    }
    
    public init() {}
}
