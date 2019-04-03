//
//  Array+RemoveDuplicates.swift
//  Watcher
//
//  Created by Петр Первухин on 06/03/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import Foundation

extension Array where Element: Equatable {
    
    /// Метод для удаления повторяющихся элементов из массива
    func removingDuplicates() -> Array {
        return reduce(into: []) { result, element in
            if !result.contains(element) {
                result.append(element)
            }
        }
    }
    
}
