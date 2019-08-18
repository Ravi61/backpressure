import UIKit
import RxSwift
import RxCocoa


let aScheduler = SerialDispatchQueueScheduler(internalSerialQueueName: "backgroundQueue1")
let A = Observable.repeatElement("A", scheduler: aScheduler).throttle(.seconds(1), scheduler: aScheduler)

let bScheduler = SerialDispatchQueueScheduler(internalSerialQueueName: "backgroundQueue2")
let B = Observable.repeatElement("B", scheduler: bScheduler).throttle(.seconds(2), scheduler: bScheduler)

_ = Observable.zip(A, B)
    .subscribe(onNext: { (valueA, valueB) in
        print("\(valueA) \(valueB)")
    })
