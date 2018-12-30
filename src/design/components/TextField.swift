import UIKit

class TextField: UITextField {
  struct Constants {
    static let defaultHeight: CGFloat = 48
    static let defaultLeftPadding: CGFloat = 12
    static let defaultCornerRadius: CGFloat = 8
    static let defaultIconSize: CGFloat = 24
    static let defaultNormalDepth = DepthPreset.depth1
    static let defaultActiveDepth = DepthPreset.depth3
  }
  /// The textfield change elevation on touch.
  private var isRaised: Bool = false

  convenience init(
    placeholder: String,
    icon: String? = nil,
    raised: Bool = true
  ) {
    self.init(frame: CGRect.zero)
    self.placeholder = placeholder
    self.isRaised = raised
    backgroundColor = Palette.current.light
    layer.cornerRadius = Constants.defaultCornerRadius
    layer.masksToBounds = false
    if (isRaised) {
      depthPreset = Constants.defaultNormalDepth
    } else {
      layer.borderWidth = 1
      layer.borderColor = Palette.current.hairline.cgColor
    }
    font = Typography.current.style(.subtitle2).font
    textColor = Palette.current.text
    if let icon = icon {
      leftImage = UIImage(named: icon)
    }
    updateView()
  }

  // Provides left padding for images
  override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
    var textRect = super.leftViewRect(forBounds: bounds)
    textRect.origin.x += leftPadding
    return textRect
  }
  /// The desired left icon.
  var leftImage: UIImage? {
    didSet { updateView() }
  }
  /// Padding for the left icon.
  var leftPadding: CGFloat = Constants.defaultLeftPadding
  /// Transform the text into attributed text whenever is set.
  override var text: String? {
    didSet { updateView() }
  }
  /// Override is focused to get elevation change.
  override func becomeFirstResponder() -> Bool {
    let result = super.becomeFirstResponder()
    guard isRaised else {
      return result
    }
    depthPreset = result ? Constants.defaultActiveDepth : Constants.defaultNormalDepth
    return result
  }

  /// Update the
  private func updateView() {
    if let image = leftImage {
      leftViewMode = UITextField.ViewMode.always
      let imageView = UIImageView(frame:CGRect(
        x: 0,
        y: 0,
        width: Constants.defaultIconSize + Constants.defaultLeftPadding,
        height: Constants.defaultIconSize))
      imageView.contentMode = .scaleAspectFit
      imageView.image = image
      imageView.tintColor = Palette.current.primary(.tint700)
      leftView = imageView
    } else {
      leftViewMode = UITextField.ViewMode.always
      leftView = UIView(frame: CGRect(x: 0, y: 0, width: leftPadding, height: 0))
    }
    // Placeholder text color
    let placeholder = self.placeholder ?? ""
    attributedPlaceholder =
      Typography.current
        .style(.subtitle2)
        .withColor(Palette.current.primary(.tint700))
        .asAttributedString(placeholder)
    if let text = text {
      attributedText =
        Typography.current
          .style(.subtitle2)
          .withColor(Palette.current.text)
          .asAttributedString(text)
    }
  }

  override func sizeThatFits(_ size: CGSize) -> CGSize {
    return CGSize(width: size.width, height: Constants.defaultHeight)
  }
}