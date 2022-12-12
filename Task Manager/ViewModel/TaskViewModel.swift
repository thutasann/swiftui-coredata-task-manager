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
    
}
