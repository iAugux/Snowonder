//
//  ImportArtisan.swift
//  Snowonder
//
//  Created by Aliaksei Karetski on 27.06.17.
//  Copyright © 2017 Karetski. All rights reserved.
//

import Foundation

open class ImportBlockFormatter {
    
    // MARK: - Common properties
    
    public enum Option {
        case uniqueDeclarations
        case sortDeclarations
        case separateCategories
    }
    
    public typealias Options = Set<Option>
    
    /// Formatting options, used to define what optimizations should be done.
    open var options: Options
    
    // MARK: - Initializers
    
    /// Creates new instance with formatting `options`.
    ///
    /// - Parameter options: Formatting options.
    public init(options: Options) {
        self.options = options
    }
    
    // MARK: - Formatter
    
    /// Constructs import declarations lines from `importBlock` parameter using `options` property.
    ///
    /// - Parameter importBlock: Source import declarations block.
    /// - Returns: Constructed lines.
    open func lines(from importBlock: ImportBlock) -> [String] {
        return importBlock.categorizedDeclarations
            .uniqueDeclarations(with: options)
            .sortedDeclarations(with: options)
            .separatedCategories(with: options, using: importBlock.categories)
            .flatDeclarations(with: options, using: importBlock.categories)
    }
}

private extension Dictionary where Key == ImportCategory, Value == ImportDeclarations {
    
    func uniqueDeclarations(with options: ImportBlockFormatter.Options) -> CategorizedImportDeclarations {
        guard options.contains(.uniqueDeclarations) else {
            return self
        }
        
        return mapValues { (category, declarations) -> ImportDeclarations in
            return declarations.reduce([]) { $0.contains($1) ? $0 : $0 + [$1] }
        }
    }
    
    func sortedDeclarations(with options: ImportBlockFormatter.Options) -> CategorizedImportDeclarations {
        guard options.contains(.sortDeclarations) else {
            return self
        }
        
        return mapValues { (category, declarations) -> ImportDeclarations in
            return declarations.sorted {
                if Prefs.sortByStringSize {
                    if $0.count == $1.count {
                        return $0.localizedCaseInsensitiveCompare($1) == category.sortingComparisonResult
                    } else {
                        return ($0.count < $1.count ? .orderedAscending : .orderedDescending) == category.sortingComparisonResult
                    }
                } else {
                    return $0.localizedCaseInsensitiveCompare($1) == category.sortingComparisonResult
                }
            }
        }
    }
    
    func separatedCategories(with options: ImportBlockFormatter.Options, using categories: ImportCategories) -> CategorizedImportDeclarations {
        guard options.contains(.separateCategories), let lastNotEmpty = categories.filter({ !(self[$0]?.isEmpty ?? true) }).last else {
            return self
        }
        
        return mapValues { ($0 != lastNotEmpty && !$1.isEmpty) ? $1 + ["\n"] : $1 }
    }
    
    func flatDeclarations(with options: ImportBlockFormatter.Options, using categories: ImportCategories) -> ImportDeclarations {
        var flatDeclarations = ImportDeclarations()
        categories.forEach { (category) in
            if let categoryDeclarations = self[category], !categoryDeclarations.isEmpty {
                flatDeclarations.append(contentsOf: categoryDeclarations)
            }
        }
        
        return flatDeclarations
    }
}
