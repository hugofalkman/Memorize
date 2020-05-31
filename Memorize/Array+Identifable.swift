//
//  Array+Identifable.swift
//  Memorize
//
//  Created by H Hugo Falkman on 31/05/2020.
//  Copyright © 2020 H Hugo Falkman. All rights reserved.
//

import Foundation

extension Array where Element: Identifiable {
    func firstIndex(matching: Element) -> Int? {
        for index in 0..<self.count {
            if self[index].id == matching.id {
                return index
            }
        }
        return nil
    }
}
