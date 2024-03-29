//
//  IQUIView+IQKeyboardToolbar.swift
// https://github.com/hackiftekhar/IQKeyboardManager
// Copyright (c) 2013-20 Iftekhar Qurashi.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit

/**
 IQBarButtonItemConfiguration for creating toolbar with bar button items
 */
@available(iOSApplicationExtension, unavailable)
@objc public final class IQBarButtonItemConfiguration: NSObject {
    @objc public init(barButtonSystemItem: UIBarButtonItem.SystemItem, action: Selector) {
        self.barButtonSystemItem = barButtonSystemItem
        image = nil
        title = nil
        self.action = action
        super.init()
    }

    @objc public init(image: UIImage, action: Selector) {
        barButtonSystemItem = nil
        self.image = image
        title = nil
        self.action = action
        super.init()
    }

    @objc public init(title: String, action: Selector) {
        barButtonSystemItem = nil
        image = nil
        self.title = title
        self.action = action
        super.init()
    }

    public let barButtonSystemItem: UIBarButtonItem.SystemItem? // System Item to be used to instantiate bar button.

    @objc public let image: UIImage? // Image to show on bar button item if it's not a system item.

    @objc public let title: String? // Title to show on bar button item if it's not a system item.

    @objc public let action: Selector? // action for bar button item. Usually 'doneAction:(IQBarButtonItem*)item'.
}

/**
 UIImage category methods to get next/prev images
 */
@available(iOSApplicationExtension, unavailable)
@objc public extension UIImage {
    static func keyboardPreviousImage() -> UIImage? {
        enum Static {
            static var keyboardUpImage: UIImage?
        }

        if Static.keyboardUpImage == nil {
            // swiftlint:disable line_length
            let base64Data = "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"
            // swiftlint:enable line_length

            if let data = Data(base64Encoded: base64Data, options: .ignoreUnknownCharacters) {
                Static.keyboardUpImage = UIImage(data: data, scale: 3)
            }

            // Support for RTL languages like Arabic, Persia etc... (Bug ID: #448)
            Static.keyboardUpImage = Static.keyboardUpImage?.imageFlippedForRightToLeftLayoutDirection()
        }

        return Static.keyboardUpImage
    }

    static func keyboardNextImage() -> UIImage? {
        enum Static {
            static var keyboardDownImage: UIImage?
        }

        if Static.keyboardDownImage == nil {
            // swiftlint:disable line_length
            let base64Data = "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"
            // swiftlint:enable line_length

            if let data = Data(base64Encoded: base64Data, options: .ignoreUnknownCharacters) {
                Static.keyboardDownImage = UIImage(data: data, scale: 3)
            }

            // Support for RTL languages like Arabic, Persia etc... (Bug ID: #448)
            Static.keyboardDownImage = Static.keyboardDownImage?.imageFlippedForRightToLeftLayoutDirection()
        }

        return Static.keyboardDownImage
    }
}

/**
 UIView category methods to add IQToolbar on UIKeyboard.
 */
@available(iOSApplicationExtension, unavailable)
@objc public extension UIView {
    private enum AssociatedKeys {
        static var keyboardToolbar: Int = 0
        static var shouldHideToolbarPlaceholder: Int = 0
        static var toolbarPlaceholder: Int = 0
    }

    // MARK: Toolbar

