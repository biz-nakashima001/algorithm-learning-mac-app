import Foundation

enum Algorithm: String, CaseIterable, Identifiable {
    case selectionSort
    case bubbleSort
    case insertionSort
    case quickSort
    case mergeSort
    case linearSearch
    case binarySearch

    var id: String { rawValue }

    func title(in language: AppLanguage) -> String {
        switch language {
        case .japanese:
            switch self {
            case .selectionSort, .quickSort, .mergeSort: additionalTitle(in: language)
            case .bubbleSort: "バブルソート"
            case .insertionSort: "挿入ソート"
            case .linearSearch: "線形探索"
            case .binarySearch: "二分探索"
            }
        case .english:
            switch self {
            case .selectionSort, .quickSort, .mergeSort: additionalTitle(in: language)
            case .bubbleSort: "Bubble Sort"
            case .insertionSort: "Insertion Sort"
            case .linearSearch: "Linear Search"
            case .binarySearch: "Binary Search"
            }
        case .simplifiedChinese:
            switch self {
            case .selectionSort, .quickSort, .mergeSort: additionalTitle(in: language)
            case .bubbleSort: "冒泡排序"
            case .insertionSort: "插入排序"
            case .linearSearch: "线性查找"
            case .binarySearch: "二分查找"
            }
        }
    }

    func category(in language: AppLanguage) -> String {
        isSearch ? CopyKey.searchingGroup.text(in: language) : CopyKey.sortingGroup.text(in: language)
    }

    var symbol: String {
        switch self {
        case .selectionSort: "checklist"
        case .quickSort: "arrow.triangle.branch"
        case .mergeSort: "arrow.triangle.merge"
        case .bubbleSort: "arrow.left.arrow.right"
        case .insertionSort: "rectangle.stack"
        case .linearSearch: "magnifyingglass"
        case .binarySearch: "scope"
        }
    }

    func summary(in language: AppLanguage) -> String {
        switch (language, self) {
        case (_, .selectionSort), (_, .quickSort), (_, .mergeSort): additionalSummary(in: language)
        case (.japanese, .bubbleSort): "隣り合う値を比べ、順序が逆なら入れ替えて小さい順に並べます。"
        case (.japanese, .insertionSort): "整列済みの部分に次の値を挿入し、少しずつ範囲を広げます。"
        case (.japanese, .linearSearch): "先頭から値を1つずつ調べ、目的の値を探します。"
        case (.japanese, .binarySearch): "整列済みのリストを中央で分け、探索範囲を半分ずつ絞ります。"
        case (.english, .bubbleSort): "Compare neighbors and swap them until everything is in order."
        case (.english, .insertionSort): "Grow a sorted section by placing each new value where it belongs."
        case (.english, .linearSearch): "Check each value in order until you find the one you want."
        case (.english, .binarySearch): "Repeatedly halve a sorted list to narrow down the answer."
        case (.simplifiedChinese, .bubbleSort): "逐一比较相邻的值；如果顺序相反，就交换它们，直到列表按从小到大排列。"
        case (.simplifiedChinese, .insertionSort): "将下一个值插入已排序区域的合适位置，逐步扩大该区域。"
        case (.simplifiedChinese, .linearSearch): "从列表开头逐个检查，直到找到目标值。"
        case (.simplifiedChinese, .binarySearch): "在已排序列表中检查中间值，并不断将搜索范围缩小一半。"
        }
    }

    var bigO: String {
        switch self {
        case .selectionSort, .bubbleSort, .insertionSort: "O(n²)"
        case .quickSort: "O(n log n) / O(n²)"
        case .mergeSort: "O(n log n)"
        case .linearSearch: "O(n)"
        case .binarySearch: "O(log n)"
        }
    }

    var needsSortedInput: Bool { self == .binarySearch }
    var isSearch: Bool { self == .linearSearch || self == .binarySearch }

