//
//  GanttChartConsole.swift
//  
//
//  Created by Kai on 2022/3/3.
//

import SwiftUI
import Combine

public struct GanttChartConsole: View {
    @ObservedObject var vm: ViewModel
    
    public var body: some View {
        NavigationView {
            List {
                Section {
                    HStack {
                        Slider(value: $vm.widthPerDay, in: 1...100, step: 1)
                        Text("\(Int(vm.widthPerDay))")
                    }
                } header: {
                    Text("每天的宽")
                }
                
                Section {
                    HStack {
                        Slider(value: $vm.fixedHeaderHeight, in: 40...100, step: 1)
                        Text("\(Int(vm.fixedHeaderHeight))")
                    }
                } header: {
                    Text("头部的高")
                }
                
                Section {
                    HStack {
                        Slider(value: $vm.bgCellHeight, in: 20...80, step: 1)
                        Text("\(Int(vm.bgCellHeight))")
                    }
                } header: {
                    Text("格子的高")
                }
                
                Section {
                    HStack {
                        Slider(value: $vm.itemHeightRatio, in: 0...1, step: 0.1)
                        Text("\(vm.itemHeightRatio)")
                    }
                } header: {
                    Text("进度条与格子高的比例")
                }
                
                Section {
                    Text("宽：\(vm.viewSize.width)\n高：\(vm.viewSize.height)")
                } header: {
                    Text("甘特图的尺寸")
                }
            }
            .navigationTitle("调试器")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("重置") {
                        vm.reset()
                    }
                }
            }
        }
    }
}

public extension GanttChartConsole {
    class ViewModel: ObservableObject {
        static var defaultWidthPerDay: CGFloat = 40
        static var defaultExtraWidthPerDay: CGFloat = 0
        static var defaultFixedHeaderHeight: CGFloat = 50
        static var defaultItemHeightRatio: CGFloat = 0.667
        static var defaultBgCellHeight: CGFloat = 53
        
        @Published public var widthPerDay: CGFloat = ViewModel.defaultWidthPerDay
        @Published public var extraWidthPerDay: CGFloat = ViewModel.defaultExtraWidthPerDay
        @Published public var fixedHeaderHeight: CGFloat = ViewModel.defaultFixedHeaderHeight
        @Published public var itemHeightRatio: CGFloat = ViewModel.defaultItemHeightRatio
        @Published public var bgCellHeight: CGFloat = ViewModel.defaultBgCellHeight
        @Published public var viewSize: CGSize = .zero
        
        var cancellables = Set<AnyCancellable>()
        
        public init() {
            
        }
        
        public func reset() {
            widthPerDay = Self.defaultWidthPerDay
            extraWidthPerDay = Self.defaultExtraWidthPerDay
            fixedHeaderHeight = Self.defaultFixedHeaderHeight
            itemHeightRatio = Self.defaultItemHeightRatio
            bgCellHeight = Self.defaultBgCellHeight
        }
    }
}

public extension GanttChartConsole {
    static func makeViewController(vm: ViewModel) -> UIViewController {
        let rootView = GanttChartConsole(vm: vm)
        
        return UIHostingController(rootView: rootView)
    }
}
