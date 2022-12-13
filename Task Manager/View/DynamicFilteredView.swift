//
//  DynamicFilteredView.swift
//  Task Manager
//
//  Created by Thuta sann on 12/13/22.
//

import SwiftUI
import CoreData

struct DynamicFilteredView<Content : View, T>: View where T : NSManagedObject {
    
    // MARK: Core Data Request
    @FetchRequest var request : FetchedResults<T>
    let content: (T) -> Content
    
    // MARK: Buiding Custom ForEach which will give you CoreData Object to Build View
    init(currentTab: String, @ViewBuilder content: @escaping (T) -> Content){
        
        // MARK: Predicate to Filter current date Tasks
        let calendar = Calendar.current
        var predicate: NSPredicate!
        
        if currentTab == "Today"{
            
            let today = calendar.startOfDay(for: Date())
            let tomorrow = calendar.date(byAdding: .day, value: 1, to: today)!
            let filterKey = "deadline"
            
            // This will Fetch task betwenn today and tomorrow which is 24HR
            // 0 - false, 1 - true
            predicate = NSPredicate(format: "\(filterKey) >= %@ AND \(filterKey) < %@ AND isCompleted == %i", argumentArray: [today, tomorrow, 0])
            
        } else if currentTab == "Upcoming"{
            
            let today = calendar.startOfDay(for: calendar.date(byAdding: .day, value: 1, to: Date())!)
            let tomorrow = Date.distantFuture
            let filterKey = "deadline"
            
         
            predicate = NSPredicate(format: "\(filterKey) >= %@ AND \(filterKey) < %@ AND isCompleted == %i", argumentArray: [today, tomorrow, 0])
            
            
        } else{
            
        }
        
        
        // MARK: Initializing Request With NSPredicate
        _request = FetchRequest(
            entity: T.entity(),
            sortDescriptors: [.init(keyPath: \Task.deadline, ascending: false)],
            predicate: predicate
        )
        
        self.content = content
        
        
    }
    
    var body: some View {
        Group{
            if request.isEmpty{
                Text("No Result Found!")
                    .font(.system(size: 16))
                    .fontWeight(.light)
                    .offset(y: 100)
            }
            else{
                ForEach(request, id: \.objectID){ object in
                    self.content(object)
                }
            }
        }
    }
}
