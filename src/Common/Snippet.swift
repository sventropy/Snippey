//
//  Emoticon.swift
//  SnippeyKeyboard
//
//  Created by Hennessen, Sven on 29.10.17.
//  Copyright © 2017 Hennessen, Sven. All rights reserved.
//

import UIKit

/// Wrapper struct for snippets. Enables easy (de-)serialization
struct Snippet: Codable {

    // MARK: - Properties

    /// The snippets text
    let text: String
}
