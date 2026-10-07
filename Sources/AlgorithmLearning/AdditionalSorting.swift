import Foundation

extension AppLanguage {
    func translated(_ japanese: String, _ english: String, _ chinese: String) -> String {
        switch self {
        case .japanese: japanese
        case .english: english
        case .simplifiedChinese: chinese
        }
    }
}

extension Algorithm {
    func additionalTitle(in language: AppLanguage) -> String {
        switch self {
        case .selectionSort: language.translated("選択ソート", "Selection Sort", "选择排序")
        case .quickSort: language.translated("クイックソート", "Quick Sort", "快速排序")
        case .mergeSort: language.translated("マージソート", "Merge Sort", "归并排序")
        default: ""
        }
    }

    func additionalSummary(in language: AppLanguage) -> String {
        switch self {
        case .selectionSort:
            language.translated("未整列の範囲から最小値を選び、先頭へ移していきます。", "Select the smallest remaining value and move it to the front.", "从未排序区域选择最小值，将它移到前面。")
        case .quickSort:
            language.translated("pivot を基準に値を分け、左右の範囲を再帰的に整列します。計算量は平均 O(n log n)、最悪 O(n²) です。", "Partition around a pivot, then sort both sides recursively. Average: O(n log n); worst: O(n²).", "以 pivot 为基准划分列表，再递归排序两侧。平均 O(n log n)，最坏 O(n²)。")
        case .mergeSort:
            language.translated("リストを半分ずつ分け、整列した小さな範囲を順番に併合します。", "Split the list into halves, then merge the sorted pieces in order.", "将列表不断分成两半，再按顺序合并已排序的部分。")
        default: ""
        }
    }

    func additionalPseudocode(in language: AppLanguage) -> [String] {
        switch self {
        case .selectionSort:
            switch language {
            case .japanese: ["for 未整列の先頭について", "  最小値を探す", "  最小値を先頭と交換", "return 整列済みのリスト"]
            case .english: ["for each unsorted position", "  find the minimum", "  swap minimum to the front", "return sorted list"]
            case .simplifiedChinese: ["for 遍历未排序的起点", "  找到最小值", "  将最小值交换到起点", "return 已排序列表"]
            }
        case .quickSort:
            switch language {
            case .japanese: ["pivot を選ぶ", "pivot と各値を比較", "小さい値を左へ移す", "pivot の位置を確定", "左右で quickSort を呼ぶ", "return 整列済みのリスト"]
            case .english: ["choose pivot", "compare each value to pivot", "move smaller values left", "place pivot in its final spot", "call quickSort on both sides", "return sorted list"]
            case .simplifiedChinese: ["选择 pivot", "将各值与 pivot 比较", "将较小的值移到左侧", "确定 pivot 的最终位置", "对两侧调用 quickSort", "return 已排序列表"]
            }
        case .mergeSort:
            switch language {
            case .japanese: ["if 範囲が1つなら return", "左右に分けて mergeSort", "左右の先頭を比較", "小さい値を順に書き込む", "残りの値を書き込む", "return 整列済みのリスト"]
            case .english: ["if one value, return", "split and call mergeSort", "compare heads of both halves", "write the smaller value", "write the remaining values", "return sorted list"]
            case .simplifiedChinese: ["if 只有一个值则 return", "分成两半并调用 mergeSort", "比较两半的首个值", "写入较小的值", "写入剩余的值", "return 已排序列表"]
            }
        default: []
        }
    }

