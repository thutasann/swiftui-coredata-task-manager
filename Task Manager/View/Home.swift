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
                
                
            }
            .padding()
        }
        .overlay(alignment: .bottom){
            // MARK: Add Button
            Button{
                taskModel.openEditTask.toggle()
            } label: {
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
            AddNewTask()
                .environmentObject(taskModel)
        }
        
    }
    
    // MARK: - Custom Segmented Bar
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
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
