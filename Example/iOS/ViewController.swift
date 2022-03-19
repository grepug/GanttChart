//
//  ViewController.swift
//  Example
//
//  Created by Kai on 2022/3/3.
//

import UIKit
import GanttChart
import GanttChartConsole
import Combine

class ViewController: UIViewController, UIScrollViewDelegate {
    var ganttChart: GanttChart!
    var calendarTypeSwitchButton: UIBarButtonItem = .init(title: "")
    
    var consoleVM = GanttChartConsole.ViewModel()
    var consoleButton = UIBarButtonItem(title: "")
    
    var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGanttChart()
        setupNavigationBar()
        
        consoleVM
            .objectWillChange
            .sink { [weak self] _ in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    
                    let vm = self.consoleVM
                    
                    var config = self.ganttChart.chartConfig
                    config.itemHeightRatio = vm.itemHeightRatio
                    config.fixedHeaderHeight = vm.fixedHeaderHeight
                    config.extraWidthPerDay = vm.extraWidthPerDay
                    config.bgCellHeight = vm.bgCellHeight
                    
                    self.ganttChart.configure(using: config, reloading: true)
                }
            }
            .store(in: &cancellables)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        ganttChart.changeOrientation(size: size)
        consoleVM.viewSize = size
    }
}

private extension ViewController {
    func changeCalendarType(to type: GanttChartCalendarScale) {
        var chartConfig = ganttChart.chartConfig
        chartConfig.calendarType = type
        
        calendarTypeSwitchButton.title = type.text
        ganttChart.configure(using: chartConfig, reloading: true)
    }
    
    func setupGanttChart() {
        let date1 = "2022-01-01 12:00:00".toDate()!
        let date2 = "2022-02-28 13:00:00".toDate()!
        
        let date3 = "2022-02-05 12:00:00".toDate()!
        let date4 = "2022-04-01 13:00:00".toDate()!
        
        let date5 = "2022-01-20 12:00:00".toDate()!
        let date6 = "2022-03-05 13:00:00".toDate()!
        
        let date7 = "2021-12-05 12:00:00".toDate()!
        let date8 = "2022-04-28 13:00:00".toDate()!
        
        let itemsGroup1: GanttChartItemGroup = .init(items: [
            .init(startDate: date1, endDate: date2, title: "第一个目标第一个目标第一个目标第一个目标第一个目标", progress: 0.5, color: .systemMint),
            .init(startDate: date3, endDate: date4, title: "健康身体棒1", progress: 0.2, color: .systemGreen),
            .init(startDate: date5, endDate: date6, title: "健康身体棒2", progress: 0.8, color: .systemBlue),
            .init(startDate: date7, endDate: date8, title: "健康身体棒3", progress: 0.3, color: .systemPurple),
            .init(startDate: date1, endDate: date2, title: "第一个目标第一个目标第一个目标第一个目标第一个目标", progress: 0.5, color: .systemMint),
        ], drawingFrame: true)
        
        let itemsGroup2: GanttChartItemGroup = .init(items: [
            .init(startDate: date3, endDate: date4, title: "健康身体棒1", progress: 0.2, color: .systemGreen),
            .init(startDate: date5, endDate: date6, title: "健康身体棒2", progress: 0.8, color: .systemBlue),
            .init(startDate: date7, endDate: date8, title: "健康身体棒3", progress: 0.3, color: .systemPurple),
            .init(startDate: date1, endDate: date2, title: "第一个目标第一个目标第一个目标第一个目标第一个目标", progress: 0.5, color: .systemMint),
            .init(startDate: date3, endDate: date4, title: "健康身体棒1", progress: 0.2, color: .systemGreen),
        ], drawingFrame: false)
        
        let itemsGroup3: GanttChartItemGroup = .init(items: [
            .init(startDate: date5, endDate: date6, title: "健康身体棒2", progress: 0.8, color: .systemBlue),
            .init(startDate: date7, endDate: date8, title: "健康身体棒3", progress: 0.3, color: .systemPurple),
            .init(startDate: date1, endDate: date2, title: "第一个目标第一个目标第一个目标第一个目标第一个目标", progress: 0.5, color: .systemMint),
            .init(startDate: date3, endDate: date4, title: "健康身体棒1", progress: 0.2, color: .systemGreen),
            .init(startDate: date5, endDate: date6, title: "健康身体棒2", progress: 0.8, color: .systemBlue),
            .init(startDate: date7, endDate: date8, title: "健康身体棒3", progress: 0.3, color: .systemPurple),
        ])
        
        let chartConfig = GanttChartConfiguration(itemGroups: [itemsGroup1])
        
        ganttChart = .init(frame: view.bounds)
        
        view.addSubview(ganttChart)
        
        ganttChart.contextMenuConfiguration = { item, index in
                .init(identifier: index as NSCopying,
                      previewProvider: nil) { _ in
                        .init(children: [
                            UIAction(title: "Edit", handler: { _ in
                                
                            })
                        ])
                }
        }
        
        ganttChart.configure(using: chartConfig)
        
        DispatchQueue.main.async {
            self.consoleVM.viewSize = self.view.bounds.size
        }
    }
    
    func setupNavigationBar() {
        calendarTypeSwitchButton.title = ganttChart.chartConfigCache.configuration.calendarType.text
        calendarTypeSwitchButton.menu = UIMenu(children: GanttChartCalendarScale.allCases.map { type in
            UIAction(title: type.text) { [weak self] _ in
                self?.changeCalendarType(to: type)
            }
        })
        
        let backToTodayButton = UIBarButtonItem(title: "回到今天", primaryAction: .init { [weak self] _ in
            self?.ganttChart.scrollsToToday()
        })
        
        consoleButton.primaryAction = .init(title: "调试器") { [weak self] _ in
            guard let self = self else { return }
            
            let vc = GanttChartConsole.makeViewController(vm: self.consoleVM)
            vc.modalPresentationStyle = .popover
            vc.popoverPresentationController?.barButtonItem = self.consoleButton
            
            self.present(vc, animated: true)
        }
        
        navigationItem.rightBarButtonItems = [
            calendarTypeSwitchButton,
            backToTodayButton
        ]
        
        navigationItem.leftBarButtonItems = [
            consoleButton
        ]
    }
}
