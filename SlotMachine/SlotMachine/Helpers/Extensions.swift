//
//  Extensions.swift
//  SlotMachine
//
//  Created by Sunil Maurya on 03/01/24.
//

import SwiftUI

extension Text {
    
    func scoreLabelStyle() -> Text {
        self
            .foregroundStyle(.white)
            .font(.system(size: 10, weight: .bold, design: .rounded))
    }
    
    func scoreNumberStyle() -> Text {
        self
            .foregroundStyle(.white)
            .font(.system(.title, design: .rounded))
            .fontWeight(.heavy)
    }
}
