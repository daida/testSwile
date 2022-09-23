//
//  InternetChecker.swift
//  TestSwile
//
//  Created by Nicolas Bellon on 21/09/2022.
//

import Foundation
import Network

class InternetChecker: InternetCheckerInterface {

    // MARK: - Private properties

    /// This the queue where the NWPathMonitor will run
    private let queue = DispatchQueue(label: "testTek.internerChecker")

    /// This is the iOS class who will notify if the connection status change
    private let monitor = NWPathMonitor()

    // MARK: Public propeties

    /// if the bool is true, the connection is reachable else it's not
    private(set) var isConnected: Bool

    // MARK: Init

    /// Init InternetChecker, the connection monitoring will start right away
    init() {
        self.monitor.start(queue: queue)
        self.isConnected = false

        self.monitor.pathUpdateHandler = { [weak self] path in
            guard let `self` = self else { return }
            self.isConnected = path.status == .satisfied
        }
    }
}

// MARK: - InternetCheckerIntefrace

/// In order to perform test on API Service and to not operate coupling between the API service and InternetChecker
/// the APIService will use InternetChecker behind an interface
protocol InternetCheckerInterface {
    var isConnected: Bool { get }
}
