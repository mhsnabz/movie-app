//
//  IQKeyboardManager+Position.swift
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

// import Foundation - UIKit contains Foundation
import UIKit

@available(iOSApplicationExtension, unavailable)
public extension IQKeyboardManager {
    private enum AssociatedKeys {
        static var movedDistance: Int = 0
        static var movedDistanceChanged: Int = 0
        static var lastScrollView: Int = 0
        static var startingContentOffset: Int = 0
        static var startingScrollIndicatorInsets: Int = 0
        static var startingContentInsets: Int = 0
        static var startingTextViewContentInsets: Int = 0
        static var startingTextViewScrollIndicatorInsets: Int = 0
        static var isTextViewContentInsetChanged: Int = 0
    }

    /**
     moved distance to the top used to maintain distance between keyboard and textField. Most of the time this will be a positive value.
     */
    @objc private(set) var movedDistance: CGFloat {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.movedDistance) as? CGFloat ?? 0.0
        }
        set(newValue) {
            objc_setAssociatedObject(self, &AssociatedKeys.movedDistance, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            movedDistanceChanged?(movedDistance)
        }
    }

    /**
     Will be called then movedDistance will be changed
      */
    @objc var movedDistanceChanged: ((CGFloat) -> Void)? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.movedDistanceChanged) as? ((CGFloat) -> Void)
        }
        set(newValue) {
            objc_setAssociatedObject(self, &AssociatedKeys.movedDistanceChanged, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            movedDistanceChanged?(movedDistance)
        }
    }

    /** Variable to save lastScrollView that was scrolled. */
    internal weak var lastScrollView: UIScrollView? {
        get {
            return (objc_getAssociatedObject(self, &AssociatedKeys.lastScrollView) as? WeakObjectContainer)?.object as? UIScrollView
        }
        set(newValue) {
            objc_setAssociatedObject(self, &AssociatedKeys.lastScrollView, WeakObjectContainer(object: newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    /** LastScrollView's initial contentOffset. */
    internal var startingContentOffset: CGPoint {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.startingContentOffset) as? CGPoint ?? IQKeyboardManager.kIQCGPointInvalid
        }
        set(newValue) {
            objc_setAssociatedObject(self, &AssociatedKeys.startingContentOffset, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    /** LastScrollView's initial scrollIndicatorInsets. */
    internal var startingScrollIndicatorInsets: UIEdgeInsets {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.startingScrollIndicatorInsets) as? UIEdgeInsets ?? .init()
        }
        set(newValue) {
            objc_setAssociatedObject(self, &AssociatedKeys.startingScrollIndicatorInsets, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    /** LastScrollView's initial contentInsets. */
    internal var startingContentInsets: UIEdgeInsets {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.startingContentInsets) as? UIEdgeInsets ?? .init()
        }
        set(newValue) {
            objc_setAssociatedObject(self, &AssociatedKeys.startingContentInsets, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    /** used to adjust contentInset of UITextView. */
    internal var startingTextViewContentInsets: UIEdgeInsets {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.startingTextViewContentInsets) as? UIEdgeInsets ?? .init()
        }
        set(newValue) {
            objc_setAssociatedObject(self, &AssociatedKeys.startingTextViewContentInsets, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    /** used to adjust scrollIndicatorInsets of UITextView. */
    internal var startingTextViewScrollIndicatorInsets: UIEdgeInsets {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.startingTextViewScrollIndicatorInsets) as? UIEdgeInsets ?? .init()
        }
        set(newValue) {
            objc_setAssociatedObject(self, &AssociatedKeys.startingTextViewScrollIndicatorInsets, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    /** used with textView to detect a textFieldView contentInset is changed or not. (Bug ID: #92) */
    internal var isTextViewContentInsetChanged: Bool {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.isTextViewContentInsetChanged) as? Bool ?? false
        }
        set(newValue) {
            objc_setAssociatedObject(self, &AssociatedKeys.isTextViewContentInsetChanged, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    @objc internal func applicationDidBecomeActive(_: Notification) {
        guard privateIsEnabled(),
              keyboardShowing,
              topViewBeginOrigin.equalTo(IQKeyboardManager.kIQCGPointInvalid) == false, let textFieldView = textFieldView,
              textFieldView.isAlertViewTextField() == false
        else {
            return
        }
        adjustPosition()
    }

    // swiftlint:disable function_body_length
    /* Adjusting RootViewController's frame according to interface orientation. */
    internal func adjustPosition() {
        //  We are unable to get textField object while keyboard showing on WKWebView's textField.  (Bug ID: #11)
        guard UIApplication.shared.applicationState == .active,
              let textFieldView = textFieldView,
              let rootController = textFieldView.parentContainerViewController(),
              let window = keyWindow(),
              let textFieldViewRectInWindow = textFieldView.superview?.convert(textFieldView.frame, to: window),
              let textFieldViewRectInRootSuperview = textFieldView.superview?.convert(textFieldView.frame, to: rootController.view?.superview)
        else {
            return
        }

        let startTime = CACurrentMediaTime()
        showLog(">>>>> \(#function) started >>>>>", indentation: 1)

        //  Getting RootViewOrigin.
        var rootViewOrigin = rootController.view.frame.origin

        // Maintain keyboardDistanceFromTextField
        let specialKeyboardDistanceFromTextField: CGFloat

        if let searchBar = textFieldView.textFieldSearchBar() {
            specialKeyboardDistanceFromTextField = searchBar.keyboardDistanceFromTextField
        } else {
            specialKeyboardDistanceFromTextField = textFieldView.keyboardDistanceFromTextField
        }

        let newKeyboardDistanceFromTextField = (specialKeyboardDistanceFromTextField == kIQUseDefaultKeyboardDistance) ? keyboardDistanceFromTextField : specialKeyboardDistanceFromTextField

        let kbSize: CGSize
        let originalKbSize: CGSize

        // Calculating actual keyboard covered size respect to window, keyboard frame may be different when hardware keyboard is attached (Bug ID: #469) (Bug ID: #381) (Bug ID: #1506)
        do {
            var kbFrame = keyboardFrame

            kbFrame.origin.y -= newKeyboardDistanceFromTextField
            kbFrame.size.height += newKeyboardDistanceFromTextField

            kbFrame.origin.y -= topViewBeginSafeAreaInsets.bottom
            kbFrame.size.height += topViewBeginSafeAreaInsets.bottom

            let intersectRect = kbFrame.intersection(window.frame)
            if intersectRect.isNull {
                kbSize = CGSize(width: kbFrame.size.width, height: 0)
            } else {
                kbSize = intersectRect.size
            }
        }

        do {
            let intersectRect = keyboardFrame.intersection(window.frame)
            if intersectRect.isNull {
                originalKbSize = CGSize(width: keyboardFrame.size.width, height: 0)
            } else {
                originalKbSize = intersectRect.size
            }
        }

        let statusBarHeight: CGFloat

        let navigationBarAreaHeight: CGFloat
        if let navigationController = rootController.navigationController {
            navigationBarAreaHeight = navigationController.navigationBar.frame.maxY
        } else {
            #if swift(>=5.1)
                if #available(iOS 13, *) {
                    statusBarHeight = window.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
                } else {
                    statusBarHeight = UIApplication.shared.statusBarFrame.height
                }
            #else
                statusBarHeight = UIApplication.shared.statusBarFrame.height
            #endif
            navigationBarAreaHeight = statusBarHeight
        }

        let layoutAreaHeight: CGFloat = rootController.view.directionalLayoutMargins.top

        let isScrollableTextView: Bool

        if let textView = textFieldView as? UIScrollView, textFieldView.responds(to: #selector(getter: UITextView.isEditable)) {
            isScrollableTextView = textView.isScrollEnabled
        } else {
            isScrollableTextView = false
        }

        let topLayoutGuide: CGFloat = max(navigationBarAreaHeight, layoutAreaHeight)

        // Validation of textView for case where there is a tab bar at the bottom or running on iPhone X and textView is at the bottom.
        let bottomLayoutGuide: CGFloat = isScrollableTextView ? 0 : rootController.view.directionalLayoutMargins.bottom

        //  Move positive = textField is hidden.
        //  Move negative = textField is showing.
        //  Calculating move position.
        var moveUp: CGFloat

        do {
            let visibleHeight: CGFloat = window.frame.height - kbSize.height

            let topMovement: CGFloat = textFieldViewRectInRootSuperview.minY - topLayoutGuide
            let bottomMovement: CGFloat = textFieldViewRectInWindow.maxY - visibleHeight + bottomLayoutGuide
            moveUp = min(topMovement, bottomMovement)
        }

        showLog("Need to move: \(moveUp), will be moving \(moveUp < 0 ? "down" : "up")")

        var superScrollView: UIScrollView?
        var superView = textFieldView.superviewOfClassType(UIScrollView.self) as? UIScrollView

        // Getting UIScrollView whose scrolling is enabled.    //  (Bug ID: #285)
        while let view = superView {
            if view.isScrollEnabled, !view.shouldIgnoreScrollingAdjustment {
                superScrollView = view
                break
            } else {
                //  Getting it's superScrollView.   //  (Enhancement ID: #21, #24)
                superView = view.superviewOfClassType(UIScrollView.self) as? UIScrollView
            }
        }

        // If there was a lastScrollView.    //  (Bug ID: #34)
        if let lastScrollView = lastScrollView {
            // If we can't find current superScrollView, then setting lastScrollView to it's original form.
            if superScrollView == nil {
                if lastScrollView.contentInset != startingContentInsets {
                    showLog("Restoring contentInset to: \(startingContentInsets)")
                    UIView.animate(withDuration: animationDuration, delay: 0, options: animationCurve, animations: { () in

                        lastScrollView.contentInset = self.startingContentInsets
                        lastScrollView.scrollIndicatorInsets = self.startingScrollIndicatorInsets
                    })
                }

                if lastScrollView.shouldRestoreScrollViewContentOffset, !lastScrollView.contentOffset.equalTo(startingContentOffset) {
                    showLog("Restoring contentOffset to: \(startingContentOffset)")

                    let animatedContentOffset = textFieldView.superviewOfClassType(UIStackView.self, belowView: lastScrollView) != nil //  (Bug ID: #1365, #1508, #1541)

                    if animatedContentOffset {
                        lastScrollView.setContentOffset(startingContentOffset, animated: UIView.areAnimationsEnabled)
                    } else {
                        lastScrollView.contentOffset = startingContentOffset
                    }
                }

                startingContentInsets = .zero
                startingScrollIndicatorInsets = .zero
                startingContentOffset = .zero
                self.lastScrollView = nil
            } else if superScrollView != lastScrollView { // If both scrollView's are different, then reset lastScrollView to it's original frame and setting current scrollView as last scrollView.
                if lastScrollView.contentInset != startingContentInsets {
                    showLog("Restoring contentInset to: \(startingContentInsets)")
                    UIView.animate(withDuration: animationDuration, delay: 0, options: animationCurve, animations: { () in

                        lastScrollView.contentInset = self.startingContentInsets
                        lastScrollView.scrollIndicatorInsets = self.startingScrollIndicatorInsets
                    })
                }

                if lastScrollView.shouldRestoreScrollViewContentOffset, !lastScrollView.contentOffset.equalTo(startingContentOffset) {
                    showLog("Restoring contentOffset to: \(startingContentOffset)")

                    let animatedContentOffset = textFieldView.superviewOfClassType(UIStackView.self, belowView: lastScrollView) != nil //  (Bug ID: #1365, #1508, #1541)

                    if animatedContentOffset {
                        lastScrollView.setContentOffset(startingContentOffset, animated: UIView.areAnimationsEnabled)
                    } else {
                        lastScrollView.contentOffset = startingContentOffset
                    }
                }

                self.lastScrollView = superScrollView
                if let scrollView = superScrollView {
                    startingContentInsets = scrollView.contentInset
                    startingContentOffset = scrollView.contentOffset

                    #if swift(>=5.1)
                        if #available(iOS 11.1, *) {
                            startingScrollIndicatorInsets = scrollView.verticalScrollIndicatorInsets
                        } else {
                            startingScrollIndicatorInsets = scrollView.scrollIndicatorInsets
                        }
                    #else
                        startingScrollIndicatorInsets = scrollView.scrollIndicatorInsets
                    #endif
                }

                showLog("Saving ScrollView New contentInset: \(startingContentInsets) and contentOffset: \(startingContentOffset)")
            }
            // Else the case where superScrollView == lastScrollView means we are on same scrollView after switching to different textField. So doing nothing, going ahead
        } else if let unwrappedSuperScrollView = superScrollView { // If there was no lastScrollView and we found a current scrollView. then setting it as lastScrollView.
            lastScrollView = unwrappedSuperScrollView
            startingContentInsets = unwrappedSuperScrollView.contentInset
            startingContentOffset = unwrappedSuperScrollView.contentOffset

            #if swift(>=5.1)
                if #available(iOS 11.1, *) {
                    startingScrollIndicatorInsets = unwrappedSuperScrollView.verticalScrollIndicatorInsets
                } else {
                    startingScrollIndicatorInsets = unwrappedSuperScrollView.scrollIndicatorInsets
                }
            #else
                startingScrollIndicatorInsets = unwrappedSuperScrollView.scrollIndicatorInsets
            #endif

            showLog("Saving ScrollView contentInset: \(startingContentInsets) and contentOffset: \(startingContentOffset)")
        }

        //  Special case for ScrollView.
        //  If we found lastScrollView then setting it's contentOffset to show textField.
        if let lastScrollView = lastScrollView {
            // Saving
            var lastView = textFieldView
            var superScrollView = self.lastScrollView

            while let scrollView = superScrollView {
                var shouldContinue = false

                if moveUp > 0 {
                    shouldContinue = moveUp > (-scrollView.contentOffset.y - scrollView.contentInset.top)

                } else if let tableView = scrollView.superviewOfClassType(UITableView.self) as? UITableView {
                    // Special treatment for UITableView due to their cell reusing logic
                    shouldContinue = scrollView.contentOffset.y > 0

                    if shouldContinue, let tableCell = textFieldView.superviewOfClassType(UITableViewCell.self) as? UITableViewCell, let indexPath = tableView.indexPath(for: tableCell), let previousIndexPath = tableView.previousIndexPath(of: indexPath) {
                        let previousCellRect = tableView.rectForRow(at: previousIndexPath)
                        if !previousCellRect.isEmpty {
                            let previousCellRectInRootSuperview = tableView.convert(previousCellRect, to: rootController.view.superview)

                            moveUp = min(0, previousCellRectInRootSuperview.maxY - topLayoutGuide)
                        }
                    }
                } else if let collectionView = scrollView.superviewOfClassType(UICollectionView.self) as? UICollectionView {
                    // Special treatment for UITableView due to their cell reusing logic
                    shouldContinue = scrollView.contentOffset.y > 0

                    if shouldContinue, let collectionCell = textFieldView.superviewOfClassType(UICollectionViewCell.self) as? UICollectionViewCell, let indexPath = collectionView.indexPath(for: collectionCell), let previousIndexPath = collectionView.previousIndexPath(of: indexPath), let attributes = collectionView.layoutAttributesForItem(at: previousIndexPath) {
                        let previousCellRect = attributes.frame
                        if !previousCellRect.isEmpty {
                            let previousCellRectInRootSuperview = collectionView.convert(previousCellRect, to: rootController.view.superview)

                            moveUp = min(0, previousCellRectInRootSuperview.maxY - topLayoutGuide)
                        }
                    }
                } else {
                    shouldContinue = textFieldViewRectInRootSuperview.minY < topLayoutGuide

                    if shouldContinue {
                        moveUp = min(0, textFieldViewRectInRootSuperview.minY - topLayoutGuide)
                    }
                }

                // Looping in upper hierarchy until we don't found any scrollView in it's upper hirarchy till UIWindow object.
                if shouldContinue {
                    var tempScrollView = scrollView.superviewOfClassType(UIScrollView.self) as? UIScrollView
                    var nextScrollView: UIScrollView?
                    while let view = tempScrollView {
                        if view.isScrollEnabled, !view.shouldIgnoreScrollingAdjustment {
                            nextScrollView = view
                            break
                        } else {
                            tempScrollView = view.superviewOfClassType(UIScrollView.self) as? UIScrollView
                        }
                    }

                    // Getting lastViewRect.
                    if let lastViewRect = lastView.superview?.convert(lastView.frame, to: scrollView) {
                        // Calculating the expected Y offset from move and scrollView's contentOffset.
                        var shouldOffsetY = scrollView.contentOffset.y - min(scrollView.contentOffset.y, -moveUp)

                        // Rearranging the expected Y offset according to the view.
                        shouldOffsetY = min(shouldOffsetY, lastViewRect.minY)

                        // [_textFieldView isKindOfClass:[UITextView class]] If is a UITextView type
                        // nextScrollView == nil    If processing scrollView is last scrollView in upper hierarchy (there is no other scrollView upper hierrchy.)
                        // [_textFieldView isKindOfClass:[UITextView class]] If is a UITextView type
                        // shouldOffsetY >= 0     shouldOffsetY must be greater than in order to keep distance from navigationBar (Bug ID: #92)
                        if isScrollableTextView,
                           nextScrollView == nil,
                           shouldOffsetY >= 0
                        {
                            // Converting Rectangle according to window bounds.
                            if let currentTextFieldViewRect = textFieldView.superview?.convert(textFieldView.frame, to: window) {
                                // Calculating expected fix distance which needs to be managed from navigation bar
                                let expectedFixDistance: CGFloat = currentTextFieldViewRect.minY - topLayoutGuide

                                // Now if expectedOffsetY (superScrollView.contentOffset.y + expectedFixDistance) is lower than current shouldOffsetY, which means we're in a position where navigationBar up and hide, then reducing shouldOffsetY with expectedOffsetY (superScrollView.contentOffset.y + expectedFixDistance)
                                shouldOffsetY = min(shouldOffsetY, scrollView.contentOffset.y + expectedFixDistance)

                                // Setting move to 0 because now we don't want to move any view anymore (All will be managed by our contentInset logic.
                                moveUp = 0
                            } else {
                                // Subtracting the Y offset from the move variable, because we are going to change scrollView's contentOffset.y to shouldOffsetY.
                                moveUp -= (shouldOffsetY - scrollView.contentOffset.y)
                            }
                        } else {
                            // Subtracting the Y offset from the move variable, because we are going to change scrollView's contentOffset.y to shouldOffsetY.
                            moveUp -= (shouldOffsetY - scrollView.contentOffset.y)
                        }

                        let newContentOffset = CGPoint(x: scrollView.contentOffset.x, y: shouldOffsetY)

                        if scrollView.contentOffset.equalTo(newContentOffset) == false {
                            showLog("old contentOffset: \(scrollView.contentOffset) new contentOffset: \(newContentOffset)")
                            showLog("Remaining Move: \(moveUp)")

                            // Getting problem while using `setContentOffset:animated:`, So I used animation API.
                            UIView.animate(withDuration: animationDuration, delay: 0, options: animationCurve, animations: { () in

                                let animatedContentOffset = textFieldView.superviewOfClassType(UIStackView.self, belowView: scrollView) != nil //  (Bug ID: #1365, #1508, #1541)

                                if animatedContentOffset {
                                    scrollView.setContentOffset(newContentOffset, animated: UIView.areAnimationsEnabled)
                                } else {
                                    scrollView.contentOffset = newContentOffset
                                }
                            }, completion: { _ in

                                if scrollView is UITableView || scrollView is UICollectionView {
                                    // This will update the next/previous states
                                    self.addToolbarIfRequired()
                                }
                            })
                        }
                    }

                    // Getting next lastView & superScrollView.
                    lastView = scrollView
                    superScrollView = nextScrollView
                } else {
                    moveUp = 0
                    break
                }
            }

            // Updating contentInset
            if let lastScrollViewRect = lastScrollView.superview?.convert(lastScrollView.frame, to: window),
               lastScrollView.shouldIgnoreContentInsetAdjustment == false
            {
                var bottomInset: CGFloat = (kbSize.height) - (window.frame.height - lastScrollViewRect.maxY)
                var bottomScrollIndicatorInset = bottomInset - newKeyboardDistanceFromTextField - topViewBeginSafeAreaInsets.bottom

                // Update the insets so that the scroll vew doesn't shift incorrectly when the offset is near the bottom of the scroll view.
                bottomInset = max(startingContentInsets.bottom, bottomInset)
                bottomScrollIndicatorInset = max(startingScrollIndicatorInsets.bottom, bottomScrollIndicatorInset)

                bottomInset -= lastScrollView.safeAreaInsets.bottom
                bottomScrollIndicatorInset -= lastScrollView.safeAreaInsets.bottom

                var movedInsets = lastScrollView.contentInset
                movedInsets.bottom = bottomInset

                if lastScrollView.contentInset != movedInsets {
                    showLog("old ContentInset: \(lastScrollView.contentInset) new ContentInset: \(movedInsets)")

                    UIView.animate(withDuration: animationDuration, delay: 0, options: animationCurve, animations: { () in
                        lastScrollView.contentInset = movedInsets

                        var newScrollIndicatorInset: UIEdgeInsets

                        #if swift(>=5.1)
                            if #available(iOS 11.1, *) {
                                newScrollIndicatorInset = lastScrollView.verticalScrollIndicatorInsets
                            } else {
                                newScrollIndicatorInset = lastScrollView.scrollIndicatorInsets
                            }
                        #else
                            newScrollIndicatorInset = lastScrollView.scrollIndicatorInsets
                        #endif

                        newScrollIndicatorInset.bottom = bottomScrollIndicatorInset
                        lastScrollView.scrollIndicatorInsets = newScrollIndicatorInset
                    })
                }
            }
        }
        // Going ahead. No else if.

        // Special case for UITextView(Readjusting textView.contentInset when textView hight is too big to fit on screen)
        // _lastScrollView       If not having inside any scrollView, (now contentInset manages the full screen textView.
        // [_textFieldView isKindOfClass:[UITextView class]] If is a UITextView type
        if isScrollableTextView, let textView = textFieldView as? UIScrollView {
            let keyboardYPosition = window.frame.height - originalKbSize.height
            var rootSuperViewFrameInWindow = window.frame
            if let rootSuperview = rootController.view.superview {
                rootSuperViewFrameInWindow = rootSuperview.convert(rootSuperview.bounds, to: window)
            }

            let keyboardOverlapping = rootSuperViewFrameInWindow.maxY - keyboardYPosition

            let textViewHeight = min(textView.frame.height, rootSuperViewFrameInWindow.height - topLayoutGuide - keyboardOverlapping)

            if textView.frame.size.height - textView.contentInset.bottom > textViewHeight {
                // _isTextViewContentInsetChanged,  If frame is not change by library in past, then saving user textView properties  (Bug ID: #92)
                if !isTextViewContentInsetChanged {
                    startingTextViewContentInsets = textView.contentInset

                    #if swift(>=5.1)
                        if #available(iOS 11.1, *) {
                            self.startingTextViewScrollIndicatorInsets = textView.verticalScrollIndicatorInsets
                        } else {
                            startingTextViewScrollIndicatorInsets = textView.scrollIndicatorInsets
                        }
                    #else
                        startingTextViewScrollIndicatorInsets = textView.scrollIndicatorInsets
                    #endif
                }

                isTextViewContentInsetChanged = true

                var newContentInset = textView.contentInset
                newContentInset.bottom = textView.frame.size.height - textViewHeight
                newContentInset.bottom -= textView.safeAreaInsets.bottom

                if textView.contentInset != newContentInset {
                    showLog("\(textFieldView) Old UITextView.contentInset: \(textView.contentInset) New UITextView.contentInset: \(newContentInset)")

                    UIView.animate(withDuration: animationDuration, delay: 0, options: animationCurve, animations: { () in

                        textView.contentInset = newContentInset
                        textView.scrollIndicatorInsets = newContentInset
                    }, completion: { _ in })
                }
            }
        }

        // +Positive or zero.
        if moveUp >= 0 {
            rootViewOrigin.y = max(rootViewOrigin.y - moveUp, min(0, -originalKbSize.height))

            if rootController.view.frame.origin.equalTo(rootViewOrigin) == false {
                showLog("Moving Upward")

                UIView.animate(withDuration: animationDuration, delay: 0, options: animationCurve, animations: { () in

                    var rect = rootController.view.frame
                    rect.origin = rootViewOrigin
                    rootController.view.frame = rect

                    // Animating content if needed (Bug ID: #204)
                    if self.layoutIfNeededOnUpdate {
                        // Animating content (Bug ID: #160)
                        rootController.view.setNeedsLayout()
                        rootController.view.layoutIfNeeded()
                    }

                    self.showLog("Set \(rootController) origin to: \(rootViewOrigin)")
                })
            }

            movedDistance = (topViewBeginOrigin.y - rootViewOrigin.y)
        } else { //  -Negative
            let disturbDistance: CGFloat = rootViewOrigin.y - topViewBeginOrigin.y

            //  disturbDistance Negative = frame disturbed.
            //  disturbDistance positive = frame not disturbed.
            if disturbDistance <= 0 {
                rootViewOrigin.y -= max(moveUp, disturbDistance)

                if rootController.view.frame.origin.equalTo(rootViewOrigin) == false {
                    showLog("Moving Downward")
                    //  Setting adjusted rootViewRect
                    //  Setting adjusted rootViewRect

                    UIView.animate(withDuration: animationDuration, delay: 0, options: animationCurve, animations: { () in

                        var rect = rootController.view.frame
                        rect.origin = rootViewOrigin
                        rootController.view.frame = rect

                        // Animating content if needed (Bug ID: #204)
                        if self.layoutIfNeededOnUpdate {
                            // Animating content (Bug ID: #160)
                            rootController.view.setNeedsLayout()
                            rootController.view.layoutIfNeeded()
                        }

                        self.showLog("Set \(rootController) origin to: \(rootViewOrigin)")
                    })
                }

                movedDistance = (topViewBeginOrigin.y - rootViewOrigin.y)
            }
        }

        let elapsedTime = CACurrentMediaTime() - startTime
        showLog("<<<<< \(#function) ended: \(elapsedTime) seconds <<<<<", indentation: -1)
    }

    // swiftlint:enable function_body_length

    internal func restorePosition() {
        //  Setting rootViewController frame to it's original position. //  (Bug ID: #18)
        guard topViewBeginOrigin.equalTo(IQKeyboardManager.kIQCGPointInvalid) == false, let rootViewController = rootViewController else {
            return
        }

        if rootViewController.view.frame.origin.equalTo(topViewBeginOrigin) == false {
            // Used UIViewAnimationOptionBeginFromCurrentState to minimize strange animations.
            UIView.animate(withDuration: animationDuration, delay: 0, options: animationCurve, animations: { () in

                // Setting it's new frame
                var rect = rootViewController.view.frame
                rect.origin = self.topViewBeginOrigin
                rootViewController.view.frame = rect

                // Animating content if needed (Bug ID: #204)
                if self.layoutIfNeededOnUpdate {
                    // Animating content (Bug ID: #160)
                    rootViewController.view.setNeedsLayout()
                    rootViewController.view.layoutIfNeeded()
                }

                self.showLog("Restoring \(rootViewController) origin to: \(self.topViewBeginOrigin)")
            })
        }

        movedDistance = 0

        if rootViewController.navigationController?.interactivePopGestureRecognizer?.state == .began {
            rootViewControllerWhilePopGestureRecognizerActive = rootViewController
            topViewBeginOriginWhilePopGestureRecognizerActive = topViewBeginOrigin
        }

        self.rootViewController = nil
    }
}
