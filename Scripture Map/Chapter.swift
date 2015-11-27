//
//  Chapter.swift
//  Scripture Map
//
//  Created by Kyle on 11/26/15.
//  Copyright © 2015 Kyle Pontius. All rights reserved.
//

import Foundation
import SQLite

class Chapter {
    var id: Int
    var bookId: Int
    var chapter: Int
    
    init(fromRow: Row) {
        id = fromRow.get(gScriptureId)
        bookId = fromRow.get(gScriptureBookId)
        chapter = fromRow.get(gScriptureChapter)
    }
}