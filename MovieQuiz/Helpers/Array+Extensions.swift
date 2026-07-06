import Foundation

extension Array {
    subscript(safe index: Index) -> Element? {
        indices ~= index ? self[index] : nil
    }

    mutating func popRandomElement() -> Element? {
        if isEmpty {
            return nil
        }

        let index = Int.random(in: indices)
        return remove(at: index)
    }
}
