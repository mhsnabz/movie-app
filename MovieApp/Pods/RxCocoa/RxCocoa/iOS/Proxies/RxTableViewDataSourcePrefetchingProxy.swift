//
//  RxTableViewDataSourcePrefetchingProxy.swift
//  RxCocoa
//
//  Created by Rowan Livingstone on 2/15/18.
//  Copyright © 2018 Krunoslav Zaher. All rights reserved.
//

#if os(iOS) || os(tvOS)

    import RxSwift
    import UIKit

    @available(iOS 10.0, tvOS 10.0, *)
    extension UITableView: HasPrefetchDataSource {
        public typealias PrefetchDataSource = UITableViewDataSourcePrefetching
    }

    @available(iOS 10.0, tvOS 10.0, *)
    private let tableViewPrefetchDataSourceNotSet = TableViewPrefetchDataSourceNotSet()

    @available(iOS 10.0, tvOS 10.0, *)
    private final class TableViewPrefetchDataSourceNotSet:
        NSObject,
        UITableViewDataSourcePrefetching
    {
        func tableView(_: UITableView, prefetchRowsAt _: [IndexPath]) {}
    }

    @available(iOS 10.0, tvOS 10.0, *)
    open class RxTableViewDataSourcePrefetchingProxy:
        DelegateProxy<UITableView, UITableViewDataSourcePrefetching>,
        DelegateProxyType
    {
        /// Typed parent object.
        public private(set) weak var tableView: UITableView?

        /// - parameter tableView: Parent object for delegate proxy.
        public init(tableView: ParentObject) {
            self.tableView = tableView
            super.init(parentObject: tableView, delegateProxy: RxTableViewDataSourcePrefetchingProxy.self)
        }

        // Register known implementations
        public static func registerKnownImplementations() {
            register { RxTableViewDataSourcePrefetchingProxy(tableView: $0) }
        }

        private var _prefetchRowsPublishSubject: PublishSubject<[IndexPath]>?

        /// Optimized version used for observing prefetch rows callbacks.
        var prefetchRowsPublishSubject: PublishSubject<[IndexPath]> {
            if let subject = _prefetchRowsPublishSubject {
                return subject
            }

            let subject = PublishSubject<[IndexPath]>()
            _prefetchRowsPublishSubject = subject

            return subject
        }

        private weak var _requiredMethodsPrefetchDataSource: UITableViewDataSourcePrefetching? = tableViewPrefetchDataSourceNotSet

        /// For more information take a look at `DelegateProxyType`.
        override open func setForwardToDelegate(_ forwardToDelegate: UITableViewDataSourcePrefetching?, retainDelegate: Bool) {
            _requiredMethodsPrefetchDataSource = forwardToDelegate ?? tableViewPrefetchDataSourceNotSet
            super.setForwardToDelegate(forwardToDelegate, retainDelegate: retainDelegate)
        }

        deinit {
            if let subject = _prefetchRowsPublishSubject {
                subject.on(.completed)
            }
        }
    }

    @available(iOS 10.0, tvOS 10.0, *)
    extension RxTableViewDataSourcePrefetchingProxy: UITableViewDataSourcePrefetching {
        /// Required delegate method implementation.
        public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
            if let subject = _prefetchRowsPublishSubject {
                subject.on(.next(indexPaths))
            }

            (_requiredMethodsPrefetchDataSource ?? tableViewPrefetchDataSourceNotSet).tableView(tableView, prefetchRowsAt: indexPaths)
        }
    }

#endif
