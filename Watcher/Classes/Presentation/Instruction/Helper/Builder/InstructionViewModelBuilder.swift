//
//  InstructionViewModelBuilder.swift
//  Watcher
//
//  Created by Петр Первухин on 19/03/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import Foundation

struct InstructionViewModelBuilder {
      
    // MARK: - Building methods

    public func buildViewModel() -> InstructionViewModel {
        let instructionViewModel = InstructionViewModel(sectionViewModels: buildSectionViewModels())
        return instructionViewModel
    }
    
    
    private func buildSectionViewModels() -> [InstructionSectionViewModel] {
        
        // swiftlint:disable line_length
        let greetingsSection = buildGreetingsSectionViewModel(title: "Инструкция",
                                                              text: "Привет, робот! Здесь есть вся информация о том, как и куда списывать часы и ответы на некоторые твои вопросы.")
        let infoSection1 = buildInfoSectionViewModel(title: "Зачем списывать часы?",
                                                     text: "Чтобы получать оплату за нашу работу и принимать правильные решения о развитии компании.")
        let infoSection2 = buildInfoSectionViewModel(title: "Как часто списывать?", 
                                                     text: "Каждый день, потому что занимает всего 2 минуты, а в конце недели никто уже и не помнит, что делали и как долго.")
        let infoSection3 = buildInfoSectionViewModel(title: "Ясно. Это всё?", 
                                                     text: "Списывай честно: не списывай план, списывай факт.")
        // swiftlint:enable line_length
        
        let complexSection = buildComplexSectionViewModel()
        return [greetingsSection, complexSection, infoSection1, infoSection2, infoSection3]
    }
    
    
    private func buildComplexSectionViewModel() -> InstructionSectionViewModel {
        let instructionRecordsViewModel = readInstructionFile()  
        return InstructionSectionViewModel(title: "Куда списывать?", 
                                           type: .complex,
                                           cellModels: instructionRecordsViewModel)
    }
    
    
    private func buildGreetingsSectionViewModel(title: String, text: String) -> InstructionSectionViewModel {
        let infoCell = InstructionInfoViewModel(text: text)
        let cellModels = [infoCell]
        return InstructionSectionViewModel(title: title, 
                                           type: .greetings, 
                                           cellModels: cellModels)
    }
    
    
    private func buildInfoSectionViewModel(title: String, text: String) -> InstructionSectionViewModel {
        let infoCell = InstructionInfoViewModel(text: text)
        let cellModels = [infoCell]
        return InstructionSectionViewModel(title: title, 
                                           type: .info, 
                                           cellModels: cellModels)
    }
    

    // MARK: - Read JSON

    private func readInstructionFile() -> [InstructionRecordViewModel] {
        if let path = Bundle.main.path(forResource: "Instruction", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedRead)
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let decodedData = try decoder.decode([InstructionRecordViewModel].self, from: data)
                return decodedData
            } catch {
                print(error)
            }
        }
        return [InstructionRecordViewModel]()
    }
    
}
