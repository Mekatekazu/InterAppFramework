//
//  Archivable.swift
//  InterAppFramework
//
//  Created by Александр Соломатов on 18/10/2018.
//  Copyright © 2018 Александр Соломатов. All rights reserved.
//

import Foundation

protocol Archivable: Codable {
    func archiveData() throws -> NSMutableData
    static func unarchiveObject(fromData data: Data) -> Self?
}

extension Archivable {
    func archiveData() throws -> NSMutableData {
        let mutableData = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: mutableData)
        try archiver.encodeEncodable(self, forKey: NSKeyedArchiveRootObjectKey)
        archiver.finishEncoding()
        return mutableData
    }
    
    static func unarchiveObject(fromData data: Data) -> Self? {
        let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
        guard let command = try? unarchiver.decodeTopLevelDecodable(self, forKey: NSKeyedArchiveRootObjectKey) else {
            return nil
        }
        
        return command
    }
}
