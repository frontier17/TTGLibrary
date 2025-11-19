import SwiftUI

public struct FancyScrollView: View {
    let title: String
    let titleColor: Color
    let headerHeight: CGFloat
    let scrollUpHeaderBehavior: ScrollUpHeaderBehavior
    let scrollDownHeaderBehavior: ScrollDownHeaderBehavior
    let isRoundedContent: Bool
    let header: AnyView?
    let content: AnyView

    public var body: some View {
        if let header {
            HeaderScrollView(
                title: title,
                titleColor: titleColor,
                headerHeight: headerHeight,
                scrollUpBehavior: scrollUpHeaderBehavior,
                scrollDownBehavior: scrollDownHeaderBehavior,
                isRoundedContent: isRoundedContent,
                header: header,
                content: content
            )
        } else {
            AppleMusicStyleScrollView {
                VStack {
                    title != "" ? HStack {
                        Text(title)
                            .font(.largeTitle)
                            .foregroundColor(.white)
                            .fontWeight(.black)
                            .padding(.horizontal, 16)
                            .fixedSize(horizontal: false, vertical: true)

                        Spacer()
                    } : nil

                    title != "" ? Spacer() : nil

                    content
                }
            }
        }
    }
}

extension FancyScrollView {
    public init(
        title: String = "",
        titleColor: Color = Color.white,
        headerHeight: CGFloat = 350,
        scrollUpHeaderBehavior: ScrollUpHeaderBehavior = .parallax,
        scrollDownHeaderBehavior: ScrollDownHeaderBehavior = .sticky,
        isRoundedContent: Bool = false,
        header: () -> (some View)?,
        content: () -> some View
    ) {
        self.init(
            title: title,
            titleColor: titleColor,
            headerHeight: headerHeight,
            scrollUpHeaderBehavior: scrollUpHeaderBehavior,
            scrollDownHeaderBehavior: scrollDownHeaderBehavior,
            isRoundedContent: isRoundedContent,
            header: AnyView(header()),
            content: AnyView(content())
        )
    }

    public init(
        title: String = "",
        titleColor: Color = Color.white,
        headerHeight: CGFloat = 350,
        scrollUpHeaderBehavior: ScrollUpHeaderBehavior = .parallax,
        scrollDownHeaderBehavior: ScrollDownHeaderBehavior = .sticky,
        isRoundedContent: Bool = false,
        content: () -> some View
    ) {
        self.init(
            title: title,
            titleColor: titleColor,
            headerHeight: headerHeight,
            scrollUpHeaderBehavior: scrollUpHeaderBehavior,
            scrollDownHeaderBehavior: scrollDownHeaderBehavior,
            isRoundedContent: isRoundedContent,
            header: nil,
            content: AnyView(content())
        )
    }
}

public enum ScrollUpHeaderBehavior {
    case parallax
    case sticky
}

public enum ScrollDownHeaderBehavior {
    case offset
    case sticky
}
