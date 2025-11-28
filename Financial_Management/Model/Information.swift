//
//  Information.swift
//  Financial_Management
//
//  Created by Lã Quốc Trung on 5/8/24.
//

import Foundation
import CoreData

final class Information: NSManagedObject, Identifiable {
    
    @NSManaged var dateOfInfor: Date
    @NSManaged var name: String
    @NSManaged var imageName: String
    @NSManaged var money: String
    @NSManaged var note: String
    @NSManaged var spentOrGained: Bool
    @NSManaged var userId: String?
    
    override func awakeFromInsert() {
        super.awakeFromInsert()
        
        setPrimitiveValue(Date.now, forKey: "dateOfInfor")
        setPrimitiveValue(true, forKey: "spentOrGained")
        // Default to current user if available
        let current = UserDefaults.standard.string(forKey: "currentUserId") ?? "default"
        setPrimitiveValue(current, forKey: "userId")
    }
}

extension Information {
    private static var informationFetchRequest: NSFetchRequest<Information> {
        NSFetchRequest(entityName: "Information")
    }
    
    static func all() -> NSFetchRequest<Information> {
        let request: NSFetchRequest<Information> = informationFetchRequest
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \Information.dateOfInfor, ascending: true)    // Sort information showed by date
        ]
        return request
    }

    static func allForUser(userId: String) -> NSFetchRequest<Information> {
        let request: NSFetchRequest<Information> = informationFetchRequest
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \Information.dateOfInfor, ascending: true)
        ]
        request.predicate = NSPredicate(format: "userId == %@", userId)
        return request
    }

    static func allForCurrentUser() -> NSFetchRequest<Information> {
        let uid = UserDefaults.standard.string(forKey: "currentUserId") ?? "default"
        let request: NSFetchRequest<Information> = informationFetchRequest
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \Information.dateOfInfor, ascending: true)
        ]
        // Include legacy rows where userId is nil or empty when using the default user
        if uid == "default" {
            request.predicate = NSPredicate(format: "(userId == %@) OR (userId == nil) OR (userId == '')", uid)
        } else {
            request.predicate = NSPredicate(format: "userId == %@", uid)
        }
        return request
    }
}

//extension Information {         // Working on previews
//    
//    @discardableResult
//    static func makePreview(count: Int, in context: NSManagedObjectContext) -> [Information] {
//        var informations = [Information]()
//        for i in 0..<count {
//            let information = Information(context: context)
//            information.name = "Food"
//            information.dateOfInfor = Calendar.current.date(byAdding: .day,
//                                                            value: -i,
//                                                            to: .now) ?? .now
//            information.money = "\(i)0000000"
//            information.note = "This is preview for item \(i)"
//            information.spentOrGained = Bool.random()
//            information.imageName = "food"
//            informations.append(information)
//        }
//        return informations
//    }
//    
//    static func preview(context: NSManagedObjectContext = InformationProvider.shared.viewContext) -> Information {
//        return makePreview(count: 1, in: context)[0]
//    }
//    
//    static func empty(context: NSManagedObjectContext = InformationProvider.shared.viewContext) -> Information {
//        return Information(context: context)
//    }
//}
