//: [Previous](@previous)

import Foundation
import RxSwift
import RxCocoa

let aScheduler = SerialDispatchQueueScheduler(internalSerialQueueName: "backgroundQueue1")
let A = Observable.repeatElement("A", scheduler: aScheduler)
    .throttle(.seconds(2), scheduler: aScheduler)
    .share()

/// Observing every fourth second means first 3 outputs will be clubbed
/// Notice the count as 0, it means to send all the events in the interval
/// Why don't you experiment with count and put 2 there and see if it starts losing events?
_ = A.buffer(timeSpan: .seconds(4), count: 0, scheduler: MainScheduler.instance)
    .subscribe(onNext: { value in
        print("Buffered \(value)")
    })

/// Remember how window produces Observable sequences? Using a flatmap here to flatten those
_ = A.window(timeSpan: .seconds(3), count: 0, scheduler: MainScheduler.instance)
    .do(onNext: { _ in
        print("Window contains")
    })
    .flatMap({ $0 })
    .subscribe(onNext: { value in
        print(value)
    })

//: [Next](@next)
