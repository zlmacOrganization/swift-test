// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit
#elseif os(iOS)
  import UIKit
#elseif os(tvOS) || os(watchOS)
  import UIKit
#endif
#if canImport(SwiftUI)
  import SwiftUI
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "ImageAsset.Image", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetImageTypeAlias = ImageAsset.Image

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
internal enum Asset {
  internal static let iconClose = ImageAsset(name: "icon_close")
  internal static let iconHome = ImageAsset(name: "icon_home")
  internal static let iconMenu = ImageAsset(name: "icon_menu")
  internal static let iconSearch = ImageAsset(name: "icon_search")
  internal static let nearbyBtn = ImageAsset(name: "nearby-btn")
  internal static let notificationsBtn = ImageAsset(name: "notifications-btn")
  internal static let settingsBtn = ImageAsset(name: "settings-btn")
  internal static let grzxIconGw = ImageAsset(name: "grzx_icon_gw")
  internal static let grzxIconGwd = ImageAsset(name: "grzx_icon_gwd")
  internal static let grzxIconNor = ImageAsset(name: "grzx_icon_nor")
  internal static let grzxIconWd = ImageAsset(name: "grzx_icon_wd")
  internal static let grzxIconZx = ImageAsset(name: "grzx_icon_zx")
  internal static let grzxWdSel = ImageAsset(name: "grzx_wd_sel")
  internal static let customerReportAdd = ImageAsset(name: "customerReport_add")
  internal static let customerReportDelete = ImageAsset(name: "customerReport_delete")
  internal static let deleteRow = ImageAsset(name: "deleteRow")
  internal static let filterArrowDown = ImageAsset(name: "filter_arrow_down")
  internal static let filterArrowUp = ImageAsset(name: "filter_arrow_up")
  internal static let barbuttoniconAddCube = ImageAsset(name: "barbuttonicon_add_cube")
  internal static let contactsAddNewmessage = ImageAsset(name: "contacts_add_newmessage")
  internal static let contactsAddScan = ImageAsset(name: "contacts_add_scan")
  internal static let receiptPaymentIcon = ImageAsset(name: "receipt_payment_icon")
  internal static let rightFloatBg = ImageAsset(name: "rightFloatBg")
  internal static let iconLocation = ImageAsset(name: "icon_location")
  internal static let image0 = ImageAsset(name: "image0")
  internal static let image1 = ImageAsset(name: "image1")
  internal static let image2 = ImageAsset(name: "image2")
  internal static let image3 = ImageAsset(name: "image3")
  internal static let image4 = ImageAsset(name: "image4")
  internal static let image5 = ImageAsset(name: "image5")
  internal static let imageSticker1 = ImageAsset(name: "imageSticker1")
  internal static let imageSticker10 = ImageAsset(name: "imageSticker10")
  internal static let imageSticker11 = ImageAsset(name: "imageSticker11")
  internal static let imageSticker12 = ImageAsset(name: "imageSticker12")
  internal static let imageSticker13 = ImageAsset(name: "imageSticker13")
  internal static let imageSticker14 = ImageAsset(name: "imageSticker14")
  internal static let imageSticker15 = ImageAsset(name: "imageSticker15")
  internal static let imageSticker16 = ImageAsset(name: "imageSticker16")
  internal static let imageSticker17 = ImageAsset(name: "imageSticker17")
  internal static let imageSticker18 = ImageAsset(name: "imageSticker18")
  internal static let imageSticker2 = ImageAsset(name: "imageSticker2")
  internal static let imageSticker3 = ImageAsset(name: "imageSticker3")
  internal static let imageSticker4 = ImageAsset(name: "imageSticker4")
  internal static let imageSticker5 = ImageAsset(name: "imageSticker5")
  internal static let imageSticker6 = ImageAsset(name: "imageSticker6")
  internal static let imageSticker7 = ImageAsset(name: "imageSticker7")
  internal static let imageSticker8 = ImageAsset(name: "imageSticker8")
  internal static let imageSticker9 = ImageAsset(name: "imageSticker9")
  internal static let noData = ImageAsset(name: "noData")
  internal static let arrowDown = ImageAsset(name: "arrow_down")
  internal static let arrowRight = ImageAsset(name: "arrow_right")
  internal static let browserBack = ImageAsset(name: "browser_back")
  internal static let browserClose = ImageAsset(name: "browser_close")
  internal static let browserRefresh = ImageAsset(name: "browser_refresh")
  internal static let browserShare = ImageAsset(name: "browser_share")
  internal static let btnCloseNormal = ImageAsset(name: "btn_close_normal")
  internal static let leftBack = ImageAsset(name: "left_back")
  internal static let man = ImageAsset(name: "man")
  internal static let navBackWhite = ImageAsset(name: "nav_back_white")
  internal static let radioNomal = ImageAsset(name: "radio_nomal")
  internal static let radioSelected = ImageAsset(name: "radio_selected")
  internal static let shangpin = ImageAsset(name: "shangpin_")
  internal static let wxzshangpin = ImageAsset(name: "wxzshangpin_")
  internal static let searchBg = ImageAsset(name: "search_bg")
  internal static let searchIcon = ImageAsset(name: "search_icon")
  internal static let fbShare = ImageAsset(name: "fb_share")
  internal static let qqShare = ImageAsset(name: "qq_share")
  internal static let qzoneShare = ImageAsset(name: "qzone_share")
  internal static let shareWeiboSelected = ImageAsset(name: "share_weibo_selected")
  internal static let twitterShare = ImageAsset(name: "twitter_share")
  internal static let weiboShare = ImageAsset(name: "weibo_share")
  internal static let wxFriendsShare = ImageAsset(name: "wxFriends_share")
  internal static let wxShare = ImageAsset(name: "wx_share")
  internal static let test = ImageAsset(name: "test")
  internal static let thumb0 = ImageAsset(name: "thumb0")
  internal static let thumb1 = ImageAsset(name: "thumb1")
  internal static let thumb10 = ImageAsset(name: "thumb10")
  internal static let thumb11 = ImageAsset(name: "thumb11")
  internal static let thumb12 = ImageAsset(name: "thumb12")
  internal static let thumb13 = ImageAsset(name: "thumb13")
  internal static let thumb14 = ImageAsset(name: "thumb14")
  internal static let thumb15 = ImageAsset(name: "thumb15")
  internal static let thumb16 = ImageAsset(name: "thumb16")
  internal static let thumb17 = ImageAsset(name: "thumb17")
  internal static let thumb18 = ImageAsset(name: "thumb18")
  internal static let thumb19 = ImageAsset(name: "thumb19")
  internal static let thumb2 = ImageAsset(name: "thumb2")
  internal static let thumb20 = ImageAsset(name: "thumb20")
  internal static let thumb21 = ImageAsset(name: "thumb21")
  internal static let thumb22 = ImageAsset(name: "thumb22")
  internal static let thumb23 = ImageAsset(name: "thumb23")
  internal static let thumb24 = ImageAsset(name: "thumb24")
  internal static let thumb25 = ImageAsset(name: "thumb25")
  internal static let thumb26 = ImageAsset(name: "thumb26")
  internal static let thumb3 = ImageAsset(name: "thumb3")
  internal static let thumb4 = ImageAsset(name: "thumb4")
  internal static let thumb5 = ImageAsset(name: "thumb5")
  internal static let thumb6 = ImageAsset(name: "thumb6")
  internal static let thumb7 = ImageAsset(name: "thumb7")
  internal static let thumb8 = ImageAsset(name: "thumb8")
  internal static let thumb9 = ImageAsset(name: "thumb9")
  internal static let weixin = ImageAsset(name: "weixin")
  internal static let zhifubao = ImageAsset(name: "zhifubao")
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

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

  #if canImport(SwiftUI)
  @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
  internal var swiftUIImage: SwiftUI.Image {
    SwiftUI.Image(asset: self)
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

#if canImport(SwiftUI)
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
internal extension SwiftUI.Image {
  init(asset: ImageAsset) {
    let bundle = BundleToken.bundle
    self.init(asset.name, bundle: bundle)
  }

  init(asset: ImageAsset, label: Text) {
    let bundle = BundleToken.bundle
    self.init(asset.name, bundle: bundle, label: label)
  }

  init(decorative asset: ImageAsset) {
    let bundle = BundleToken.bundle
    self.init(decorative: asset.name, bundle: bundle)
  }
}
#endif

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
