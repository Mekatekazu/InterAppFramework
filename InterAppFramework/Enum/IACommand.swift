//
//  IACommand.swift
//  InterAppFramework
//
//  Created by Александр Соломатов on 12/10/2018.
//  Copyright © 2018 Александр Соломатов. All rights reserved.
//

import Foundation

//swiftlint:disable identifier_name

public enum IACommand {
    case Input(InputCommand)
    case Output(OutputCommand)
}

extension IACommand: Archivable, Equatable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .Input(let inputCommand):
            try container.encode(inputCommand)
        case .Output(let outputCommand):
            try container.encode(outputCommand)
        }
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let inputCommand = try? container.decode(InputCommand.self) {
            self = .Input(inputCommand)
            return
        } else if let outputCommand = try? container.decode(OutputCommand.self) {
            self = .Output(outputCommand)
            return
        }
        
        throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Could not find reasonable type to map to JSONValue"))
    }
}
