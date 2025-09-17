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
    
    lazy var weatherService: WeatherService = {
        WeatherService()
    }()
    
    public var weatherContainer: WeatherDependencyContainer {
        WeatherDependencyContainer(dependencyContainer: self)
    }

    public var toDoContainer: ToDoDependencyContainer {
        ToDoDependencyContainer(dependencyContainer: self)
    }
}

final class WeatherDependencyContainer {
    private let dependencyContainer: DependencyContainer
    
    init(dependencyContainer: DependencyContainer) {
        self.dependencyContainer = dependencyContainer
    }
    
    public var view: AnyView {
        return AnyView(weatherView)
    }
    
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
        WeatherViewModel(weatherService: dependencyContainer.weatherService)
    }
    
    public var dayToDayWeatherViewModel: DayToDayViewModel {
        DayToDayViewModel(weatherService: dependencyContainer.weatherService)
    }
    
    public var hourToHourWeatherViewModel: HourToHourWeatherViewModel {
        HourToHourWeatherViewModel(weatherService: dependencyContainer.weatherService)
    }
}

final class ToDoDependencyContainer {
    private let dependencyContainer: DependencyContainer
    
    init(dependencyContainer: DependencyContainer) {
        self.dependencyContainer = dependencyContainer
    }
    
    public var view: AnyView {
        return AnyView(tasksView)
    }
    
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
        TaskViewModel(toDoStorage: dependencyContainer.storage)
    }
    
    public func editTaskViewModel(for task: ToDo) -> EditTaskViewModel {
        EditTaskViewModel(task: task, toDoStorage: dependencyContainer.storage)
    }
    
    public func addTaskViewModel(for category: Category) -> AddTaskViewModel {
        AddTaskViewModel(category: category, toDoStorage: dependencyContainer.storage)
    }
}
