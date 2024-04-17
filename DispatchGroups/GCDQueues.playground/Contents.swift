import UIKit

/// Global queues are concurrent queues provided by the system that allow multiple tasks to be executed in parallel. When you dispatch a task to a global queue, you can choose whether to dispatch it synchronously or asynchronously:

let startTime = CFAbsoluteTimeGetCurrent()

// First 🥳 task will be completed and then execution of 😈 is started and completed.
DispatchQueue.global().sync {
    for i in 0 ... 10 {
        print("🥳", i)
    }
}

DispatchQueue.global().sync {
    for i in 0 ... 10 {
        print("😈", i)
    }
}

print("Main Thread Block Time: \(CFAbsoluteTimeGetCurrent() - startTime)")

// Both the tasks 🥳 and 😈 are executed concurrently as global is a concurrent queue and the task submitted to them are async
DispatchQueue.global().async {
    for i in 0 ... 10 {
        print("🥳", i)
    }
}

DispatchQueue.global().async {
    for i in 0 ... 10 {
        print("😈", i)
    }
}

/// In concurrent computing, a deadlock is a state in which each member of a group is waiting for another member, including itself, to take action

// Outer block is waiting for the Inner block to complete and Inner block won’t start before Outer block finishes
//DispatchQueue.main.sync {
//    DispatchQueue.main.sync {
//        
//    }
//}

// As the queue is serial the
//let queue = DispatchQueue(label: "label"/*, attributes: .concurrent*/)
//queue.async {
//    queue.sync {
//        
//    }
//}

// Serial Queue with synchronous execution
let serialQueue  = DispatchQueue(label: "MySerialQueue")
print("Task on the outsider queue  has started ",Thread.current)
serialQueue.sync {
    print("Task on queue one is started")
    print(Thread.current)
    for _ in 0...1_00_000_00 {
        
    }
    print("Task on queue one has finished")
}
print("Outsider task doing something")
print(Thread.current)
print("Task on the outsider queue  has finished")
serialQueue.sync {
    print("Task on queue two is started")
    print(Thread.current)
    print("Task on queue two is finished")
}

// Serial Queue with asynchronous execution

// MARK: - Dispatch Group

func getData() {
    let urls = [
        "https://api.google.com/1",
        "https://api.google.com/2",
        "https://api.google.com/3"
    ]
    
    let group = DispatchGroup()
    
    for urlString in urls {
        guard let url = URL(string: urlString) else {
            continue
        }
        
        group.enter()
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            defer {
                group.leave()
            }
            
            guard let data = data else {
                return
            }
            print(data)
        }
        
        task.resume()
    }
    
    group.notify(queue: .main, execute: {
        // Update User Interface
    })
}
