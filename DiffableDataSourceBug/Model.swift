//
//  Model.swift
//  DiffableDataSourceBug
//
//  Created by Emilio Pavia on 19/02/2020.
//  Copyright © 2020 Emilio Pavia. All rights reserved.
//

import UIKit

class Model {
    let identifier: Int
    var text: String
    
    var textColor: UIColor {
        if Int(text) != nil {
            return UIColor.black
        }
        return UIColor.red
    }
    
    init(identifier: Int, text: String) {
        self.identifier = identifier
        self.text = text
    }
}

extension Model: Hashable {
    static func == (lhs: Model, rhs: Model) -> Bool {
        lhs.identifier == rhs.identifier
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
}
