//
//  Array+Only.swift
//  Memorize
//
//  Created by Vicente Montoya on 8/14/20.
//  Copyright © 2020 Vicente Montoya. All rights reserved.
//

import Foundation

extension Array{
    var only: Element?{
        self.count == 1 ? first : nil
    }
}
