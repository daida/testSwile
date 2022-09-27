//
//  InternetCheckerMock.swift
//  TestSwile
//
//  Created by Nicolas Bellon on 25/09/2022.
//

import Foundation

/// Check if internet is alvailable (mock object will always return false)
class InternetCheckerMock: InternetCheckerInterface {

    init(isConnected: Bool = false) {
        self.isConnected = isConnected
    }

    var isConnected: Bool
}
