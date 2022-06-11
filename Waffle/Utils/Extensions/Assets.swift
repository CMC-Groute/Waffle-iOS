// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit
#elseif os(iOS)
  import UIKit
#elseif os(tvOS) || os(watchOS)
  import UIKit
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "ColorAsset.Color", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetColorTypeAlias = ColorAsset.Color
@available(*, deprecated, renamed: "ImageAsset.Image", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetImageTypeAlias = ImageAsset.Image

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
internal enum Asset {
  internal enum Assets {
    internal static let accentColor = ColorAsset(name: "AccentColor")
    internal static let joinProcess1 = ImageAsset(name: "join_process_1")
    internal static let joinProcess2 = ImageAsset(name: "join_process_2")
    internal static let joinProcess3 = ImageAsset(name: "join_process_3")
    internal static let joinProcessed3 = ImageAsset(name: "join_processed_3")
    internal static let joinProgressed1 = ImageAsset(name: "join_progressed_1")
    internal static let joinProgressed2 = ImageAsset(name: "join_progressed_2")
    internal static let tabname = ImageAsset(name: "tabname")
    internal static let bar = ImageAsset(name: "bar")
    internal static let btn = ImageAsset(name: "btn")
    internal static let checkCircle = ImageAsset(name: "check_circle")
    internal static let errorCircleRounded = ImageAsset(name: "error_circle_rounded")
    internal static let etc = ImageAsset(name: "etc")
  }
  internal enum Colors {
    internal static let black = ColorAsset(name: "Black")
    internal static let gray1 = ColorAsset(name: "Gray1")
    internal static let gray2 = ColorAsset(name: "Gray2")
    internal static let gray3 = ColorAsset(name: "Gray3")
    internal static let gray4 = ColorAsset(name: "Gray4")
    internal static let gray5 = ColorAsset(name: "Gray5")
    internal static let gray6 = ColorAsset(name: "Gray6")
    internal static let white = ColorAsset(name: "White")
    internal static let beige = ColorAsset(name: "beige")
    internal static let blue = ColorAsset(name: "blue")
    internal static let coolGray = ColorAsset(name: "coolGray")
    internal static let green = ColorAsset(name: "green")
    internal static let lightBlue = ColorAsset(name: "lightBlue")
    internal static let lightGreen = ColorAsset(name: "lightGreen")
    internal static let lightMint = ColorAsset(name: "lightMint")
    internal static let lightPurple = ColorAsset(name: "lightPurple")
    internal static let lightRed = ColorAsset(name: "lightRed")
    internal static let mint = ColorAsset(name: "mint")
    internal static let orange = ColorAsset(name: "orange")
    internal static let purple = ColorAsset(name: "purple")
    internal static let red = ColorAsset(name: "red")
    internal static let warmGray = ColorAsset(name: "warmGray")
    internal static let yellow = ColorAsset(name: "yellow")
  }
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

internal final class ColorAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Color = NSColor
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Color = UIColor
  #endif

  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  internal private(set) lazy var color: Color = {
    guard let color = Color(asset: self) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }()

  #if os(iOS) || os(tvOS)
  @available(iOS 11.0, tvOS 11.0, *)
  internal func color(compatibleWith traitCollection: UITraitCollection) -> Color {
    let bundle = BundleToken.bundle
    guard let color = Color(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }
  #endif

  fileprivate init(name: String) {
    self.name = name
  }
}

internal extension ColorAsset.Color {
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  convenience init?(asset: ColorAsset) {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSColor.Name(asset.name), bundle: bundle)
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

internal struct ImageAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Image = NSImage
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Image = UIImage
  #endif

  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, macOS 10.7, *)
  internal var image: Image {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    let image = Image(named: name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    let name = NSImage.Name(self.name)
    let image = (bundle == .main) ? NSImage(named: name) : bundle.image(forResource: name)
    #elseif os(watchOS)
    let image = Image(named: name)
    #endif
    guard let result = image else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }

  #if os(iOS) || os(tvOS)
  @available(iOS 8.0, tvOS 9.0, *)
  internal func image(compatibleWith traitCollection: UITraitCollection) -> Image {
    let bundle = BundleToken.bundle
    guard let result = Image(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }
  #endif
}

internal extension ImageAsset.Image {
  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, *)
  @available(macOS, deprecated,
    message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
  convenience init?(asset: ImageAsset) {
    #if os(iOS) || os(tvOS)
    let bundle = BundleToken.bundle
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSImage.Name(asset.name))
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
