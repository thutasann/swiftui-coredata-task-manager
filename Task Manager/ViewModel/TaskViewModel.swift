//
//  TaskViewModel.swift
//  Task Manager
//
//  Created by Thuta sann on 12/12/22.
//

import SwiftUI
import CoreData

class TaskViewModel: ObservableObject{
    
    @Published var currentTab: String = "Today"
    
    // MARK: New Task Properties
    @Published var openEditTask: Bool = false
    @Published var taskTitle: String = ""
    @Published var taskColor: String = "Yellow"
    @Published var taskDeadline: Date = Date()
    @Published var taskType: String = "Basic"
    @Published var showDatePicker: Bool = false
    
    // MARK: - Adding Task to Core Data
    func addTask(context: NSManagedObjectContext) -> Bool{
        let task = Task(context: context)
        task.title = taskTitle
        task.color = taskColor
        task.deadline = taskDeadline
        task.type = taskType
        
        if let _ = try? context.save(){
            return true
        } else{
            return false
        }
    }
    
    // MARK: - Restting Data
    func resetTaskData(){
        taskType = "Basic"
        taskColor = "Yellow"
        taskTitle = ""
        taskDeadline = Date()
    }
    
}
