import Danger
import Foundation

let danger = Danger()

let allSourceFiles = danger.git.modifiedFiles + danger.git.createdFiles
let sourceChanges = allSourceFiles.contains { $0.hasPrefix("Source") }

// Ensure no copyright header
let swiftFilesWithCopyright = allSourceFiles.filter {
    $0.contains("Copyright") && ($0.fileType == .swift || $0.fileType == .m)
}
for file in swiftFilesWithCopyright {
    danger.fail(message: "Please remove this copyright header", file: file, line: 0)
}

// Make it more obvious that a PR is a work in progress and shouldn't be merged yet
if danger.github.pullRequest.title.contains("WIP") || danger.github.pullRequest.title.contains("Draft") {
    danger.warn("PR is classed as Work in Progress")
}

// Warn when there is a big PR
let bigPRThreshold = 600
if (danger.github.pullRequest.additions ?? 0) + (danger.github.pullRequest.deletions ?? 0) > bigPRThreshold {
    danger.warn("""
     Pull Request size seems relatively large. If this Pull Request contains multiple changes, please split
     each into separate PR will helps faster, easier review.
    """)
}

// Warning message for not updated package manifest(s)
let manifests = [
    "Package.swift",
    "Package.resolved"
]
let updatedManifests = manifests.filter { manifest in
    danger.git.modifiedFiles.contains {
        $0.name == manifest
    }
}
if !updatedManifests.isEmpty && updatedManifests.count != manifests.count {
    let notUpdatedManifests = manifests.filter { !updatedManifests.contains($0) }
    let updatedArticle = updatedManifests.count == 1 ? "The " : ""
    let updatedVerb = updatedManifests.count == 1 ? "was" : "were"
    let notUpdatedArticle = notUpdatedManifests.count == 1 ? "the " : ""

    danger.warn("""
     \(updatedArticle)\(updatedManifests.joined(separator: ", ")) \(updatedVerb) updated,
     but there were no changes in \(notUpdatedArticle)\(notUpdatedManifests.joined(separator: ", ")).\n
     Did you forget to update them?
    """)
}

// Warn when library files has been updated but not tests.
let testsUpdated = danger.git.modifiedFiles.contains { $0.hasPrefix("Tests") }
if sourceChanges && !testsUpdated {
    warn("""
     The library files were changed, but the tests remained unmodified.
     Consider updating or adding to the tests to match the library changes.
    """)
}

// Run Swiftlint
SwiftLint.lint(inline: false, configFile: ".swiftlint.yml")
