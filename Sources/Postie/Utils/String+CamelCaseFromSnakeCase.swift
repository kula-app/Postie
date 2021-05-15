extension String {

    /// Convert from "snake_case_keys" to "camelCaseKeys" before attempting to match a key with the one specified by each type.
    ///
    /// Converting from snake case to camel case:
    /// 1. Capitalizes the word starting after each `_`
    /// 2. Removes all `_`
    /// 3. Preserves starting and ending `_` (as these are often used to indicate private variables or other metadata).
    /// For example, `one_two_three` becomes `oneTwoThree`. `_one_two_three_` becomes `_oneTwoThree_`.
    ///
    /// - Note: Using a key decoding strategy has a nominal performance cost, as each string key has to be inspected for the `_` character.
    public var camelCaseFromSnakeCase: String {
        var prefix = ""
        var appendix = ""
        var temp = self[self.startIndex...]
        while temp.hasPrefix("_") {
            prefix += "_"
            temp = temp[temp.index(temp.startIndex, offsetBy: 1)...]
        }
        while temp.hasSuffix("_") {
            appendix += "_"
            temp = temp[..<temp.index(temp.endIndex, offsetBy: -1)]
        }
        var result = ""
        let comps = temp.split(separator: "_")
        if let first = comps.first {
            result += first.lowercased()
        }
        for comp in comps.dropFirst() {
            result += comp.uppercasingFirst
        }
        return prefix + result + appendix
    }
}

extension Substring {

    var uppercasingFirst: String {
        return prefix(1).uppercased() + dropFirst()
    }
}
