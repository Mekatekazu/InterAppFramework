//
//  InterAppService.swift
//  InterAppFramework
//
//  Created by Александр Соломатов on 10/10/2018.
//  Copyright © 2018 Александр Соломатов. All rights reserved.
//

import UIKit

/**
 Input protocol for inter-app service
 */
public protocol InterAppInput: class {
    func sendCommand(_ command: IACommand)
    var onCommandAvailable: ((IACommand) -> Void)? { get set }
}

/**
 Service that allows to communicate between applications in same AppGroup.
 Can be used in Objective-C
 */
@objc
open class InterAppService: NSObject, InterAppInput {
    
    @objc
    public static let shared: InterAppService = InterAppService()
    
    public var onCommandAvailable: ((IACommand) -> Void)?
    
    private let objectID = UUID()
    
    private let groupID: String = "group.organization.name"
    private let portalID: String = "innerAppPortal"
    
    private lazy var coordinator: NSFileCoordinator = NSFileCoordinator()
    
    private lazy var portalQueue: OperationQueue = {
        let operationQueue = OperationQueue()
        operationQueue.maxConcurrentOperationCount = 1
        return operationQueue
    }()
    
    // MARK: - Initialization
    
    @objc
    public override init() {
        super.init()
        
        self.startObservingFileChanges()
    }
    /*
    @objc
    public convenience init(withGroupIdentifier group: String, andPortalID portal: String) {
        self.groupID = group
        self.portalID = portal
        
        self.init()
    }
    */
    
    deinit {
        self.coordinator.cancel()
        self.portalQueue.cancelAllOperations()
    }
    
    // MARK: - Sender/Observer
    
    private var fileMonitor: FileMonitorService?
    
    private enum DictKey: String {
        case sender, payload
    }
    
    public func sendCommand(_ command: IACommand) {
        guard let url = fileURL() else { return }
        
        var errorLocal: NSError?
        portalQueue.addOperation {
            [weak self] in
            
            self?.coordinator.coordinate(writingItemAt: url, options: .forReplacing, error: &errorLocal, byAccessor: { (url) in
                do {
                    let data = try command.archiveData()
                    self?.archiveData(data, url: url)
                } catch {
                    debugPrint("ERROR", error.localizedDescription)
                }
                
            })
        }
    }
    
    private func startObservingFileChanges() {
        guard let filePath = fileURL()?.path else { return  }
        
        self.fileMonitor = FileMonitorService(withFilePath: filePath)
        self.fileMonitor?.onFileEvent = {
            [weak self] in
            if let data = self?.openData(filePath) as? Data, let command = IACommand.unarchiveObject(fromData: data) {
                self?.onCommandAvailable?(command)
            }
        }
    }
    
    // MARK: - Archieving
    internal func archiveData(_ data: Any, url: URL) {
        let dictToSave: [String: Any?] = [DictKey.sender.rawValue: self.objectID,
                                          DictKey.payload.rawValue: data]
        
        let dictData = NSKeyedArchiver.archivedData(withRootObject: dictToSave)
        try? dictData.write(to: url)
    }
    
    internal func openData(_ filePath: String) -> Any? {
        let dict = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? [String: Any?] ?? [:]
        
        guard let senderID = dict[DictKey.sender.rawValue] as? UUID, senderID != self.objectID else {
            return nil
        }
        
        guard let payload = dict[DictKey.payload.rawValue], payload != nil else {
            return nil
        }
        
        return payload
    }
    
    // MARK: - Utility
    internal func containerURL() -> URL? {
        return FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: groupID)
    }
    
    internal func fileURL() -> URL? {
        return containerURL()?.appendingPathComponent(portalID).appendingPathExtension("serviceContainer")
    }
}
