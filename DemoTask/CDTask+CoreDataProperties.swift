//
//  CDTask+CoreDataProperties.swift
//  DemoTask
//
//  Created by Sarvesh Gundi on 11/04/21.
//
//

import Foundation
import CoreData


extension CDTask {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDTask> {
        return NSFetchRequest<CDTask>(entityName: "CDTask")
    }

    @NSManaged public var taskDate: Date?
    @NSManaged public var taskTitle: String?
    @NSManaged public var taskDescription: String?
    @NSManaged public var taskId: UUID?

    func convertToTask() -> Task
    {
        return Task(id: self.taskId!, taskName: self.taskTitle!, taskDescription: self.taskDescription!, taskDate: self.taskDate!)
    }
    
}

extension CDTask : Identifiable {

}
