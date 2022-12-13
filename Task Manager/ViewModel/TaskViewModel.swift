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
    
    // MARK: - Editing Existing Core Data
    @Published var editTask: Task?
    
    // MARK: - Adding Task to Core Data
    func addTask(context: NSManagedObjectContext) -> Bool{
        
        // MARK: Updating Existing Task
        var task: Task!
        
        if let editTask = editTask {
            task = editTask
        }else{
            task = Task(context: context)
        }
        task.title = taskTitle
        task.color = taskColor
        task.deadline = taskDeadline
        task.type = taskType
        task.isCompleted = false
        
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
    
    // MARK: - If Edit Task is available, the Setting Existing Data
    func setupTask(){
        if let editTask = editTask{
            taskType = editTask.type ?? "Basic"
            taskColor = editTask.color ?? ""
            taskTitle = editTask.title ?? ""
            taskDeadline = editTask.deadline ?? Date()
        }
    }
    
}
