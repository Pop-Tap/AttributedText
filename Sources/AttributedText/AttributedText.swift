import SwiftUI

/// A view that displays styled attributed text.
public struct AttributedText: View {
  private var textSizeViewModel = TextSizeViewModel()
  @State private var textSize: CGSize?

  private let attributedText: NSAttributedString
  private let onOpenLink: ((URL) -> Void)?

  /// Creates an attributed text view.
  /// - Parameters:
  ///   - attributedText: An attributed string to display.
  ///   - onOpenLink: The action to perform when the user opens a link in the text. When not specified,
  ///                 the  view opens the links using the `OpenURLAction` from the environment.
  public init(_ attributedText: NSAttributedString, onOpenLink: ((URL) -> Void)? = nil) {
    self.attributedText = attributedText
    self.onOpenLink = onOpenLink
  }

  /// Creates an attributed text view.
  /// - Parameters:
  ///   - attributedText: A closure that creates the attributed string to display.
  ///   - onOpenLink: The action to perform when the user opens a link in the text. When not specified,
  ///                 the  view opens the links using the `OpenURLAction` from the environment.
  public init(attributedText: () -> NSAttributedString, onOpenLink: ((URL) -> Void)? = nil) {
    self.init(attributedText(), onOpenLink: onOpenLink)
  }

  public var body: some View {
    GeometryReader { geometry in
      AttributedTextImpl(
        attributedText: attributedText,
        maxLayoutWidth: geometry.maxWidth,
        textSizeViewModel: textSizeViewModel,
        onOpenLink: onOpenLink
      )
    }
    .frame(
      idealWidth: textSize?.width,
      idealHeight: textSize?.height
    )
    .fixedSize(horizontal: false, vertical: true)
    .onReceive(textSizeViewModel.$textSize) { size in
      guard let size = size,
            size.width > 0,
            size.height > 0 else {
        return
      }
      textSize = size
    }
  }
}

extension GeometryProxy {
  fileprivate var maxWidth: CGFloat {
    size.width - safeAreaInsets.leading - safeAreaInsets.trailing
  }
}