    /**
     IQToolbar references for better customization control.
     */
    var keyboardToolbar: IQToolbar {
        var toolbar = inputAccessoryView as? IQToolbar

        if toolbar == nil {
            toolbar = objc_getAssociatedObject(self, &AssociatedKeys.keyboardToolbar) as? IQToolbar
        }

        if let unwrappedToolbar = toolbar {
            return unwrappedToolbar
        } else {
            var width: CGFloat = 0

            if #available(iOS 13.0, *) {
                width = window?.windowScene?.screen.bounds.width ?? .zero
            } else {
                width = UIScreen.main.bounds.width
            }

            let frame = CGRect(origin: .zero, size: .init(width: width, height: 44))
            let newToolbar = IQToolbar(frame: frame)

            objc_setAssociatedObject(self, &AssociatedKeys.keyboardToolbar, newToolbar, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)

            return newToolbar
        }
    }

    // MARK: Toolbar title

    /**
     If `shouldHideToolbarPlaceholder` is YES, then title will not be added to the toolbar. Default to NO.
     */
    var shouldHideToolbarPlaceholder: Bool {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.shouldHideToolbarPlaceholder) as? Bool ?? false
        }
        set(newValue) {
            objc_setAssociatedObject(self, &AssociatedKeys.shouldHideToolbarPlaceholder, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            keyboardToolbar.titleBarButton.title = drawingToolbarPlaceholder
        }
    }

    /**
     `toolbarPlaceholder` to override default `placeholder` text when drawing text on toolbar.
     */
    var toolbarPlaceholder: String? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.toolbarPlaceholder) as? String
        }
        set(newValue) {
            objc_setAssociatedObject(self, &AssociatedKeys.toolbarPlaceholder, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            keyboardToolbar.titleBarButton.title = drawingToolbarPlaceholder
        }
    }

    /**
     `drawingToolbarPlaceholder` will be actual text used to draw on toolbar. This would either `placeholder` or `toolbarPlaceholder`.
     */
    var drawingToolbarPlaceholder: String? {
        if shouldHideToolbarPlaceholder {
            return nil
        } else if toolbarPlaceholder?.isEmpty == false {
            return toolbarPlaceholder
        } else if let placeholderable: IQPlaceholderable = self as? IQPlaceholderable {
            if let placeholder = placeholderable.attributedPlaceholder?.string,
               !placeholder.isEmpty
            {
                return placeholder
            } else if let placeholder = placeholderable.placeholder {
                return placeholder
            } else {
                return nil
            }
        } else {
            return nil
        }
    }

    // MARK: Private helper

    private static func flexibleBarButtonItem() -> IQBarButtonItem {
        enum Static {
            static let nilButton = IQBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        }

        Static.nilButton.isSystemItem = true
        return Static.nilButton
    }

    // MARK: Common

    // swiftlint:disable function_body_length
    func addKeyboardToolbarWithTarget(target: AnyObject?,
                                      titleText: String?,
                                      titleAccessibilityLabel: String? = nil,
                                      rightBarButtonConfiguration: IQBarButtonItemConfiguration?,
                                      previousBarButtonConfiguration: IQBarButtonItemConfiguration? = nil,
                                      nextBarButtonConfiguration: IQBarButtonItemConfiguration? = nil)
    {
        // If can't set InputAccessoryView. Then return
        if responds(to: #selector(setter: UITextField.inputAccessoryView)) {
            //  Creating a toolBar for phoneNumber keyboard
            let toolbar = self.keyboardToolbar

            var items: [IQBarButtonItem] = []

            if let prevConfig = previousBarButtonConfiguration {
                var prev = toolbar.previousBarButton

                if prevConfig.barButtonSystemItem == nil, !prev.isSystemItem {
                    prev.title = prevConfig.title
                    prev.accessibilityLabel = prevConfig.accessibilityLabel
                    prev.accessibilityIdentifier = prev.accessibilityLabel
                    prev.image = prevConfig.image
                    prev.target = target
                    prev.action = prevConfig.action
                } else {
                    if let systemItem = prevConfig.barButtonSystemItem {
                        prev = IQBarButtonItem(barButtonSystemItem: systemItem, target: target, action: prevConfig.action)
                        prev.isSystemItem = true
                    } else if let image = prevConfig.image {
                        prev = IQBarButtonItem(image: image, style: .plain, target: target, action: prevConfig.action)
                    } else {
                        prev = IQBarButtonItem(title: prevConfig.title, style: .plain, target: target, action: prevConfig.action)
                    }

                    prev.invocation = toolbar.previousBarButton.invocation
                    prev.accessibilityLabel = prevConfig.accessibilityLabel
                    prev.accessibilityIdentifier = prev.accessibilityLabel
                    prev.isEnabled = toolbar.previousBarButton.isEnabled
                    prev.tag = toolbar.previousBarButton.tag
                    toolbar.previousBarButton = prev
                }

                items.append(prev)
            }

            if previousBarButtonConfiguration != nil, nextBarButtonConfiguration != nil {
                items.append(toolbar.fixedSpaceBarButton)
            }

            if let nextConfig = nextBarButtonConfiguration {
                var next = toolbar.nextBarButton

                if nextConfig.barButtonSystemItem == nil, !next.isSystemItem {
                    next.title = nextConfig.title
                    next.accessibilityLabel = nextConfig.accessibilityLabel
                    next.accessibilityIdentifier = next.accessibilityLabel
                    next.image = nextConfig.image
                    next.target = target
                    next.action = nextConfig.action
                } else {
                    if let systemItem = nextConfig.barButtonSystemItem {
                        next = IQBarButtonItem(barButtonSystemItem: systemItem, target: target, action: nextConfig.action)
                        next.isSystemItem = true
                    } else if let image = nextConfig.image {
                        next = IQBarButtonItem(image: image, style: .plain, target: target, action: nextConfig.action)
                    } else {
                        next = IQBarButtonItem(title: nextConfig.title, style: .plain, target: target, action: nextConfig.action)
                    }

                    next.invocation = toolbar.nextBarButton.invocation
                    next.accessibilityLabel = nextConfig.accessibilityLabel
                    next.accessibilityIdentifier = next.accessibilityLabel
                    next.isEnabled = toolbar.nextBarButton.isEnabled
                    next.tag = toolbar.nextBarButton.tag
                    toolbar.nextBarButton = next
                }

                items.append(next)
            }

            // Title bar button item
            do {
                // Flexible space
                items.append(UIView.flexibleBarButtonItem())

                // Title button
                toolbar.titleBarButton.title = titleText
                toolbar.titleBarButton.accessibilityLabel = titleAccessibilityLabel
                toolbar.titleBarButton.accessibilityIdentifier = titleAccessibilityLabel

                toolbar.titleBarButton.customView?.frame = CGRect.zero

                items.append(toolbar.titleBarButton)

                // Flexible space
                items.append(UIView.flexibleBarButtonItem())
            }

            if let rightConfig = rightBarButtonConfiguration {
                var done = toolbar.doneBarButton

                if rightConfig.barButtonSystemItem == nil, !done.isSystemItem {
                    done.title = rightConfig.title
                    done.accessibilityLabel = rightConfig.accessibilityLabel
                    done.accessibilityIdentifier = done.accessibilityLabel
                    done.image = rightConfig.image
                    done.target = target
                    done.action = rightConfig.action
                } else {
                    if let systemItem = rightConfig.barButtonSystemItem {
                        done = IQBarButtonItem(barButtonSystemItem: systemItem, target: target, action: rightConfig.action)
                        done.isSystemItem = true
                    } else if let image = rightConfig.image {
                        done = IQBarButtonItem(image: image, style: .plain, target: target, action: rightConfig.action)
                    } else {
                        done = IQBarButtonItem(title: rightConfig.title, style: .plain, target: target, action: rightConfig.action)
                    }

                    done.invocation = toolbar.doneBarButton.invocation
                    done.accessibilityLabel = rightConfig.accessibilityLabel
                    done.accessibilityIdentifier = done.accessibilityLabel
                    done.isEnabled = toolbar.doneBarButton.isEnabled
                    done.tag = toolbar.doneBarButton.tag
                    toolbar.doneBarButton = done
                }

                items.append(done)
            }

            //  Adding button to toolBar.
            toolbar.items = items

            if let textInput = self as? UITextInput {
                switch textInput.keyboardAppearance {
                case .dark?:
                    toolbar.barStyle = .black
                default:
                    toolbar.barStyle = .default
                }
            }

            //  Setting toolbar to keyboard.
            let shouldReloadInputViews: Bool = self.inputAccessoryView == nil
            if let textField = self as? UITextField {
                textField.inputAccessoryView = toolbar
            } else if let textView = self as? UITextView {
                textView.inputAccessoryView = toolbar
            }
            if shouldReloadInputViews {
                self.reloadInputViews()
            }
        }
    }

    // swiftlint:enable function_body_length

    // MARK: Right

    func addDoneOnKeyboardWithTarget(_ target: AnyObject?, action: Selector, shouldShowPlaceholder: Bool = false, titleAccessibilityLabel: String? = nil) {
        addDoneOnKeyboardWithTarget(target, action: action, titleText: shouldShowPlaceholder ? drawingToolbarPlaceholder : nil, titleAccessibilityLabel: titleAccessibilityLabel)
    }

    func addDoneOnKeyboardWithTarget(_ target: AnyObject?, action: Selector, titleText: String?, titleAccessibilityLabel _: String? = nil) {
        let rightConfiguration = IQBarButtonItemConfiguration(barButtonSystemItem: .done, action: action)

        addKeyboardToolbarWithTarget(target: target, titleText: titleText, rightBarButtonConfiguration: rightConfiguration)
    }

    func addRightButtonOnKeyboardWithImage(_ image: UIImage, target: AnyObject?, action: Selector, shouldShowPlaceholder: Bool = false, titleAccessibilityLabel: String? = nil) {
        addRightButtonOnKeyboardWithImage(image, target: target, action: action, titleText: shouldShowPlaceholder ? drawingToolbarPlaceholder : nil, titleAccessibilityLabel: titleAccessibilityLabel)
    }

    func addRightButtonOnKeyboardWithImage(_ image: UIImage, target: AnyObject?, action: Selector, titleText: String?, titleAccessibilityLabel: String? = nil) {
        let rightConfiguration = IQBarButtonItemConfiguration(image: image, action: action)

        addKeyboardToolbarWithTarget(target: target, titleText: titleText, titleAccessibilityLabel: titleAccessibilityLabel, rightBarButtonConfiguration: rightConfiguration)
    }

    func addRightButtonOnKeyboardWithText(_ text: String, target: AnyObject?, action: Selector, shouldShowPlaceholder: Bool = false, titleAccessibilityLabel: String? = nil) {
        addRightButtonOnKeyboardWithText(text, target: target, action: action, titleText: shouldShowPlaceholder ? drawingToolbarPlaceholder : nil, titleAccessibilityLabel: titleAccessibilityLabel)
    }

    func addRightButtonOnKeyboardWithText(_ text: String, target: AnyObject?, action: Selector, titleText: String?, titleAccessibilityLabel: String? = nil) {
        let rightConfiguration = IQBarButtonItemConfiguration(title: text, action: action)

        addKeyboardToolbarWithTarget(target: target, titleText: titleText, titleAccessibilityLabel: titleAccessibilityLabel, rightBarButtonConfiguration: rightConfiguration)
    }

    // MARK: Right/Left

    func addCancelDoneOnKeyboardWithTarget(_ target: AnyObject?, cancelAction: Selector, doneAction: Selector, shouldShowPlaceholder: Bool = false, titleAccessibilityLabel: String? = nil) {
        addCancelDoneOnKeyboardWithTarget(target, cancelAction: cancelAction, doneAction: doneAction, titleText: shouldShowPlaceholder ? drawingToolbarPlaceholder : nil, titleAccessibilityLabel: titleAccessibilityLabel)
    }

    func addRightLeftOnKeyboardWithTarget(_ target: AnyObject?, leftButtonTitle: String, rightButtonTitle: String, leftButtonAction: Selector, rightButtonAction: Selector, shouldShowPlaceholder: Bool = false, titleAccessibilityLabel: String? = nil) {
        addRightLeftOnKeyboardWithTarget(target, leftButtonTitle: leftButtonTitle, rightButtonTitle: rightButtonTitle, leftButtonAction: leftButtonAction, rightButtonAction: rightButtonAction, titleText: shouldShowPlaceholder ? drawingToolbarPlaceholder : nil, titleAccessibilityLabel: titleAccessibilityLabel)
    }

    func addRightLeftOnKeyboardWithTarget(_ target: AnyObject?, leftButtonImage: UIImage, rightButtonImage: UIImage, leftButtonAction: Selector, rightButtonAction: Selector, shouldShowPlaceholder: Bool = false, titleAccessibilityLabel: String? = nil) {
        addRightLeftOnKeyboardWithTarget(target, leftButtonImage: leftButtonImage, rightButtonImage: rightButtonImage, leftButtonAction: leftButtonAction, rightButtonAction: rightButtonAction, titleText: shouldShowPlaceholder ? drawingToolbarPlaceholder : nil, titleAccessibilityLabel: titleAccessibilityLabel)
    }

    func addCancelDoneOnKeyboardWithTarget(_ target: AnyObject?, cancelAction: Selector, doneAction: Selector, titleText: String?, titleAccessibilityLabel: String? = nil) {
        let leftConfiguration = IQBarButtonItemConfiguration(barButtonSystemItem: .cancel, action: cancelAction)
        let rightConfiguration = IQBarButtonItemConfiguration(barButtonSystemItem: .done, action: doneAction)

        addKeyboardToolbarWithTarget(target: target, titleText: titleText, titleAccessibilityLabel: titleAccessibilityLabel, rightBarButtonConfiguration: rightConfiguration, previousBarButtonConfiguration: leftConfiguration)
    }

    func addRightLeftOnKeyboardWithTarget(_ target: AnyObject?, leftButtonTitle: String, rightButtonTitle: String, leftButtonAction: Selector, rightButtonAction: Selector, titleText: String?, titleAccessibilityLabel: String? = nil) {
        let leftConfiguration = IQBarButtonItemConfiguration(title: leftButtonTitle, action: leftButtonAction)
        let rightConfiguration = IQBarButtonItemConfiguration(title: rightButtonTitle, action: rightButtonAction)

        addKeyboardToolbarWithTarget(target: target, titleText: titleText, titleAccessibilityLabel: titleAccessibilityLabel, rightBarButtonConfiguration: rightConfiguration, previousBarButtonConfiguration: leftConfiguration)
    }

    func addRightLeftOnKeyboardWithTarget(_ target: AnyObject?, leftButtonImage: UIImage, rightButtonImage: UIImage, leftButtonAction: Selector, rightButtonAction: Selector, titleText: String?, titleAccessibilityLabel: String? = nil) {
        let leftConfiguration = IQBarButtonItemConfiguration(image: leftButtonImage, action: leftButtonAction)
        let rightConfiguration = IQBarButtonItemConfiguration(image: rightButtonImage, action: rightButtonAction)

        addKeyboardToolbarWithTarget(target: target, titleText: titleText, titleAccessibilityLabel: titleAccessibilityLabel, rightBarButtonConfiguration: rightConfiguration, previousBarButtonConfiguration: leftConfiguration)
    }

    // MARK: Previous/Next/Right

    func addPreviousNextDoneOnKeyboardWithTarget(_ target: AnyObject?, previousAction: Selector, nextAction: Selector, doneAction: Selector, shouldShowPlaceholder: Bool = false, titleAccessibilityLabel: String? = nil) {
        addPreviousNextDoneOnKeyboardWithTarget(target, previousAction: previousAction, nextAction: nextAction, doneAction: doneAction, titleText: shouldShowPlaceholder ? drawingToolbarPlaceholder : nil, titleAccessibilityLabel: titleAccessibilityLabel)
    }

    func addPreviousNextRightOnKeyboardWithTarget(_ target: AnyObject?, rightButtonImage: UIImage, previousAction: Selector, nextAction: Selector, rightButtonAction: Selector, shouldShowPlaceholder: Bool = false, titleAccessibilityLabel: String? = nil) {
        addPreviousNextRightOnKeyboardWithTarget(target, rightButtonImage: rightButtonImage, previousAction: previousAction, nextAction: nextAction, rightButtonAction: rightButtonAction, titleText: shouldShowPlaceholder ? drawingToolbarPlaceholder : nil, titleAccessibilityLabel: titleAccessibilityLabel)
    }

    func addPreviousNextRightOnKeyboardWithTarget(_ target: AnyObject?, rightButtonTitle: String, previousAction: Selector, nextAction: Selector, rightButtonAction: Selector, shouldShowPlaceholder: Bool = false, titleAccessibilityLabel: String? = nil) {
        addPreviousNextRightOnKeyboardWithTarget(target, rightButtonTitle: rightButtonTitle, previousAction: previousAction, nextAction: nextAction, rightButtonAction: rightButtonAction, titleText: shouldShowPlaceholder ? drawingToolbarPlaceholder : nil, titleAccessibilityLabel: titleAccessibilityLabel)
    }

    func addPreviousNextDoneOnKeyboardWithTarget(_ target: AnyObject?, previousAction: Selector, nextAction: Selector, doneAction: Selector, titleText: String?, titleAccessibilityLabel: String? = nil) {
        let rightConfiguration = IQBarButtonItemConfiguration(barButtonSystemItem: .done, action: doneAction)
        let nextConfiguration = IQBarButtonItemConfiguration(image: UIImage.keyboardNextImage() ?? UIImage(), action: nextAction)
        let prevConfiguration = IQBarButtonItemConfiguration(image: UIImage.keyboardPreviousImage() ?? UIImage(), action: previousAction)

        addKeyboardToolbarWithTarget(target: target, titleText: titleText, titleAccessibilityLabel: titleAccessibilityLabel, rightBarButtonConfiguration: rightConfiguration, previousBarButtonConfiguration: prevConfiguration, nextBarButtonConfiguration: nextConfiguration)
    }

    func addPreviousNextRightOnKeyboardWithTarget(_ target: AnyObject?, rightButtonImage: UIImage, previousAction: Selector, nextAction: Selector, rightButtonAction: Selector, titleText: String?, titleAccessibilityLabel: String? = nil) {
        let rightConfiguration = IQBarButtonItemConfiguration(image: rightButtonImage, action: rightButtonAction)
        let nextConfiguration = IQBarButtonItemConfiguration(image: UIImage.keyboardNextImage() ?? UIImage(), action: nextAction)
        let prevConfiguration = IQBarButtonItemConfiguration(image: UIImage.keyboardPreviousImage() ?? UIImage(), action: previousAction)

        addKeyboardToolbarWithTarget(target: target, titleText: titleText, titleAccessibilityLabel: titleAccessibilityLabel, rightBarButtonConfiguration: rightConfiguration, previousBarButtonConfiguration: prevConfiguration, nextBarButtonConfiguration: nextConfiguration)
    }

    func addPreviousNextRightOnKeyboardWithTarget(_ target: AnyObject?, rightButtonTitle: String, previousAction: Selector, nextAction: Selector, rightButtonAction: Selector, titleText: String?, titleAccessibilityLabel: String? = nil) {
        let rightConfiguration = IQBarButtonItemConfiguration(title: rightButtonTitle, action: rightButtonAction)
        let nextConfiguration = IQBarButtonItemConfiguration(image: UIImage.keyboardNextImage() ?? UIImage(), action: nextAction)
        let prevConfiguration = IQBarButtonItemConfiguration(image: UIImage.keyboardPreviousImage() ?? UIImage(), action: previousAction)

        addKeyboardToolbarWithTarget(target: target, titleText: titleText, titleAccessibilityLabel: titleAccessibilityLabel, rightBarButtonConfiguration: rightConfiguration, previousBarButtonConfiguration: prevConfiguration, nextBarButtonConfiguration: nextConfiguration)
    }
}
