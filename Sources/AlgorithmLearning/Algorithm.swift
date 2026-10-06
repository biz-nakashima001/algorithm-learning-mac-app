import Foundation

enum Algorithm: String, CaseIterable, Identifiable {
    case bubbleSort
    case insertionSort
    case linearSearch
    case binarySearch

    var id: String { rawValue }

    var title: String {
        switch self {
        case .bubbleSort: "Bubble Sort"
        case .insertionSort: "Insertion Sort"
        case .linearSearch: "Linear Search"
        case .binarySearch: "Binary Search"
        }
    }

    var category: String {
        switch self {
        case .bubbleSort, .insertionSort: "SORTING"
        case .linearSearch, .binarySearch: "SEARCHING"
        }
    }

    var symbol: String {
        switch self {
        case .bubbleSort: "arrow.left.arrow.right"
        case .insertionSort: "rectangle.stack"
        case .linearSearch: "magnifyingglass"
        case .binarySearch: "scope"
        }
    }

    var summary: String {
        switch self {
        case .bubbleSort: "Compare neighbors and swap them until everything is in order."
        case .insertionSort: "Grow a sorted section by placing each new value where it belongs."
        case .linearSearch: "Check each value in order until you find the one you want."
        case .binarySearch: "Repeatedly halve a sorted list to narrow down the answer."
        }
    }

    var bigO: String {
        switch self {
        case .bubbleSort, .insertionSort: "O(n²)"
        case .linearSearch: "O(n)"
        case .binarySearch: "O(log n)"
        }
    }

    var needsSortedInput: Bool { self == .binarySearch }
    var isSearch: Bool { self == .linearSearch || self == .binarySearch }

    var pseudocode: [String] {
        switch self {
        case .bubbleSort:
            ["repeat", "  compare neighbors", "  swap if out of order", "until no swaps"]
        case .insertionSort:
            ["for each next value", "  move larger values right", "  insert into the gap"]
        case .linearSearch:
            ["for each value from left", "  compare with target", "  if equal, return index", "return not found"]
        case .binarySearch:
            ["set low and high", "check the middle value", "discard half the list", "repeat until found"]
        }
    }

    func makeSteps(values input: [Int], target: Int) -> [AlgorithmStep] {
        var values = input
        var steps = [AlgorithmStep(values: values, active: [], sorted: [], line: 0, message: "Ready when you are. Press Next to begin.", comparisons: 0)]
        var comparisons = 0
        func record(_ active: [Int], _ sorted: Set<Int> = [], _ line: Int, _ message: String) {
            steps.append(AlgorithmStep(values: values, active: active, sorted: sorted, line: line, message: message, comparisons: comparisons))
        }

        switch self {
        case .bubbleSort:
            guard values.count > 1 else { break }
            var settled = Set<Int>()
            for end in stride(from: values.count - 1, through: 1, by: -1) {
                var swapped = false
                for index in 0..<end {
                    comparisons += 1
                    record([index, index + 1], settled, 1, "Compare \(values[index]) and \(values[index + 1]).")
                    if values[index] > values[index + 1] {
                        values.swapAt(index, index + 1)
                        swapped = true
                        record([index, index + 1], settled, 2, "\(values[index + 1]) is bigger, so swap the neighbors.")
                    } else {
                        record([index, index + 1], settled, 2, "They are already in the right order, so keep them.")
                    }
                }
                settled.insert(end)
                if !swapped { break }
            }
            record([], Set(values.indices), 3, "No more swaps are needed. The list is sorted!")

        case .insertionSort:
            if values.count > 1 {
                for index in 1..<values.count {
                    let key = values[index]
                    var cursor = index
                    record([index], Set(0..<index), 0, "Pick up \(key). The values to its left are sorted.")
                    while cursor > 0 {
                        comparisons += 1
                        record([cursor - 1, cursor], Set(0..<index), 1, "Compare \(values[cursor - 1]) with \(key).")
                        if values[cursor - 1] > key {
                            values[cursor] = values[cursor - 1]
                            cursor -= 1
                            record([cursor, cursor + 1], Set(0..<index), 1, "Move the larger value one place to the right.")
                        } else { break }
                    }
                    values[cursor] = key
                    record([cursor], Set(0...index), 2, "Place \(key) in the open spot.")
                }
            }
            record([], Set(values.indices), 2, "Every value is in its place. The list is sorted!")

        case .linearSearch:
            var found = false
            for index in values.indices {
                comparisons += 1
                record([index], [], 1, "Check position \(index + 1): is \(values[index]) the target \(target)?")
                if values[index] == target {
                    found = true
                    record([index], [], 2, "Found \(target) at position \(index + 1)!")
                    break
                }
                record([index], [], 2, "Not this one. Move one place to the right.")
            }
            if !found { record([], [], 3, "\(target) is not in this list.") }

        case .binarySearch:
            var low = 0
            var high = values.count - 1
            var found = false
            while low <= high {
                let middle = low + (high - low) / 2
                comparisons += 1
                record([middle], [], 1, "Look at the middle: \(values[middle]).")
                if values[middle] == target {
                    found = true
                    record([middle], [], 1, "Found \(target) at position \(middle + 1)!")
                    break
                } else if values[middle] < target {
                    low = middle + 1
                    record([middle], [], 2, "\(values[middle]) is too small. Keep the right half.")
                } else {
                    high = middle - 1
                    record([middle], [], 2, "\(values[middle]) is too large. Keep the left half.")
                }
            }
            if !found { record([], [], 3, "\(target) is not in this list.") }
        }
        return steps
    }
}

struct AlgorithmStep: Identifiable {
    let id = UUID()
    let values: [Int]
    let active: [Int]
    let sorted: Set<Int>
    let line: Int
    let message: String
    let comparisons: Int
}
