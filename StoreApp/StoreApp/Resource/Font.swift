//
//  Font.swift
//  StoreApp
//
//  Created by Giri on 4/18/25.
//

import UIKit

enum InterFont {
    static func interBold(size: CGFloat) -> UIFont {
        UIFont(name: "Inter-Bold", size: size.adaptedFontSize)!
    }
    static func interBlack(size: CGFloat) -> UIFont {
        UIFont(name: "Inter-Black", size: size.adaptedFontSize)!
    }
    static func interLight(size: CGFloat) -> UIFont {
        UIFont(name: "Inter-Light", size: size.adaptedFontSize)!
    }
    static func interRegular(size: CGFloat) -> UIFont {
        UIFont(name: "Inter-Regular", size: size.adaptedFontSize)!
    }
    static func interMedium(size: CGFloat) -> UIFont {
        UIFont(name: "Inter-Medium", size: size.adaptedFontSize)!
    }
    static func interSemiBold(size: CGFloat) -> UIFont {
        UIFont(name: "Inter-SemiBold", size: size.adaptedFontSize)!
    }
}

