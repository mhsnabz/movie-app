//
//  BaseMoyaProvider.swift
//  MovieApp
//
//  Created by srbrt on 9.02.2024.
//

import Foundation
import Moya

/**
    A custom subclass of `MoyaProvider` that provides additional functionality for creating network requests.

    This class extends `MoyaProvider` and overrides the initializer to customize the behavior of network requests.
    It allows for specifying custom endpoint and request closures, along with other configuration parameters.

    - Parameter Target: The target type for which requests will be made.
*/
final class BaseMoyaProvider<Target: TargetType>: MoyaProvider<Target> {
    
    /**
        Initializes a new instance of `BaseMoyaProvider`.
     
        - Parameters:
            - endpointClosure: A closure that defines how endpoints should be mapped to a `URLRequest`.
            - stubClosure: A closure that determines how requests should be stubbed for testing.
            - session: The session configuration for Alamofire, the underlying networking library.
            - plugins: An array of plugins to be applied to each request.
            - trackInflights: A boolean value indicating whether to track inflight requests.

        - Note: The `requestClosure` parameter is not used in this subclass. Instead, a default implementation is provided internally to customize the request behavior. It sets the cache policy to ignore both local and remote cache data and returns a success result containing the modified request.
    */
    public init(
        endpointClosure: @escaping EndpointClosure = MoyaProvider.defaultEndpointMapping,
        requestClosure _: @escaping RequestClosure = MoyaProvider<Target>.defaultRequestMapping,
        stubClosure: @escaping StubClosure = MoyaProvider.neverStub,
        session: Session = MoyaProvider<Target>.defaultAlamofireSession(),
        plugins: [PluginType] = [],
        trackInflights: Bool = false
    ) {
        super.init(
            endpointClosure: endpointClosure,
            requestClosure: { endpoint, closure in
                var request = try! endpoint.urlRequest() // Feel free to embed proper error handling
                request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
                closure(.success(request))
            },
            stubClosure: stubClosure,
            session: session,
            plugins: plugins,
            trackInflights: trackInflights
        )
    }
}
