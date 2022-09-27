//
//  ImageModel.swift
//  TestSwile
//
//  Created by Nicolas Bellon on 21/09/2022.
//

import Foundation

// MARK: - ImageModel

/// Represent an Image icon to display
/// Contain a URL and a category identifier
struct ImageModel: Codable {

    /// Image URL
    let url: String?

    /// Image Category
    let category: String
}
