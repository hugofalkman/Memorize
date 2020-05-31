//
//  Array+Only.swift
//  Memorize
//
//  Created by H Hugo Falkman on 31/05/2020.
//  Copyright © 2020 H Hugo Falkman. All rights reserved.
//

import Foundation

extension Array {
    var only: Element? {
        count == 1 ? first : nil
    }
}
