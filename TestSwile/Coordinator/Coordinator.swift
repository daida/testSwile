//
//  Coordinator.swift
//  TestSwile
//
//  Created by Nicolas Bellon on 21/09/2022.
//

import Foundation
import UIKit

// MARK: - Coordinator

/// Coordinator Protocol
/// All app Coordinator should conform to it
protocol Coordinator {
    var child: [Coordinator] { get }
    var navigationController: UINavigationController { get }
    func start()
    func stop()
}
