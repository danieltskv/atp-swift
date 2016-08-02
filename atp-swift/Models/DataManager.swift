//
//  DataManager.swift
//  atp-swift
//
//  Created by Daniel Tsirulnikov on 27.7.2016.
//  Copyright © 2016 Daniel Tsirulnikov. All rights reserved.
//

import Foundation
import ObjectMapper

class DataManager {
    
     // MARK: Properties
    
    static let sharedInstance = DataManager()
    var currentUser: User?
    
    // MARK: Archiving Paths
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("user")
    
    // MARK: - Initialization

    private init() {} //This prevents others from using the default '()' initializer for this class.

    // MARK: - Convenience

    func loadLocalData() {
        
        if let user = loadUser() {
            self.currentUser = user
        }
    }
    
    func saveUser() {
        guard let user = currentUser else {
            return
        }
        
        let JSONString = Mapper().toJSONString(user, prettyPrint: true)
        
        do {
            try JSONString?.writeToFile(DataManager.ArchiveURL.path!, atomically: true, encoding: NSUTF8StringEncoding)
        }
        catch {
            print("error writing user to file")
            return
        }
        
        print("user saved to: \(DataManager.ArchiveURL.path!)")
    }
    
    func loadUser() -> User? {
        do {
            let JSONString = try String(contentsOfFile: DataManager.ArchiveURL.path!, encoding: NSUTF8StringEncoding)
            let user = Mapper<User>().map(JSONString)
            return user
        }
        catch {
            print("error reading user from file")
            return nil
        }
        
       //return NSKeyedUnarchiver.unarchiveObjectWithFile(DataManager.ArchiveURL.path!) as? User
    }
    
    func removeUser() {
        let fileManager = NSFileManager.defaultManager()
        
        do {
            try fileManager.removeItemAtPath(DataManager.ArchiveURL.path!)
        }
        catch let error as NSError {
            print("error removing user file: \(error)")
        }
        
        self.currentUser = nil
    }
    
    private func userFilename() -> String? {
        guard let documentsDirectory = documentsDirectoryURL() else {
            return nil
        }
        
        guard let path: NSURL = documentsDirectory.URLByAppendingPathComponent("user") else {
           return nil
        }
        
        var pathString = path.absoluteString
        pathString = pathString.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "file://"))
        
        return pathString
    }
    
    func documentsDirectoryURL() -> NSURL? {
        //static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
        //return DocumentsDirectory
        return NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first
    }
}