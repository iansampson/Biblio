//
//  AsyncStream.swift
//  
//
//  Created by Ian Sampson on 2021-11-19.
//

// TODO: Consider naming TaskGroupStream or TaskStream
struct TaskStream<Element>: AsyncSequence {
    typealias Failure = Error
    typealias Base = AsyncThrowingStream<Element, Failure>
    typealias AsyncIterator = Base.AsyncIterator
    private let base: Base
    
    func makeAsyncIterator() -> AsyncIterator {
        base.makeAsyncIterator()
    }
    
    init(_ body: @escaping (inout ThrowingTaskGroup<Element, Failure>) async throws -> ()) {
        base = .init { (continuation: Base.Continuation) in
            Task {
                do {
                    try await withThrowingTaskGroup(of: Element.self) { taskGroup in
                        try await body(&taskGroup)
                        for try await result in taskGroup {
                            continuation.yield(result)
                        }
                    }
                    continuation.finish(throwing: nil)
                } catch {
                    continuation.finish(throwing: error)
                }
            }
        }
    }
    
    init<S>(_ elements: S, priority: TaskPriority? = nil, _ operation: @escaping @Sendable (S.Element) async throws -> Element) where S: Sequence {
        self.init { taskGroup in
            for element in elements {
                taskGroup.addTask(priority: priority) {
                    try await operation(element)
                }
            }
        }
    }
    
    // TODO: Handle errors
    init<S, T>(_ elements: S, _ transform: @escaping (S.Element) -> T) where S: Sequence, T: AsyncSequence, T.Element == Element
    {
        base = .init { (continuation: Base.Continuation) in
            Task {
                await withThrowingTaskGroup(of: Void.self) { taskGroup in
                    for element in elements {
                        taskGroup.addTask {
                            let stream = transform(element)
                            for try await result in stream {
                                continuation.yield(result)
                            }
                            return ()
                        }
                    }
                }
                continuation.finish(throwing: nil)
            }
        }
    }
    
    /*init(_ body: @escaping (inout ThrowingTaskGroup<Element, Failure>) async throws -> ()) {
        base = .init { (continuation: Base.Continuation) in
            Task {
                do {
                    try await withThrowingTaskGroup(of: Element.self) { taskGroup in
                        try await body(&taskGroup)
                        
                        
                        for try await result in taskGroup {
                            continuation.yield(result)
                        }
                    }
                    continuation.finish(throwing: nil)
                } catch {
                    continuation.finish(throwing: error)
                }
            }
        }
    }*/
    
    // if you have several async sequences
    //
    
    /*init<S, T>(_ elements: S, priority: TaskPriority? = nil, _ operation: @escaping @Sendable (S.Element) async throws -> T) where S: Sequence, T: AsyncSequence, T.Element == Element {
        base = .init { (continuation: Base.Continuation) in
            Task {
                do {
                    try await withThrowingTaskGroup(of: T) { taskGroup in
                        
                    }
                    /*try await withThrowingTaskGroup(of: Element.self) { taskGroup in
                        try await body(&taskGroup)
                        for try await result in taskGroup {
                            continuation.yield(result)
                        }
                    }*/
                    continuation.finish(throwing: nil)
                } catch {
                    continuation.finish(throwing: error)
                }
            }
        }*/
        
        /*self.init { taskGroup in
            for element in elements {
                taskGroup.addTask(priority: priority) {
                    
                    // try await operation(element)
                }
            }
        }*/
    //}
}

// for sequence in urls.map { ... } {
//
// }
