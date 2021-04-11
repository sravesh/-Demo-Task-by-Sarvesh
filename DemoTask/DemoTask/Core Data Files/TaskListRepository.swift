//
//  CoreDataRepository.swift
//  Demo_App
//
//  Created by Sarvesh Gundi on 11/04/21.
//

import Foundation
import CoreData


protocol TaskListRepository {
    func create(task: Task)
    func getAll() -> [Task]?
    func get(byIdentifier id: UUID) -> Task?
    func update(task: Task) -> Bool
    func delete(id: UUID) -> Bool
}

struct TaskListDataRepository : TaskListRepository
{
    
    func create(task: Task) {

        let cdTask = CDTask(context: PersistentStorage.shared.context)
        cdTask.taskId = task.id
        cdTask.taskTitle = task.taskName
        cdTask.taskDescription = task.taskDescription
        cdTask.taskDate = task.taskDate
        PersistentStorage.shared.saveContext()
    }

    func getAll() -> [Task]? {

        let result = PersistentStorage.shared.fetchManagedObject(managedObject: CDTask.self)

        var task : [Task] = []

        result?.forEach({ (cdTask) in
            task.append(cdTask.convertToTask())
        })

        return task
    }

    func get(byIdentifier id: UUID) -> Task? {

        let result = getCDTask(byIdentifier: id)
        guard result != nil else {return nil}
        return result?.convertToTask()
    }

    func update(task: Task) -> Bool {

        let cdTask = getCDTask(byIdentifier: task.id)
        guard cdTask != nil else {return false}
        cdTask?.taskTitle = task.taskName
        cdTask?.taskDescription = task.taskDescription
        PersistentStorage.shared.saveContext()
        return true
    }

    func delete(id: UUID) -> Bool {

        let cdTask = getCDTask(byIdentifier: id)
        guard cdTask != nil else {return false}

        PersistentStorage.shared.context.delete(cdTask!)
        PersistentStorage.shared.saveContext()
        return true
    }


    private func getCDTask(byIdentifier id: UUID) -> CDTask?
    {
        let fetchRequest = NSFetchRequest<CDTask>(entityName: "CDTask")
        print(fetchRequest)
        let predicate = NSPredicate(format: "id==%@", id as CVarArg)

        fetchRequest.predicate = predicate
        print(fetchRequest)
        do {
            let result = try PersistentStorage.shared.context.fetch(fetchRequest).first

            guard result != nil else {return nil}

            return result

        } catch let error {
            debugPrint(error)
        }

        return nil
    }
    
    
    
    
}



struct TaskManager
{
    private let _taskDataRepository = TaskListDataRepository()

    func createTask(task: Task) {
        _taskDataRepository.create(task: task)
    }

    func fetchTask() -> [Task]? {
        return _taskDataRepository.getAll()
    }

    func fetchEmployee(byIdentifier id: UUID) -> Task?
    {
        return _taskDataRepository.get(byIdentifier: id)
    }

    func updateEmployee(task: Task) -> Bool {
        return _taskDataRepository.update(task: task)
    }

    func deleteTask(id: UUID) -> Bool {
        return _taskDataRepository.delete(id: id)
    }
}

