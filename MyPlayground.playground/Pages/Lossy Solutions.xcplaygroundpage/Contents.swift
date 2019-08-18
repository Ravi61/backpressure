//: [ZipExample](@previous)

import Foundation
import RxSwift
import RxCocoa

/// We'll create a random Int emitting infinite Observable and
/// apply out lossy operators on it
let X = Observable<Int>.create { observer -> Disposable in
    while true {
        let randomInt = UInt32.random(in: 1...3)
        print("Waiting for \(randomInt) second(s) to produce \(randomInt)")
        sleep(randomInt)
        observer.onNext(Int(randomInt))
    }
    
    return Disposables.create()
}.share()

_ = X.subscribeOn(SerialDispatchQueueScheduler(qos: .background))
    .debounce(.seconds(2), scheduler: MainScheduler.instance)
    .subscribe(onNext: { value in
        print("Debounced \(value)")
    })

_ = X.throttle(.seconds(2), scheduler: MainScheduler.instance)
    .subscribe(onNext: { value in
        print("Throttled \(value)")
    })

let aScheduler = SerialDispatchQueueScheduler(internalSerialQueueName: "backgroundQueue1")
let A = Observable.repeatElement("A", scheduler: aScheduler).throttle(.seconds(2), scheduler: aScheduler)

_ = A.sample(X)
    .subscribe(onNext: { value in
        print("Sampled \(value)")
    })

//: [Next](@next)
