import SwiftUI

private let navigationBarHeight: CGFloat = 0

struct HeaderScrollView: View {
    @Environment(\.colorScheme)
    private var colorScheme: ColorScheme

    let title: String
    let titleColor: Color
    let headerHeight: CGFloat
    let scrollUpBehavior: ScrollUpHeaderBehavior
    let scrollDownBehavior: ScrollDownHeaderBehavior
    let isRoundedContent: Bool
    let header: AnyView
    let content: AnyView

    var body: some View {
        GeometryReader { globalGeometry in
            ScrollView {
                VStack(spacing: 0) {
                    GeometryReader { geometry -> AnyView in
                        let geometry = self.geometry(from: geometry, safeArea: globalGeometry.safeAreaInsets)
                        AnyView(
                            header
                                .frame(width: geometry.width, height: geometry.headerHeight)
                                .clipped()
                                .opacity(sqrt(geometry.largeTitleWeight))
                                .offset(y: geometry.headerOffset)
                        )
                    }
                    .frame(width: globalGeometry.size.width, height: headerHeight)

                    GeometryReader { geometry -> AnyView in
                        let geometry = self.geometry(from: geometry, safeArea: globalGeometry.safeAreaInsets)
                        AnyView(
                            ZStack {
                                BlurView()
                                    .opacity(1 - sqrt(geometry.largeTitleWeight))
                                    .offset(y: geometry.blurOffset)

                                VStack {
                                    geometry.largeTitleWeight == 1 ? HStack {
//                                        BackButton(color: .white)
                                        Spacer()
                                    }.frame(width: geometry.width, height: navigationBarHeight) : nil

                                    Spacer()

                                    HeaderScrollViewTitle(
                                        title: title,
                                        titleColor: titleColor,
                                        height: navigationBarHeight,
                                        largeTitle: geometry.largeTitleWeight
                                    ).layoutPriority(1000)
                                }
                                .padding(.top, globalGeometry.safeAreaInsets.top)
                                .frame(width: geometry.width, height: max(geometry.elementsHeight, navigationBarHeight))
                                .offset(y: geometry.elementsOffset)
                            }
                        )
                    }
                    .frame(width: globalGeometry.size.width, height: headerHeight)
                    .zIndex(1000)
                    .offset(y: -headerHeight)

                    ZStack(alignment: .top) {
                        Rectangle()
                            .fill(Color.white)
                            .cornerRadius(100)
                            .frame(height: 100)
                            .offset(y: -50)
                            .shadow(radius: 1)
                            .visibility(isRoundedContent ? .visible : .gone)

                        content
                            .background(Color.background(colorScheme: colorScheme))
                    }
                    .offset(y: -headerHeight)
                    .padding(.bottom, -headerHeight)
                }
            }
            .edgesIgnoringSafeArea(.top)
        }
        .navigationBarTitle(Text(String()), displayMode: .inline)
        .navigationBarHidden(true)
//        .hackNavigationToAllowSwipeBackWhenHidden()
    }
}

extension HeaderScrollView {
    private struct HeaderScrollViewGeometry {
        let width: CGFloat
        let headerHeight: CGFloat
        let elementsHeight: CGFloat
        let headerOffset: CGFloat
        let blurOffset: CGFloat
        let elementsOffset: CGFloat
        let largeTitleWeight: Double
    }

    private func geometry(from geometry: GeometryProxy, safeArea: EdgeInsets) -> HeaderScrollViewGeometry {
        let minY = geometry.frame(in: .global).minY
        let hasScrolledUp = minY > 0
        let hasScrolledToMinHeight = -minY >= headerHeight - navigationBarHeight - safeArea.top

        let headerHeight = hasScrolledUp && scrollUpBehavior == .parallax ?
            geometry.size.height + minY : geometry.size.height

        let elementsHeight = hasScrolledUp && scrollUpBehavior == .sticky ?
            geometry.size.height : geometry.size.height + minY

        let headerOffset: CGFloat
        let blurOffset: CGFloat
        let elementsOffset: CGFloat
        let largeTitleWeight: Double

        if hasScrolledUp {
            headerOffset = -minY
            blurOffset = -minY
            elementsOffset = -minY
            largeTitleWeight = 1
        } else if hasScrolledToMinHeight {
            headerOffset = -minY - self.headerHeight + navigationBarHeight + safeArea.top
            blurOffset = -minY - self.headerHeight + navigationBarHeight + safeArea.top
            elementsOffset = headerOffset / 2 - minY / 2
            largeTitleWeight = 0
        } else {
            headerOffset = scrollDownBehavior == .sticky ? -minY : 0
            blurOffset = 0
            elementsOffset = -minY / 2
            let difference = self.headerHeight - navigationBarHeight - safeArea.top + minY
            largeTitleWeight = difference <= navigationBarHeight + 1 ? Double(difference / (navigationBarHeight + 1)) : 1
        }

        return HeaderScrollViewGeometry(
            width: geometry.size.width,
            headerHeight: headerHeight,
            elementsHeight: elementsHeight,
            headerOffset: headerOffset,
            blurOffset: blurOffset,
            elementsOffset: elementsOffset,
            largeTitleWeight: largeTitleWeight
        )
    }
}

extension Color {
    static func background(colorScheme: ColorScheme) -> Color {
        switch colorScheme {
            case .dark:
                return .black
            case .light:
                fallthrough
            @unknown default:
                return .white
        }
    }
}
