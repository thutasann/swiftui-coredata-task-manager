//
//  Home.swift
//  Task Manager
//
//  Created by Thuta sann on 12/12/22.
//

import SwiftUI

struct Home: View {
    
    @StateObject var taskModel: TaskViewModel = .init()
    
    // MARK: Matched Geometry NameSpace
    @Namespace var animation
    
    // MARK: Environment Values
    @Environment(\.self) var env
    
    // MARK: - Fetching Task
    @FetchRequest(
        entity: Task.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Task.deadline, ascending: false)],
        predicate: nil,
        animation: .easeInOut
    ) var tasks: FetchedResults<Task>
    
    
    var body: some View {
        
        ScrollView(.vertical, showsIndicators: false){
            VStack{
                
                // MARK: Header Texts
                VStack (alignment: .leading, spacing: 8){
                    Text("Welcome Back")
                        .font(.callout)
                    Text("Here is Update Today.")
                        .font(.title2.bold())
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                // MARK: Custom Segmented Bar
                CustomSegmentedBar()
                    .padding(.top, 5)
                
                // MARK: Task View
                TaskVIew()
                
                
            }
            .padding()
        }
        .overlay(alignment: .bottom){
            // MARK: Add Button
            Button{
                taskModel.openEditTask.toggle()
            }
            label: {
                Label{
                    Text("Add Task")
                        .font(.callout)
                        .fontWeight(.semibold)
                } icon: {
                    Image(systemName: "plus.app.fill")
                }
                .foregroundColor(.white)
                .padding(.vertical, 12)
                .padding(.horizontal)
                .background(.black, in: Capsule())
            }
            // MARK: Linear Gradient BG
            .padding(.top, 10)
            .frame(maxWidth: .infinity)
            .background{
                LinearGradient(colors: [
                    .white.opacity(0.05),
                    .white.opacity(0.4),
                    .white.opacity(0.7),
                    .white
                ], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            }
        }
        .fullScreenCover(isPresented: $taskModel.openEditTask) {
            taskModel.resetTaskData()
        } content: {
            AddNewTask()
                .environmentObject(taskModel)
        }
        
    }
    
    // MARK: - Custom Segmented Bar (ViewBuilder)
    @ViewBuilder
    func CustomSegmentedBar() -> some View{
        let tabs = ["Today", "Upcoming", "Task Done"]
        
        HStack(spacing: 10){
            ForEach(tabs, id: \.self) { tab in
                Text(tab)
                    .font(.callout)
                    .fontWeight(.semibold)
                    .scaleEffect(0.9)
                    .foregroundColor(taskModel.currentTab == tab ? .white : .black)
                    .padding(.vertical, 6)
                    .frame(maxWidth: .infinity)
                    .background{
                        if taskModel.currentTab == tab {
                            Capsule()
                                .fill(.black)
                                .matchedGeometryEffect(id: "TAB", in: animation)
                        }
                    }
                    .contentShape(Capsule())
                    .onTapGesture {
                        withAnimation{
                            taskModel.currentTab = tab
                        }
                    }
            }
        }
        
    }
    
    // MARK: - TaskView (ViewBuilder)
    @ViewBuilder
    func TaskVIew() -> some View{
        LazyVStack (spacing: 20){
            
            // MARK: Custom Filtered Request View
            DynamicFilteredView(currentTab: taskModel.currentTab) { (task: Task) in
                TaskRowView(task: task)
            }
        }
        .padding(.top, 20)
    }
    
    // MARK: - Task Row View (ViewBuilder)
    @ViewBuilder
    func TaskRowView(task: Task) -> some View{
        VStack (alignment: .leading, spacing: 10){
            HStack{
                Text(task.type ?? "")
                    .font(.callout)
                    .padding(.vertical, 5)
                    .padding(.horizontal, 5)
                    .background{
                        Capsule()
                            .fill(.white.opacity(0.3))
                    }
                
                Spacer()
                
                // MARK: Edit Button Only For Non-completed Tasks
                if !task.isCompleted{
                    Button{
                        taskModel.editTask = task
                        taskModel.openEditTask = true
                        taskModel.setupTask()
                    } label: {
                        Image(systemName: "square.and.pencil")
                            .foregroundColor(.black)
                    }
                }
            }
            
            Text(task.title ?? "")
                .font(.title2.bold())
                .foregroundColor(.black)
                .padding(.vertical, 10)
            
            HStack(alignment: .bottom, spacing: 0) {
                VStack(alignment: .leading, spacing: 10){
                    Label{
                        Text((task.deadline ?? Date()).formatted(date: .long, time: .omitted))
                    } icon: {
                        Image(systemName: "calendar")
                    }
                    .font(.caption)
                    
                    Label{
                        Text(
                            (task.deadline ?? Date()).formatted(date: .omitted, time: .shortened)
                        )
                    } icon: {
                        Image(systemName: "clock")
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                if !task.isCompleted{
                    Button{
                        // MARK: Completing Core Data
                        task.isCompleted.toggle()
                        try? env.managedObjectContext.save()
                    } label: {
                        Circle()
                            .strokeBorder(.black, lineWidth: 1.5)
                            .frame(width: 25, height: 25)
                            .contentShape(Circle())
                    }
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background{
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color(task.color ?? "Yellow"))
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
