//
//  DependencyContainer.swift
//  ToDoApp
//
//  Created by Thokozani Mncube on 2025/09/01.
//
import SwiftUI
import RealmSwift

final class DependencyContainer {
    static let shared = DependencyContainer()
    
    private init() {}
    
    lazy var storage: ToDoStorage = {
        ToDoStorage()
    }()
    
    lazy var weatherService: WeatherServiceProtocol = {
        WeatherService()
    }()
}

protocol WeatherDependencyContainer {
    var weatherView: WeatherView { get }
}

extension DependencyContainer: WeatherDependencyContainer {
    
    public var weatherView: WeatherView {
        WeatherView(
            viewModel: weatherViewModel,
            hourToHourWeatherView: AnyView(hourToHourWeatherView),
            tomorrowWeatherView: AnyView(tomorrowWeatherView),
            dayToDayWeatherView: AnyView(dayToDayWeatherView)
        )
    }
    
    public var dayToDayWeatherView: DayToDayWeatherView {
        DayToDayWeatherView(dailyViewModel: dayToDayWeatherViewModel)
    }
    
    public var tomorrowWeatherView: TomorrowWeatherView {
        TomorrowWeatherView(dailyViewModel: dayToDayWeatherViewModel)
    }
    
    public var hourToHourWeatherView: HourToHourWeatherView {
        HourToHourWeatherView(hourlyViewModel: hourToHourWeatherViewModel)
    }
    
    public var weatherViewModel: WeatherViewModel {
        WeatherViewModel(weatherService: weatherService)
    }
    
    public var dayToDayWeatherViewModel: DayToDayViewModel {
        DayToDayViewModel(weatherService: weatherService)
    }
    
    public var hourToHourWeatherViewModel: HourToHourWeatherViewModel {
        HourToHourWeatherViewModel(weatherService: weatherService)
    }
}

protocol ToDoDependencyContainer {
    var tasksView: TasksView { get }
    func addTaskView(for category: Category) ->AddTaskView
}

extension DependencyContainer: ToDoDependencyContainer {
    
    public var tasksView: TasksView {
        TasksView(viewModel: taskViewModel, dependencyContainer: self)
    }
    
    public func editTaskView(for task: ToDo) -> EditTaskView {
        EditTaskView(viewModel: editTaskViewModel(for: task))
    }
    
    public func addTaskView(for category: Category) -> AddTaskView {
        AddTaskView(viewModel: addTaskViewModel(for: category))
    }
    
    public var taskViewModel: TaskViewModel {
        TaskViewModel(toDoStorage: storage)
    }
    
    public func editTaskViewModel(for task: ToDo) -> EditTaskViewModel {
        EditTaskViewModel(task: task, toDoStorage: storage)
    }
    
    public func addTaskViewModel(for category: Category) -> AddTaskViewModel {
        AddTaskViewModel(category: category, toDoStorage: storage)
    }
}
