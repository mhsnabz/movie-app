//
//  Reduce.swift
//  RxSwift
//
//  Created by Krunoslav Zaher on 4/1/15.
//  Copyright © 2015 Krunoslav Zaher. All rights reserved.
//

public extension ObservableType {
    /**
     Applies an `accumulator` function over an observable sequence, returning the result of the aggregation as a single element in the result sequence. The specified `seed` value is used as the initial accumulator value.

     For aggregation behavior with incremental intermediate results, see `scan`.

     - seealso: [reduce operator on reactivex.io](http://reactivex.io/documentation/operators/reduce.html)

     - parameter seed: The initial accumulator value.
     - parameter accumulator: A accumulator function to be invoked on each element.
     - parameter mapResult: A function to transform the final accumulator value into the result value.
     - returns: An observable sequence containing a single element with the final accumulator value.
     */
    func reduce<A, Result>(_ seed: A, accumulator: @escaping (A, Element) throws -> A, mapResult: @escaping (A) throws -> Result)
        -> Observable<Result>
    {
        Reduce(source: asObservable(), seed: seed, accumulator: accumulator, mapResult: mapResult)
    }

    /**
     Applies an `accumulator` function over an observable sequence, returning the result of the aggregation as a single element in the result sequence. The specified `seed` value is used as the initial accumulator value.

     For aggregation behavior with incremental intermediate results, see `scan`.

     - seealso: [reduce operator on reactivex.io](http://reactivex.io/documentation/operators/reduce.html)

     - parameter seed: The initial accumulator value.
     - parameter accumulator: A accumulator function to be invoked on each element.
     - returns: An observable sequence containing a single element with the final accumulator value.
     */
    func reduce<A>(_ seed: A, accumulator: @escaping (A, Element) throws -> A)
        -> Observable<A>
    {
        Reduce(source: asObservable(), seed: seed, accumulator: accumulator, mapResult: { $0 })
    }
}

private final class ReduceSink<SourceType, AccumulateType, Observer: ObserverType>: Sink<Observer>, ObserverType {
    typealias ResultType = Observer.Element
    typealias Parent = Reduce<SourceType, AccumulateType, ResultType>

    private let parent: Parent
    private var accumulation: AccumulateType

    init(parent: Parent, observer: Observer, cancel: Cancelable) {
        self.parent = parent
        accumulation = parent.seed

        super.init(observer: observer, cancel: cancel)
    }

    func on(_ event: Event<SourceType>) {
        switch event {
        case let .next(value):
            do {
                accumulation = try parent.accumulator(accumulation, value)
            } catch let e {
                self.forwardOn(.error(e))
                self.dispose()
            }
        case let .error(e):
            forwardOn(.error(e))
            dispose()
        case .completed:
            do {
                let result = try parent.mapResult(accumulation)
                forwardOn(.next(result))
                forwardOn(.completed)
                dispose()
            } catch let e {
                self.forwardOn(.error(e))
                self.dispose()
            }
        }
    }
}

private final class Reduce<SourceType, AccumulateType, ResultType>: Producer<ResultType> {
    typealias AccumulatorType = (AccumulateType, SourceType) throws -> AccumulateType
    typealias ResultSelectorType = (AccumulateType) throws -> ResultType

    private let source: Observable<SourceType>
    fileprivate let seed: AccumulateType
    fileprivate let accumulator: AccumulatorType
    fileprivate let mapResult: ResultSelectorType

    init(source: Observable<SourceType>, seed: AccumulateType, accumulator: @escaping AccumulatorType, mapResult: @escaping ResultSelectorType) {
        self.source = source
        self.seed = seed
        self.accumulator = accumulator
        self.mapResult = mapResult
    }

    override func run<Observer: ObserverType>(_ observer: Observer, cancel: Cancelable) -> (sink: Disposable, subscription: Disposable) where Observer.Element == ResultType {
        let sink = ReduceSink(parent: self, observer: observer, cancel: cancel)
        let subscription = source.subscribe(sink)
        return (sink: sink, subscription: subscription)
    }
}
