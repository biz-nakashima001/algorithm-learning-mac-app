import SwiftUI
import Combine

private enum Palette {
    static let ink = Color(red: 0.12, green: 0.16, blue: 0.21)
    static let muted = Color(red: 0.48, green: 0.52, blue: 0.57)
    static let canvas = Color(red: 0.96, green: 0.96, blue: 0.94)
    static let paper = Color.white
    static let blue = Color(red: 0.23, green: 0.43, blue: 0.86)
    static let mint = Color(red: 0.20, green: 0.67, blue: 0.55)
    static let orange = Color(red: 0.96, green: 0.60, blue: 0.29)
    static let line = Color(red: 0.89, green: 0.90, blue: 0.90)
}

struct ContentView: View {
    @AppStorage("preferredLanguage") private var savedLanguage = AppLanguage.japanese.rawValue
    @State private var selected: Algorithm = .bubbleSort
    @State private var data = [42, 17, 68, 23, 51, 9, 35, 60]
    @State private var target = 23
    @State private var stepIndex = 0
    @State private var isPlaying = false
    @State private var speed = 0.75

    private var language: AppLanguage { AppLanguage(rawValue: savedLanguage) ?? .japanese }
    private var steps: [AlgorithmStep] { selected.makeSteps(values: data, target: target, language: language) }
    private var current: AlgorithmStep { steps[min(stepIndex, steps.count - 1)] }
    private var isComplete: Bool { stepIndex >= steps.count - 1 }

    var body: some View {
        GeometryReader { geometry in
            Group {
                if geometry.size.width < 700 {
                    VStack(spacing: 0) {
                        topBar(isCompact: true)
                        compactAlgorithmPicker
                        mainContent(isCompact: true)
                    }
                } else {
                    HStack(spacing: 0) {
                        sidebar
                        VStack(spacing: 0) {
                            topBar(isCompact: false)
                            mainContent(isCompact: false)
                        }
                    }
                }
            }
        }
        .background(Palette.canvas)
        .foregroundStyle(Palette.ink)
        .preferredColorScheme(.light)
        .onReceive(Timer.publish(every: speed, on: .main, in: .common).autoconnect()) { _ in
            if isPlaying { advance() }
        }
        .onChange(of: selected) { _, _ in resetForSelection() }
        .onChange(of: target) { _, _ in rewind() }
    }

