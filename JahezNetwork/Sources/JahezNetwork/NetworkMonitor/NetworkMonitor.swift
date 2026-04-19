//
//  NetworkMonitor.swift
//  JahezNetwork
//
//  Created by Mohamed Sadek on 19/04/2026.
//

import Network
import Combine

// MARK: Network Monitor Class for observing connection state
public final class NetworkMonitor: ObservableObject {
    // Singelton Instance
    public static let shared = NetworkMonitor()
    
    @Published public var isConnected = true
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    
    private init() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnected = path.status == .satisfied
            }
        }
        monitor.start(queue: queue)
    }
}
