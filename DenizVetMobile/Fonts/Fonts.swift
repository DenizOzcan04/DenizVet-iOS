//
//  Fonts.swift
//  DenizVetMobile
//
//  Created by Deniz Özcan on 14.10.2025.
//

import Foundation
import SwiftUI
func GilroyFont(isBold: Bool = false, size: CGFloat) -> Font {
    if isBold {
        return Font.custom("Gilroy-ExtraBold", size: size)
    }else {
        return Font.custom("Gilroy-Light", size: size)
    }
}