    func additionalSteps(values input: [Int], language: AppLanguage) -> [AlgorithmStep] {
        var values = input
        var settled = Set<Int>()
        var comparisons = 0
        var steps = [AlgorithmStep(values: values, active: [], sorted: [], line: 0, message: language.initialMessage, comparisons: 0)]
        func record(_ active: [Int], _ line: Int, _ message: String) {
            steps.append(AlgorithmStep(values: values, active: active, sorted: settled, line: line, message: message, comparisons: comparisons))
        }
        switch self {
        case .selectionSort:
            for start in values.indices {
                var minimum = start
                record([start], 0, language.translated("位置 \(start + 1) 以降の最小値を探します。", "Find the smallest value from position \(start + 1) onward.", "查找位置 \(start + 1) 之后的最小值。"))
                for candidate in (start + 1)..<values.count {
                    comparisons += 1
                    record([minimum, candidate], 1, language.compare(values[minimum], values[candidate]))
                    if values[candidate] < values[minimum] {
                        minimum = candidate
                        record([minimum], 1, language.translated("最小値の候補を \(values[minimum]) に更新します。", "The new minimum candidate is \(values[minimum]).", "将最小值候选更新为 \(values[minimum])。"))
                    }
                }
                values.swapAt(start, minimum)
                settled.insert(start)
                record([start, minimum], 2, language.translated("最小値 \(values[start]) を位置 \(start + 1) に置きました。", "Placed the minimum, \(values[start]), at position \(start + 1).", "将最小值 \(values[start]) 放在位置 \(start + 1)。"))
            }
        case .quickSort:
            func quickSort(_ low: Int, _ high: Int) {
                guard low <= high else { return }
                if low == high {
                    settled.insert(low)
                    record([low], 4, language.translated("この範囲は1つの値だけなので整列済みです。", "This range has one value, so it is sorted.", "此范围只有一个值，已经排好序。"))
                    return
                }
                let pivot = values[high]
                record([high], 0, language.translated("位置 \(high + 1) の \(pivot) を pivot に選びます。", "Choose \(pivot) at position \(high + 1) as the pivot.", "选择位置 \(high + 1) 的 \(pivot) 作为 pivot。"))
                var boundary = low
                for index in low..<high {
                    comparisons += 1
                    record([index, high], 1, language.compare(values[index], pivot))
                    if values[index] <= pivot {
                        values.swapAt(index, boundary)
                        record([index, boundary, high], 2, language.translated("pivot 以下の値を左側へ移します。", "Move this value to the left partition: it is no larger than the pivot.", "将不大于 pivot 的值移到左侧。"))
                        boundary += 1
                    }
                }
                values.swapAt(boundary, high)
                settled.insert(boundary)
                record([boundary], 3, language.translated("pivot \(pivot) の位置が確定しました。", "The pivot, \(pivot), is now in its final position.", "pivot \(pivot) 的最终位置已确定。"))
                record([], 4, language.translated("pivot の左右をそれぞれ整列します。", "Sort the ranges on both sides of the pivot.", "分别排序 pivot 两侧的范围。"))
                quickSort(low, boundary - 1)
                quickSort(boundary + 1, high)
            }
            quickSort(0, values.count - 1)
        case .mergeSort:
            func mergeSort(_ low: Int, _ high: Int) {
                guard high - low > 1 else { return }
                let middle = low + (high - low) / 2
                record(Array(low..<high), 1, language.translated("位置 \(low + 1)〜\(high) を左右に分けます。", "Split positions \(low + 1)–\(high) into two halves.", "将位置 \(low + 1)–\(high) 分成两半。"))
                mergeSort(low, middle)
                mergeSort(middle, high)
                let left = Array(values[low..<middle])
                let right = Array(values[middle..<high])
                var l = 0, r = 0, destination = low
                while l < left.count && r < right.count {
                    comparisons += 1
                    record([low + l, middle + r], 2, language.translated("一時配列の先頭 \(left[l]) と \(right[r]) を比べます。", "Compare the temporary halves' next values: \(left[l]) and \(right[r]).", "比较临时数组中的下一个值：\(left[l]) 和 \(right[r])。"))
                    if left[l] <= right[r] { values[destination] = left[l]; l += 1 }
                    else { values[destination] = right[r]; r += 1 }
                    record([destination], 3, language.translated("小さい方の \(values[destination]) を位置 \(destination + 1) に書き込みます。元の値は一時配列に保存しています。", "Write the smaller value, \(values[destination]), at position \(destination + 1). Original values are saved in temporary arrays.", "将较小的值 \(values[destination]) 写入位置 \(destination + 1)。原始值保存在临时数组中。"))
                    destination += 1
                }
                while l < left.count || r < right.count {
                    if l < left.count { values[destination] = left[l]; l += 1 }
                    else { values[destination] = right[r]; r += 1 }
                    record([destination], 4, language.translated("残りの値 \(values[destination]) を書き込みます。", "Write the remaining value, \(values[destination]).", "写入剩余的值 \(values[destination])。"))
                    destination += 1
                }
            }
            mergeSort(0, values.count)
        default: break
        }
        settled = Set(values.indices)
        record([], additionalPseudocode(in: language).count - 1, language.insertionComplete)
        return steps
    }
}
