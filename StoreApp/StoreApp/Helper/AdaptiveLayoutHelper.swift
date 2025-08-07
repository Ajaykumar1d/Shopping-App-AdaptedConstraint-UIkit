//
//  AdaptiveLayoutHelper.swift
//  StoreApp
//
//  Created by Giri on 4/18/25.
//

import UIKit

enum Dimension {
    case width
    case height
}

enum Device {
    case iPhoneSE3
    case iPhone11Pro
    case iPhone11ProMax
    case iPhone12Mini
    case iPhone13
    case iPhone15Series
    
    static let baseScreenSize: Device = .iPhone15Series
}

extension Device: RawRepresentable {
    typealias RawValue = CGSize
    
    init?(rawValue: CGSize) {
        switch rawValue {
        case CGSize(width: 375, height: 667):
            self = .iPhoneSE3
        case CGSize(width: 414, height: 736):
            self = .iPhone11Pro
        case CGSize(width: 414, height: 896):
            self = .iPhone11ProMax
        case CGSize(width: 360, height: 780):
            self = .iPhone12Mini
        case CGSize(width: 390, height: 844):
            self = .iPhone13
        case CGSize(width: 430, height: 932):
            self = .iPhone15Series
        default:
            return nil
        }
    }
    
    var rawValue: CGSize {
        switch self {
        case .iPhoneSE3:
            return CGSize(width: 375, height: 667)
        case .iPhone11Pro:
            return CGSize(width: 375, height: 812)
        case .iPhone11ProMax:
            return CGSize(width: 414, height: 896)
        case .iPhone12Mini:
            return CGSize(width: 360, height: 780)
        case .iPhone13:
            return CGSize(width: 390, height: 844)
        case .iPhone15Series:
            return CGSize(width: 430, height: 932)
        }
    }
}

class AdaptedConstraint: NSLayoutConstraint {
    
    // MARK: - Properties
    var initialConstant: CGFloat?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        saveConstant()
        adaptConstant()
    }
    
}

// MARK: - Adapt constant
extension AdaptedConstraint {
    func adaptConstant() {
        if let dimension = getDimension(from: firstAttribute) {
            self.constant = adapted(dimensionSize: self.constant, to: dimension)
        }
    }
    
    func getDimension(from attribute: NSLayoutConstraint.Attribute) -> Dimension? {
        switch attribute {
        case .left, .right, .leading, .trailing, .width, .centerX, .leftMargin,
             .rightMargin, .leadingMargin, .trailingMargin, .centerXWithinMargins:
            return .width
        case .top, .bottom, .height, .centerY, .lastBaseline, .firstBaseline,
             .topMargin, .bottomMargin, .centerYWithinMargins:
            return .height
        case .notAnAttribute:
            return nil
        @unknown default:
            return nil
        }
    }
}
var dimension: Dimension {
    UIDevice.current.orientation.isPortrait ? .width : .height
}

func resized(size: CGSize, basedOn dimension: Dimension) -> CGSize {
    let screenWidth  = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height
    
    var ratio:  CGFloat = 0.0
    var width:  CGFloat = 0.0
    var height: CGFloat = 0.0
    
    switch dimension {
    case .width:
        ratio  = size.height / size.width
        width  = screenWidth * (size.width / Device.baseScreenSize.rawValue.width)
        height = width * ratio
    case .height:
        ratio  = size.width / size.height
        height = screenHeight * (size.height / Device.baseScreenSize.rawValue.height)
        width  = height * ratio
    }
    
    return CGSize(width: width, height: height)
}

func adapted(dimensionSize: CGFloat, to dimension: Dimension = dimension) -> CGFloat {
    let screenWidth  = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height
     
    var ratio: CGFloat = 0.0
    var resultDimensionSize: CGFloat = 0.0
    
    switch dimension {
    case .width:
        ratio = dimensionSize / Device.baseScreenSize.rawValue.width
        resultDimensionSize = screenWidth * ratio
    case .height:
        ratio = dimensionSize / Device.baseScreenSize.rawValue.height
        resultDimensionSize = screenHeight * ratio
    }
    
    return resultDimensionSize
}

extension CGFloat {
    var adaptedFontSize: CGFloat {
        adapted(dimensionSize: self, to: dimension)
    }
}

extension UIView {
    func updateAdaptedConstraints() {
        let adaptedConstraints = constraints.filter { (constraint) -> Bool in
            return constraint is AdaptedConstraint
        } as! [AdaptedConstraint]
        
        for constraint in adaptedConstraints {
            constraint.resetConstant()
            constraint.awakeFromNib()
        }
    }
}

// MARK: - Reset constant
extension AdaptedConstraint {
    func saveConstant() {
        initialConstant = self.constant
    }
    
    func resetConstant() {
        if let initialConstant = initialConstant {
            self.constant = initialConstant
        }
    }
}