    private var sidebar: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 11) {
                Image(systemName: "sparkles.rectangle.stack.fill")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(Palette.blue)
                    .frame(width: 37, height: 37)
                    .background(Palette.blue.opacity(0.10), in: RoundedRectangle(cornerRadius: 11))
                VStack(alignment: .leading, spacing: 2) {
                    Text("Little by Little").font(.system(size: 15, weight: .bold, design: .rounded))
                    Text(CopyKey.appSubtitle.text(in: language)).font(.system(size: 8, weight: .bold)).tracking(1.2).foregroundStyle(Palette.muted)
                }
            }
            .padding(.horizontal, 20).padding(.top, 28).padding(.bottom, 30)

            Text(CopyKey.sidebarSection.text(in: language)).font(.system(size: 9, weight: .bold)).tracking(1.2)
                .foregroundStyle(Palette.muted).padding(.horizontal, 20).padding(.bottom, 10)
            algorithmGroup(CopyKey.sortingGroup.text(in: language), items: [.selectionSort, .bubbleSort, .insertionSort, .quickSort, .mergeSort])
            algorithmGroup(CopyKey.searchingGroup.text(in: language), items: [.linearSearch, .binarySearch])

            Spacer()
            HStack(alignment: .top, spacing: 10) {
                Image(systemName: "lightbulb.fill").foregroundStyle(Palette.orange)
                VStack(alignment: .leading, spacing: 5) {
                    Text(CopyKey.sidebarTipTitle.text(in: language)).font(.system(size: 12, weight: .semibold))
                    Text(CopyKey.sidebarTipBody.text(in: language))
                        .font(.system(size: 11)).foregroundStyle(Palette.muted).fixedSize(horizontal: false, vertical: true).lineSpacing(3)
                }
            }
            .padding(14).background(Palette.canvas, in: RoundedRectangle(cornerRadius: 14))
            .padding(14).padding(.bottom, 8)
        }
        .frame(width: 238)
        .background(Palette.paper)
        .overlay(alignment: .trailing) { Rectangle().fill(Palette.line).frame(width: 1) }
    }

    private func algorithmGroup(_ title: String, items: [Algorithm]) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title).font(.system(size: 9, weight: .bold)).tracking(1.1)
                .foregroundStyle(Palette.muted).padding(.horizontal, 12).padding(.bottom, 2)
            ForEach(items) { item in
                Button { selected = item } label: {
                    HStack(spacing: 11) {
                        Image(systemName: item.symbol).font(.system(size: 13, weight: .medium)).frame(width: 18)
                        Text(item.title(in: language)).font(.system(size: 13, weight: selected == item ? .semibold : .medium))
                        Spacer()
                        if selected == item { Circle().fill(Palette.blue).frame(width: 6, height: 6) }
                    }
                    .foregroundStyle(selected == item ? Palette.blue : Palette.ink.opacity(0.75))
                    .padding(.horizontal, 12).frame(height: 39)
                    .background(selected == item ? Palette.blue.opacity(0.09) : .clear, in: RoundedRectangle(cornerRadius: 10))
                    .contentShape(RoundedRectangle(cornerRadius: 10))
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 13).padding(.bottom, 19)
    }

    private func mainContent(isCompact: Bool) -> some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    intro
                    visualizationCard
                    if isCompact {
                        VStack(alignment: .leading, spacing: 16) {
                            explanationCard
                            pseudocodeCard
                        }
                    } else {
                        HStack(alignment: .top, spacing: 16) {
                            explanationCard
                            pseudocodeCard
                        }
                    }
                }
                .padding(.horizontal, isCompact ? 16 : 30)
                .padding(.top, isCompact ? 16 : 25)
                .padding(.bottom, 32)
                .frame(maxWidth: 1050, alignment: .leading)
                .frame(maxWidth: .infinity)
            }
        }
    }

    private var compactAlgorithmPicker: some View {
        Menu {
            ForEach(Algorithm.allCases) { item in
                Button {
                    selected = item
                } label: {
                    if selected == item {
                        Label(item.title(in: language), systemImage: "checkmark")
                    } else {
                        Text(item.title(in: language))
                    }
                }
            }
        } label: {
            HStack(spacing: 10) {
                Image(systemName: selected.symbol).foregroundStyle(Palette.blue)
                VStack(alignment: .leading, spacing: 2) {
                    Text(selected.category(in: language))
                        .font(.system(size: 9, weight: .bold)).foregroundStyle(Palette.muted)
                    Text(selected.title(in: language))
                        .font(.system(size: 14, weight: .semibold)).foregroundStyle(Palette.ink)
                }
                Spacer()
                Image(systemName: "chevron.down").font(.system(size: 11, weight: .semibold)).foregroundStyle(Palette.muted)
            }
            .padding(.horizontal, 13).frame(height: 48)
            .background(Palette.paper, in: RoundedRectangle(cornerRadius: 12))
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Palette.line, lineWidth: 1))
            .contentShape(RoundedRectangle(cornerRadius: 12))
        }
        .padding(.horizontal, 16).padding(.vertical, 10)
    }

    private func topBar(isCompact: Bool) -> some View {
        HStack {
            HStack(spacing: 6) {
                Circle().fill(Palette.mint).frame(width: 7, height: 7)
                Text(CopyKey.workspace.text(in: language)).font(.system(size: 9, weight: .bold)).tracking(1.3).foregroundStyle(Palette.muted)
            }
            Spacer()
            Menu {
                ForEach(AppLanguage.allCases) { choice in
                    Button {
                        savedLanguage = choice.rawValue
                    } label: {
                        if choice == language {
                            Label(choice.displayName, systemImage: "checkmark")
                        } else {
                            Text(choice.displayName)
                        }
                    }
                }
            } label: {
                Label(language.languageMenuTitle, systemImage: "globe")
                    .font(.system(size: 11, weight: .semibold)).foregroundStyle(Palette.ink)
                    .padding(.horizontal, 12).frame(height: 32)
                    .background(Palette.paper, in: Capsule()).overlay(Capsule().stroke(Palette.line, lineWidth: 1))
            }
            Button(action: newExample) {
                Label(CopyKey.newExample.text(in: language), systemImage: "arrow.clockwise")
                    .font(.system(size: 11, weight: .semibold)).foregroundStyle(Palette.ink)
                    .padding(.horizontal, 13).frame(height: 32)
                    .background(Palette.paper, in: Capsule()).overlay(Capsule().stroke(Palette.line, lineWidth: 1))
            }.buttonStyle(.plain)
        }
        .padding(.horizontal, isCompact ? 14 : 30).frame(height: 60)
        .background(Palette.canvas.opacity(0.94))
        .overlay(alignment: .bottom) { Rectangle().fill(Palette.line).frame(height: 1) }
    }

    private var intro: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Image(systemName: selected.symbol).font(.system(size: 11, weight: .semibold))
                Text(selected.category(in: language)).font(.system(size: 9, weight: .bold)).tracking(1.2)
            }
            .foregroundStyle(Palette.blue)
            Text(selected.title(in: language)).font(.system(size: 30, weight: .bold, design: .rounded)).tracking(-0.7)
            Text(selected.summary(in: language)).font(.system(size: 13)).foregroundStyle(Palette.muted)
        }
    }

    private var visualizationCard: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text((selected.isSearch ? CopyKey.searchHeader : CopyKey.sortHeader).text(in: language))
                        .font(.system(size: 14, weight: .semibold))
                    Text(CopyKey.listDescription.text(in: language)).font(.system(size: 11)).foregroundStyle(Palette.muted)
                }
                Spacer()
                if selected.isSearch {
                    HStack(spacing: 8) {
                        Text(CopyKey.targetLabel.text(in: language)).font(.system(size: 9, weight: .bold)).tracking(0.8).foregroundStyle(Palette.muted)
                        TextField(CopyKey.targetLabel.text(in: language), value: $target, format: .number)
                            .textFieldStyle(.plain).font(.system(size: 13, weight: .semibold, design: .rounded))
                            .frame(width: 48).padding(.horizontal, 9).frame(height: 31)
                            .background(Palette.canvas, in: RoundedRectangle(cornerRadius: 8))
                    }
                }
            }
            .padding(.horizontal, 19).padding(.top, 17).padding(.bottom, 11)

            HStack(spacing: 8) {
                ForEach(Array(current.values.enumerated()), id: \.offset) { index, value in
                    valueTile(value, index: index)
                }
            }
            .frame(maxWidth: .infinity).frame(height: 135)
            .padding(.horizontal, 16).padding(.vertical, 5)

            HStack(spacing: 14) {
                legend(Palette.blue, CopyKey.checkingLegend.text(in: language))
                if !selected.isSearch { legend(Palette.mint, CopyKey.sortedLegend.text(in: language)) }
                Spacer()
                Text(language.comparisonCount(current.comparisons))
                    .font(.system(size: 10, weight: .medium, design: .rounded)).foregroundStyle(Palette.muted)
            }
            .padding(.horizontal, 19).padding(.bottom, 15)

            Rectangle().fill(Palette.line).frame(height: 1)
            HStack(spacing: 12) {
                Button(action: rewind) {
                    Image(systemName: "backward.end.fill").font(.system(size: 10)).frame(width: 32, height: 32)
                        .background(Palette.canvas, in: Circle())
                }.buttonStyle(.plain).help(CopyKey.restartHelp.text(in: language))
                Button(action: togglePlayback) {
                    Label((isPlaying ? CopyKey.pause : CopyKey.play).text(in: language), systemImage: isPlaying ? "pause.fill" : "play.fill")
                        .font(.system(size: 11, weight: .semibold)).padding(.horizontal, 14).frame(height: 32)
                        .foregroundStyle(.white).background(Palette.blue, in: Capsule())
                }.buttonStyle(.plain)
                Button(action: advance) {
                    Label(CopyKey.next.text(in: language), systemImage: "forward.fill").font(.system(size: 11, weight: .semibold))
                        .padding(.horizontal, 13).frame(height: 32)
                        .background(Palette.canvas, in: Capsule())
                }.buttonStyle(.plain).disabled(isComplete).opacity(isComplete ? 0.45 : 1)
                Spacer()
                Text(language.stepCount(stepIndex + 1, steps.count))
                    .font(.system(size: 9, weight: .bold, design: .rounded)).tracking(0.8).foregroundStyle(Palette.muted)
                Slider(value: $speed, in: 0.35...1.5).frame(width: 74).help(CopyKey.playbackSpeed.text(in: language))
            }
            .padding(.horizontal, 17).padding(.vertical, 12)
        }
        .background(Palette.paper, in: RoundedRectangle(cornerRadius: 18))
        .overlay(RoundedRectangle(cornerRadius: 18).stroke(Palette.line.opacity(0.75), lineWidth: 1))
        .shadow(color: Palette.ink.opacity(0.035), radius: 12, y: 5)
    }

    private func valueTile(_ value: Int, index: Int) -> some View {
        let isActive = current.active.contains(index)
        let isSorted = current.sorted.contains(index)
        let fill = isActive ? Palette.blue : (isSorted ? Palette.mint : Palette.canvas)
        return VStack(spacing: 7) {
            RoundedRectangle(cornerRadius: 11)
                .fill(fill.opacity(isActive || isSorted ? 1 : 0.92))
                .frame(maxWidth: .infinity)
                .frame(height: CGFloat(48 + min(value, 70)))
                .overlay {
                    Text("\(value)").font(.system(size: 13, weight: .bold, design: .rounded))
                        .foregroundStyle(isActive || isSorted ? .white : Palette.ink)
                }
                .overlay(alignment: .top) {
                    if isActive { Image(systemName: "arrowtriangle.down.fill").font(.system(size: 8)).foregroundStyle(Palette.blue).offset(y: -8) }
                }
            Text("\(index + 1)").font(.system(size: 9, weight: .medium, design: .rounded)).foregroundStyle(Palette.muted)
        }
        .frame(maxWidth: .infinity, alignment: .bottom)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(language.positionLabel(index + 1, value: value, active: isActive))
    }

    private func legend(_ color: Color, _ label: String) -> some View {
        HStack(spacing: 5) { Circle().fill(color).frame(width: 7, height: 7); Text(label).font(.system(size: 9, weight: .medium)).foregroundStyle(Palette.muted) }
    }

    private var explanationCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 7) {
                Image(systemName: "text.bubble.fill").foregroundStyle(Palette.orange)
                Text(CopyKey.explanationHeader.text(in: language)).font(.system(size: 9, weight: .bold)).tracking(1).foregroundStyle(Palette.muted)
            }
            Text(current.message).font(.system(size: 13, weight: .medium)).lineSpacing(4).fixedSize(horizontal: false, vertical: true)
            HStack(spacing: 7) {
                Text(CopyKey.timeComplexity.text(in: language)).font(.system(size: 8, weight: .bold)).tracking(0.7).foregroundStyle(Palette.muted)
                Text(selected.bigO).font(.system(size: 11, weight: .bold, design: .rounded)).foregroundStyle(Palette.blue)
                Text(CopyKey.complexityDescription.text(in: language))
                    .font(.system(size: 9)).foregroundStyle(Palette.muted).fixedSize(horizontal: false, vertical: true)
            }
            .padding(.top, 4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(17).background(Palette.paper, in: RoundedRectangle(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Palette.line.opacity(0.75), lineWidth: 1))
    }

    private var pseudocodeCard: some View {
        VStack(alignment: .leading, spacing: 11) {
            HStack(spacing: 7) {
                Image(systemName: "chevron.left.forwardslash.chevron.right").foregroundStyle(Palette.blue)
                Text(CopyKey.pseudocodeHeader.text(in: language)).font(.system(size: 9, weight: .bold)).tracking(1).foregroundStyle(Palette.muted)
            }
            VStack(alignment: .leading, spacing: 5) {
                ForEach(Array(selected.pseudocode(in: language).enumerated()), id: \.offset) { index, line in
                    HStack(spacing: 8) {
                        RoundedRectangle(cornerRadius: 2).fill(index == current.line && stepIndex > 0 ? Palette.orange : .clear).frame(width: 3, height: 15)
                        Text(line).font(.system(size: 10, weight: index == current.line && stepIndex > 0 ? .semibold : .regular, design: .monospaced))
                            .foregroundStyle(index == current.line && stepIndex > 0 ? Palette.ink : Palette.muted)
                        Spacer(minLength: 0)
                    }
                    .padding(.horizontal, 4).padding(.vertical, 2)
                    .background(index == current.line && stepIndex > 0 ? Palette.orange.opacity(0.10) : .clear, in: RoundedRectangle(cornerRadius: 5))
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(17).background(Palette.paper, in: RoundedRectangle(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Palette.line.opacity(0.75), lineWidth: 1))
    }

    private func advance() {
        guard !isComplete else { isPlaying = false; return }
        stepIndex += 1
        if isComplete { isPlaying = false }
    }

    private func togglePlayback() {
        if isComplete { stepIndex = 0 }
        isPlaying.toggle()
    }

    private func rewind() { isPlaying = false; stepIndex = 0 }

    private func resetForSelection() {
        isPlaying = false
        if selected.needsSortedInput { data.sort() }
        rewind()
    }

    private func newExample() {
        isPlaying = false
        data = (0..<8).map { _ in Int.random(in: 8...70) }
        if selected.needsSortedInput { data.sort() }
        if selected.isSearch { target = data.randomElement() ?? 23 }
        stepIndex = 0
    }
}

#Preview {
    ContentView()
}
