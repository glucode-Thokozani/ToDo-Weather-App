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
    init() {}
    
    init(storage: ToDoStorage) {
        self.storage = storage
    }
    
    private(set) lazy var storage: ToDoStorage = {
        ToDoStorage()
    }()

    var toDoRepository: ToDoRepositoryProtocol { storage }
    var categoryRepository: CategoryRepositoryProtocol { storage }
    
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
            dayToDayWeatherView: AnyView(dayToDayWeatherView)
        )
    }
    
    public var dayToDayWeatherView: DayToDayWeatherView {
        DayToDayWeatherView(dailyViewModel: dayToDayWeatherViewModel)
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
    func editTaskView(for task: ToDo) -> EditTaskView
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
        TaskViewModel(toDoRepository: toDoRepository, categoryRepository: categoryRepository)
    }
    
    public func editTaskViewModel(for task: ToDo) -> EditTaskViewModel {
        EditTaskViewModel(task: task, toDoRepository: toDoRepository, categoryRepository: categoryRepository)
    }
    
    public func addTaskViewModel(for category: Category) -> AddTaskViewModel {
        AddTaskViewModel(category: category, toDoRepository: toDoRepository)
    }
}
