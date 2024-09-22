//
//  ToDoList+CoreDataProperties.swift
//  coreDataToDoList
//
//  Created by Nachiket Shilwant on 28/08/24.
//
//

import Foundation
import CoreData


extension ToDoList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoList> {
        return NSFetchRequest<ToDoList>(entityName: "ToDoList")
    }

    @NSManaged public var createdAt: Date?
    @NSManaged public var toDo: String?

}

extension ToDoList : Identifiable {

}
