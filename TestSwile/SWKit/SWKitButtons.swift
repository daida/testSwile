//
//  SWKitButtons.swift
//  TestSwile
//
//  Created by Nicolas Bellon on 25/09/2022.
//

import Foundation
import UIKit

extension SWKit {
    
    class SWBackButton: UIButton {

        override init(frame: CGRect) {
            super.init(frame: frame)
            self.setImage(UIImage(named: "backIcon"), for: .normal)
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}

