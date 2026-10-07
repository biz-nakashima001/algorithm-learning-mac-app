import Foundation

enum AppLanguage: String, CaseIterable, Identifiable {
    case japanese = "ja"
    case english = "en"
    case simplifiedChinese = "zh-Hans"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .japanese: "日本語"
        case .english: "English"
        case .simplifiedChinese: "简体中文"
        }
    }

    var languageMenuTitle: String {
        switch self {
        case .japanese: "言語"
        case .english: "Language"
        case .simplifiedChinese: "语言"
        }
    }

    func comparisonCount(_ count: Int) -> String {
        switch self {
        case .japanese: "比較回数：\(count)回"
        case .english: "\(count) comparison\(count == 1 ? "" : "s")"
        case .simplifiedChinese: "比较次数：\(count) 次"
        }
    }

    func stepCount(_ current: Int, _ total: Int) -> String {
        switch self {
        case .japanese: "ステップ \(current) / \(total)"
        case .english: "STEP \(current) OF \(total)"
        case .simplifiedChinese: "步骤 \(current) / \(total)"
        }
    }

    func positionLabel(_ position: Int, value: Int, active: Bool) -> String {
        switch self {
        case .japanese: "位置 \(position)、値 \(value)\(active ? "、確認中" : "")"
        case .english: "Position \(position), value \(value)\(active ? ", being checked" : "")"
        case .simplifiedChinese: "位置 \(position)，数值 \(value)\(active ? "，正在检查" : "")"
        }
    }

    var initialMessage: String {
        switch self {
        case .japanese: "準備完了です。「次へ」を押して始めましょう。"
        case .english: "Ready. Press Next to begin."
        case .simplifiedChinese: "准备好了。按“下一步”开始。"
        }
    }

    func compare(_ left: Int, _ right: Int) -> String {
        switch self {
        case .japanese: "\(left) と \(right) を比べます。"
        case .english: "Compare \(left) and \(right)."
        case .simplifiedChinese: "比较 \(left) 和 \(right)。"
        }
    }

    func swapBecauseLarger(_ value: Int) -> String {
        switch self {
        case .japanese: "\(value) の方が大きいため、隣の値と入れ替えます。"
        case .english: "\(value) is bigger, so swap the neighbors."
        case .simplifiedChinese: "\(value) 更大，因此交换这两个相邻的值。"
        }
    }

    var valuesInOrder: String {
        switch self {
        case .japanese: "順序どおりなので、そのままにします。"
        case .english: "They are already in the right order, so keep them."
        case .simplifiedChinese: "它们的顺序正确，保持不变。"
        }
    }

    var sortComplete: String {
        switch self {
        case .japanese: "これ以上の入れ替えは不要です。小さい順に並びました！"
        case .english: "No more swaps are needed. The list is sorted!"
        case .simplifiedChinese: "不需要再交换了。列表已按从小到大排列！"
        }
    }

    func pickUp(_ value: Int) -> String {
        switch self {
        case .japanese: "\(value) を取り出します。左側の値は整列済みです。"
        case .english: "Pick up \(value). The values to its left are sorted."
        case .simplifiedChinese: "取出 \(value)。它左侧的值已经排好序。"
        }
    }

    func compareWithKey(_ value: Int, key: Int) -> String {
        switch self {
        case .japanese: "\(value) と \(key) を比べます。"
        case .english: "Compare \(value) with \(key)."
        case .simplifiedChinese: "比较 \(value) 和 \(key)。"
        }
    }

    var moveLargerRight: String {
        switch self {
        case .japanese: "大きい値を1つ右へずらします。"
        case .english: "Move the larger value one place to the right."
        case .simplifiedChinese: "将较大的值向右移动一格。"
        }
    }

    func insert(_ value: Int) -> String {
        switch self {
        case .japanese: "空いた位置に \(value) を入れます。"
        case .english: "Place \(value) in the open spot."
        case .simplifiedChinese: "将 \(value) 插入空位。"
        }
    }

    var insertionComplete: String {
        switch self {
        case .japanese: "すべての値が整列しました！"
        case .english: "Every value is in its place. The list is sorted!"
        case .simplifiedChinese: "所有值都已就位，列表排好序了！"
        }
    }

    func searchPosition(_ position: Int, value: Int, target: Int) -> String {
        switch self {
        case .japanese: "位置 \(position) の値 \(value) は、探している \(target) と一致しますか？"
        case .english: "Check position \(position): is \(value) the target \(target)?"
        case .simplifiedChinese: "检查位置 \(position)：数值 \(value) 是要找的 \(target) 吗？"
        }
    }

    func found(_ target: Int, at position: Int) -> String {
        switch self {
        case .japanese: "位置 \(position) に \(target) が見つかりました！"
        case .english: "Found \(target) at position \(position)!"
        case .simplifiedChinese: "在位置 \(position) 找到了 \(target)！"
        }
    }

    var tryNext: String {
        switch self {
        case .japanese: "違う値です。1つ右を調べます。"
        case .english: "Not this one. Move one place to the right."
        case .simplifiedChinese: "不是这个值。继续检查右边一个位置。"
        }
    }

    func notFound(_ target: Int) -> String {
        switch self {
        case .japanese: "\(target) はリストにありません。"
        case .english: "\(target) is not in this list."
        case .simplifiedChinese: "列表中没有 \(target)。"
        }
    }

    func middleValue(_ value: Int) -> String {
        switch self {
        case .japanese: "中央の値 \(value) を確認します。"
        case .english: "Look at the middle: \(value)."
        case .simplifiedChinese: "查看中间的值：\(value)。"
        }
    }

    func tooSmall(_ value: Int) -> String {
        switch self {
        case .japanese: "\(value) は目標より小さいため、右半分に絞ります。"
        case .english: "\(value) is too small. Keep the right half."
        case .simplifiedChinese: "\(value) 比目标值小，继续查找右半部分。"
        }
    }

    func tooLarge(_ value: Int) -> String {
        switch self {
        case .japanese: "\(value) は目標より大きいため、左半分に絞ります。"
        case .english: "\(value) is too large. Keep the left half."
        case .simplifiedChinese: "\(value) 比目标值大，继续查找左半部分。"
        }
    }
}

