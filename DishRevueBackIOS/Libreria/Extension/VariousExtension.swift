//
//  VariousExtension.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 16/10/23.
//

import Foundation
import SwiftUI

#if canImport(Charts)
extension UICollectionReusableView {
    
    override open var backgroundColor: UIColor? {
        get { .clear }
        set { }
    }
}
#endif

extension CGFloat {
    
    static let vStackLabelBodySpacing:CGFloat = 5
    static let vStackBoxSpacing:CGFloat = 10
    
}
