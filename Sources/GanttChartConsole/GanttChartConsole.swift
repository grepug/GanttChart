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
                        Slider(value: $vm.widthPerDay, in: 10...100, step: 1)
                        Text("\(Int(vm.widthPerDay))")
                    }
                } header: {
                    Text("Width Per Day")
                }
                
                Section {
                    HStack {
                        Slider(value: $vm.extraWidthPerDay, in: 0...50, step: 1)
                        Text("\(Int(vm.extraWidthPerDay))")
                    }
                } header: {
                    Text("Extra Width Per Day")
                }
                
                Section {
                    HStack {
                        Slider(value: $vm.fixedHeaderHeight, in: 40...100, step: 1)
                        Text("\(Int(vm.fixedHeaderHeight))")
                    }
                } header: {
                    Text("Fixed Header Height")
                }
                
                Section {
                    HStack {
                        Slider(value: $vm.itemHeight, in: 10...60, step: 1)
                        Text("\(Int(vm.itemHeight))")
                    }
                } header: {
                    Text("Item Height")
                }
            }
            .navigationTitle("调试器")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Reset") {
                        vm.reset()
                    }
                }
            }
        }
    }
}

public extension GanttChartConsole {
    class ViewModel: ObservableObject {
        static var defaultWidthPerDay: CGFloat = 30
        static var defaultExtraWidthPerDay: CGFloat = 0
        static var defaultFixedHeaderHeight: CGFloat = 80
        static var defaultItemHeight: CGFloat = 40
        
        @Published public var widthPerDay: CGFloat = ViewModel.defaultWidthPerDay
        @Published public var extraWidthPerDay: CGFloat = ViewModel.defaultExtraWidthPerDay
        @Published public var fixedHeaderHeight: CGFloat = ViewModel.defaultFixedHeaderHeight
        @Published public var itemHeight: CGFloat = ViewModel.defaultItemHeight
        
        var cancellables = Set<AnyCancellable>()
        
        public init() {
            
        }
        
        public func reset() {
            widthPerDay = Self.defaultWidthPerDay
            extraWidthPerDay = Self.defaultExtraWidthPerDay
            fixedHeaderHeight = Self.defaultFixedHeaderHeight
            itemHeight = Self.defaultItemHeight
        }
    }
}

public extension GanttChartConsole {
    static func makeViewController(vm: ViewModel) -> UIViewController {
        let rootView = GanttChartConsole(vm: vm)
        
        return UIHostingController(rootView: rootView)
    }
}