enum CopyKey {
    case appSubtitle
    case sidebarSection
    case sortingGroup
    case searchingGroup
    case sidebarTipTitle
    case sidebarTipBody
    case workspace
    case newExample
    case searchHeader
    case sortHeader
    case listDescription
    case targetLabel
    case checkingLegend
    case sortedLegend
    case restartHelp
    case play
    case pause
    case next
    case playbackSpeed
    case explanationHeader
    case timeComplexity
    case complexityDescription
    case pseudocodeHeader

    func text(in language: AppLanguage) -> String {
        switch language {
        case .japanese:
            switch self {
            case .appSubtitle: "アルゴリズム学習アプリ"
            case .sidebarSection: "アルゴリズムを選ぶ"
            case .sortingGroup: "並べ替え"
            case .searchingGroup: "検索"
            case .sidebarTipTitle: "一歩ずつ、考え方をつかむ"
            case .sidebarTipBody: "処理を一つずつ見ていくと、アルゴリズムの仕組みがわかりやすくなります。"
            case .workspace: "学習スペース"
            case .newExample: "新しい例"
            case .searchHeader: "値を探す"
            case .sortHeader: "値を小さい順に並べる"
            case .listDescription: "タイル1つがリストの1つの値を表します"
            case .targetLabel: "探す値"
            case .checkingLegend: "確認中"
            case .sortedLegend: "整列済み"
            case .restartHelp: "最初から"
            case .play: "再生"
            case .pause: "一時停止"
            case .next: "次へ"
            case .playbackSpeed: "再生速度"
            case .explanationHeader: "処理の説明"
            case .timeComplexity: "時間計算量"
            case .complexityDescription: "データ数が増えたときの処理量の目安"
            case .pseudocodeHeader: "擬似コード"
            }
        case .english:
            switch self {
            case .appSubtitle: "ALGORITHM LEARNING APP"
            case .sidebarSection: "CHOOSE AN ALGORITHM"
            case .sortingGroup: "SORTING"
            case .searchingGroup: "SEARCHING"
            case .sidebarTipTitle: "Small steps, big ideas"
            case .sidebarTipBody: "Watch one decision at a time. That’s how algorithms become easy to understand."
            case .workspace: "YOUR LEARNING SPACE"
            case .newExample: "New example"
            case .searchHeader: "Find a value"
            case .sortHeader: "Put the values in order"
            case .listDescription: "Each tile is one value in the list"
            case .targetLabel: "TARGET"
            case .checkingLegend: "Checking"
            case .sortedLegend: "In order"
            case .restartHelp: "Start over"
            case .play: "Play"
            case .pause: "Pause"
            case .next: "Next"
            case .playbackSpeed: "Playback speed"
            case .explanationHeader: "WHAT’S HAPPENING"
            case .timeComplexity: "TIME COMPLEXITY"
            case .complexityDescription: "How the work grows as the list gets bigger"
            case .pseudocodeHeader: "THE IDEA IN CODE"
            }
        case .simplifiedChinese:
            switch self {
            case .appSubtitle: "算法学习应用"
            case .sidebarSection: "选择算法"
            case .sortingGroup: "排序"
            case .searchingGroup: "查找"
            case .sidebarTipTitle: "循序渐进，理解算法"
            case .sidebarTipBody: "一步一步观察每个操作，就能更轻松地理解算法的原理。"
            case .workspace: "学习空间"
            case .newExample: "新示例"
            case .searchHeader: "查找一个值"
            case .sortHeader: "按从小到大排列"
            case .listDescription: "每个方块代表列表中的一个值"
            case .targetLabel: "目标值"
            case .checkingLegend: "正在检查"
            case .sortedLegend: "已排序"
            case .restartHelp: "从头开始"
            case .play: "播放"
            case .pause: "暂停"
            case .next: "下一步"
            case .playbackSpeed: "播放速度"
            case .explanationHeader: "当前步骤"
            case .timeComplexity: "时间复杂度"
            case .complexityDescription: "数据量增加时，工作量的变化趋势"
            case .pseudocodeHeader: "算法思路（伪代码）"
            }
        }
    }
}