    func pseudocode(in language: AppLanguage) -> [String] {
        switch (language, self) {
        case (_, .selectionSort), (_, .quickSort), (_, .mergeSort): additionalPseudocode(in: language)
        case (.japanese, .bubbleSort):
            ["repeat", "  隣り合う値を比較", "  if 順序が逆なら入れ替える", "until 入れ替えがなくなる"]
        case (.japanese, .insertionSort):
            ["for 次の値について", "  大きい値を右へずらす", "  空いた位置に挿入する"]
        case (.japanese, .linearSearch):
            ["for 左から順に調べる", "  target と比較する", "  if 一致すれば index を返す", "return 見つからない"]
        case (.japanese, .binarySearch):
            ["low と high を設定", "middle の値を確認", "探索範囲を半分に絞る", "repeat 見つかるまで"]
        case (.english, .bubbleSort):
            ["repeat", "  compare neighbors", "  if out of order, swap", "until no swaps"]
        case (.english, .insertionSort):
            ["for each next value", "  move larger values right", "  insert into the gap"]
        case (.english, .linearSearch):
            ["for each value from left", "  compare with target", "  if equal, return index", "return not found"]
        case (.english, .binarySearch):
            ["set low and high", "check the middle value", "discard half the list", "repeat until found"]
        case (.simplifiedChinese, .bubbleSort):
            ["repeat", "  比较相邻的值", "  if 顺序相反则交换", "until 不再交换"]
        case (.simplifiedChinese, .insertionSort):
            ["for 遍历下一个值", "  将较大的值向右移动", "  插入到空位"]
        case (.simplifiedChinese, .linearSearch):
            ["for 从左向右检查", "  与 target 比较", "  if 相同则 return index", "return 未找到"]
        case (.simplifiedChinese, .binarySearch):
            ["设置 low 和 high", "检查 middle 的值", "将范围缩小一半", "repeat 直到找到"]
        }
    }

    func makeSteps(values input: [Int], target: Int, language: AppLanguage) -> [AlgorithmStep] {
        if [.selectionSort, .quickSort, .mergeSort].contains(self) {
            return additionalSteps(values: input, language: language)
        }
        var values = input
        var steps = [AlgorithmStep(values: values, active: [], sorted: [], line: 0, message: language.initialMessage, comparisons: 0)]
        var comparisons = 0
        func record(_ active: [Int], _ sorted: Set<Int> = [], _ line: Int, _ message: String) {
            steps.append(AlgorithmStep(values: values, active: active, sorted: sorted, line: line, message: message, comparisons: comparisons))
        }

        switch self {
        case .selectionSort, .quickSort, .mergeSort: break
        case .bubbleSort:
            guard values.count > 1 else { break }
            var settled = Set<Int>()
            for end in stride(from: values.count - 1, through: 1, by: -1) {
                var swapped = false
                for index in 0..<end {
                    comparisons += 1
                    record([index, index + 1], settled, 1, language.compare(values[index], values[index + 1]))
                    if values[index] > values[index + 1] {
                        values.swapAt(index, index + 1)
                        swapped = true
                        record([index, index + 1], settled, 2, language.swapBecauseLarger(values[index + 1]))
                    } else {
                        record([index, index + 1], settled, 2, language.valuesInOrder)
                    }
                }
                settled.insert(end)
                if !swapped { break }
            }
            record([], Set(values.indices), 3, language.sortComplete)

        case .insertionSort:
            if values.count > 1 {
                for index in 1..<values.count {
                    let key = values[index]
                    var cursor = index
                    record([index], Set(0..<index), 0, language.pickUp(key))
                    while cursor > 0 {
                        comparisons += 1
                        record([cursor - 1, cursor], Set(0..<index), 1, language.compareWithKey(values[cursor - 1], key: key))
                        if values[cursor - 1] > key {
                            values[cursor] = values[cursor - 1]
                            cursor -= 1
                            record([cursor, cursor + 1], Set(0..<index), 1, language.moveLargerRight)
                        } else { break }
                    }
                    values[cursor] = key
                    record([cursor], Set(0...index), 2, language.insert(key))
                }
            }
            record([], Set(values.indices), 2, language.insertionComplete)

        case .linearSearch:
            var found = false
            for index in values.indices {
                comparisons += 1
                record([index], [], 1, language.searchPosition(index + 1, value: values[index], target: target))
                if values[index] == target {
                    found = true
                    record([index], [], 2, language.found(target, at: index + 1))
                    break
                }
                record([index], [], 2, language.tryNext)
            }
            if !found { record([], [], 3, language.notFound(target)) }

        case .binarySearch:
            var low = 0
            var high = values.count - 1
            var found = false
            while low <= high {
                let middle = low + (high - low) / 2
                comparisons += 1
                record([middle], [], 1, language.middleValue(values[middle]))
                if values[middle] == target {
                    found = true
                    record([middle], [], 1, language.found(target, at: middle + 1))
                    break
                } else if values[middle] < target {
                    low = middle + 1
                    record([middle], [], 2, language.tooSmall(values[middle]))
                } else {
                    high = middle - 1
                    record([middle], [], 2, language.tooLarge(values[middle]))
                }
            }
            if !found { record([], [], 3, language.notFound(target)) }
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
