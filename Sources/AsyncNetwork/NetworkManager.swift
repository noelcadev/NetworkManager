import Foundation

public final class AsyncNetwork {
    
    ///  Create a GET network request
    /// - Parameters:
    ///   - url: URL used in http request
    ///   - builder: A function that convert the result Data response to your expected data
    ///   - session:  Optional. URLSession with custom configuration
    /// - Returns: Result with succes or failure data
    @discardableResult public static func getData<Received>(
        url: URL,
        builder: @escaping (Data) -> Received?,
        session: URLSession = .shared
    ) async -> Result<Received, NetworkError> {
        do {
            let (data, response) = try await session.data(from: url)
            guard let response = response as? HTTPURLResponse else {
                return .failure(.noHTTP)
            }
            if response.statusCode == 200 {
                if let result = builder(data) {
                    return .success(result)
                } else {
                    return .failure(.notExpectedData)
                }
            } else {
                return .failure(.statusCode(response.statusCode))
            }
        } catch {
            return .failure(.general(error))
        }
    }
    
    ///  Create a GET network request that throws error for no valid data responses
    /// - Parameters:
    ///   - url: URL used in http request
    ///   - builder: A function that convert the result Data response to your expected data
    ///   - session:  Optional. URLSession with custom configuration
    /// - Returns: Result with succes or failure data
    @discardableResult public static func getData<Received>(
        url: URL,
        builder: @escaping (Data) throws -> Received,
        session: URLSession = .shared
    ) async -> Result<Received, NetworkError> {
        do {
            let (data, response) = try await session.data(from: url)
            guard let response = response as? HTTPURLResponse else {
                return .failure(.noHTTP)
            }
            if response.statusCode == 200 {
                do {
                    let result = try builder(data)
                    return .success(result)
                } catch {
                    return .failure(.notExpectedData)
                }
            } else {
                return .failure(.statusCode(response.statusCode))
            }
        } catch {
            return .failure(.general(error))
        }
    }
    
    ///  Create a network request with a custom URLRequest
    /// - Parameters:
    ///   - request: A custom URLRequest
    ///   - builder: A function that convert the result Data response to your expected data
    ///   - session:  Optional. URLSession with custom configuration
    /// - Returns: Result with succes or failure data
    @discardableResult public static func data<Received>(
        request: URLRequest,
        builder: @escaping (Data) -> Received?,
        session: URLSession = .shared
    ) async -> Result<Received, NetworkError> {
        do {
            let (data, response) = try await session.data(for: request)
            guard let response = response as? HTTPURLResponse else {
                return .failure(.noHTTP)
            }
            if response.statusCode == 200 {
                if let result = builder(data) {
                    return .success(result)
                } else {
                    return .failure(.notExpectedData)
                }
            } else {
                return .failure(.statusCode(response.statusCode))
            }
        } catch {
            return .failure(.general(error))
        }
    }
    
    ///  Create a network request with a custom URLRequest that throws error for no valid data responses
    /// - Parameters:
    ///   - request: A custom URLRequest
    ///   - builder: A function that convert the result Data response to your expected data
    ///   - session:  Optional. URLSession with custom configuration
    /// - Returns: Result with succes or failure data
    @discardableResult public static func data<Received>(
        request: URLRequest,
        builder: @escaping (Data) throws -> Received,
        session: URLSession = .shared
    ) async -> Result<Received, NetworkError> {
        do {
            let (data, response) = try await session.data(for: request)
            guard let response = response as? HTTPURLResponse else {
                return .failure(.noHTTP)
            }
            if response.statusCode == 200 {
                do {
                    let result = try builder(data)
                    return .success(result)
                } catch {
                    return .failure(.notExpectedData)
                }
            } else {
                return .failure(.statusCode(response.statusCode))
            }
        } catch {
            return .failure(.general(error))
        }
    }
}
