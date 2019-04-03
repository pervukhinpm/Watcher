//
//  InstructionViewModel.swift
//  Watcher
//
//  Created by Петр Первухин on 19/03/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import Foundation

enum InstructionCellModelType {
    case greetings
    case complex
    case info
}

protocol InstructionCellModelProtocol {
}

struct InstructionInfoViewModel: InstructionCellModelProtocol {
    var text: String
}

struct InstructionRecordViewModel: Codable, InstructionCellModelProtocol {
    var title: String?
    var activityText: String
    var timeLogText: String
    var verifiesText: String
}

struct InstructionSectionViewModel {
    var title: String
    var type: InstructionCellModelType
    let cellModels: [InstructionCellModelProtocol]
}

struct InstructionViewModel {
    let sectionViewModels: [InstructionSectionViewModel]
}
