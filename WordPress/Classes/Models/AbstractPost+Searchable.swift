import Foundation

extension Post: SearchableItemConvertable {
    var searchIdentifier: String {
        if let postID = postID, postID.intValue > 0 {
            return postID.stringValue
        } else if let postTitle = postTitle {
            return postTitle.components(separatedBy: .whitespacesAndNewlines).joined()
        } else {
            return slugForDisplay()
        }
    }

    var searchDomain: String {
        return blog.displayURL as String? ?? String()
    }

    var searchTitle: String? {
        guard let postTitle = postTitle else {
            return nil
        }

        return postTitle
    }

    var searchDescription: String? {
        let postPreview = contentPreviewForDisplay()
        guard !postPreview.isEmpty else {
            return nil
        }

        return postPreview
    }

    var searchKeywords: [String]? {
        return generateKeywords()
    }

    private func generateKeywords() -> [String]? {
        // Keywords defaults to tags
        guard hasTags() else {
           return generateKeywordsFromContent()
        }
        return tags?.arrayOfTags()
    }

    private func generateKeywordsFromContent() -> [String]? {
        var keywords: [String]? = nil
        if let postTitle = postTitle {
            // Try to generate some keywords from the title...
            keywords = postTitle.components(separatedBy: " ").map({ $0.trimmingCharacters(in: .whitespacesAndNewlines) })
        } else if !contentPreviewForDisplay().isEmpty {
            // ...otherwise try to generate some keywords from the content preview
            keywords = contentPreviewForDisplay().components(separatedBy: " ").map({ $0.trimmingCharacters(in: .whitespacesAndNewlines) })
        }
        return keywords
    }
}
