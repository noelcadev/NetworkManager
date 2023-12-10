import Foundation
import OSLog

public final class AsyncNetwork {
    public static let shared = AsyncNetwork()
    public static let isReleaseLogging = false

    // MARK: Private methods

    private init() {}

    private func requestUrl(url: URL, session: URLSession) async throws -> (Data, URLResponse) {
        do {
            let (data, response) = try await session.data(from: url)
            return (data, response)
        } catch {
            throw NetworkError.general(error)
        }
    }

    private func requestData(request: URLRequest, session: URLSession) async throws -> (Data, URLResponse) {
        do {
            let (data, response) = try await session.data(for: request)
            return (data, response)
        } catch {
            throw NetworkError.general(error)
        }
    }

    private func decodeError<E: Codable>(error _: E.Type, data: Data, code: Int) async throws -> (E) {
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let res = try decoder.decode(E.self, from: data)
            return res
        } catch {
            throw NetworkError.invalidStatusCode(code)
        }
    }
    
    private func registerData(_ data: Data, isLogginData: Bool) {
        if isLogginData {
            let dataString = String(decoding: data, as: UTF8.self)
            
            #if DEBUG
            Logger.network.debug("Data response:\n \(dataString)")
            #else
            if isReleaseLogging {
                Logger.network.info("Data response:\n \(dataString)")
            }
            #endif
        }
    }

    // MARK: Public methods

    ///  Create a GET network request that throws error for no valid data responses
    /// - Parameters:
    ///   - url: URL used in http request
    ///   - session:  Optional. URLSession with custom configuration
    ///   - logData: Optional. A boolean to print data response as string
    ///   - errorType: Expected custom error type
    /// - Returns: Expected result type and HTTPURLResponse
    @discardableResult public func get<T: Codable, E: Codable>(
        url: URL,
        session: URLSession = .shared,
        logData: Bool = false,
        errorType: E.Type
    ) async throws -> (T, HTTPURLResponse) {
        let (data, response) = try await requestUrl(url: url, session: session)

        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.invalidRequest
        }

        registerData(data, isLogginData: logData)

        switch response.statusCode {
        case 200 ... 206:
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let res = try decoder.decode(T.self, from: data)
                return (res, response)
            } catch {
                throw NetworkError.invalidData(error)
            }
        default:
            let res = try await decodeError(error: errorType, data: data, code: response.statusCode)
            throw NetworkError.customError(res)
        }
    }

    ///  Create a GET network request that throws error for no valid data responses
    /// - Parameters:
    ///   - url: URL used in http request
    ///   - session:  Optional. URLSession with custom configuration
    ///   - logData: Optional. A boolean to print data response as string
    /// - Returns: Expected result type and HTTPURLResponse
    @discardableResult public func get<T: Codable>(
        url: URL,
        session: URLSession = .shared,
        logData: Bool = false
    ) async throws -> (T, HTTPURLResponse) {
        let (data, response) = try await requestUrl(url: url, session: session)

        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.invalidRequest
        }

        registerData(data, isLogginData: logData)

        switch response.statusCode {
        case 200 ... 206:
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let res = try decoder.decode(T.self, from: data)
                return (res, response)
            } catch {
                throw NetworkError.invalidData(error)
            }
        default:
            throw NetworkError.invalidStatusCode(response.statusCode)
        }
    }

    ///  Create a GET network request that throws error for no valid data responses
    /// - Parameters:
    ///   - url: URL used in http request
    ///   - session:  Optional. URLSession with custom configuration
    ///   - logData: Optional. A boolean to print data response as string
    ///   - errorType: Expected custom error type
    /// - Returns: Data and HTTPURLResponse
    @discardableResult public func get<E: Codable>(
        url: URL,
        session: URLSession = .shared,
        logData: Bool = false,
        errorType: E.Type
    ) async throws -> (Data, HTTPURLResponse) {
        let (data, response) = try await requestUrl(url: url, session: session)

        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.invalidRequest
        }

        registerData(data, isLogginData: logData)

        switch response.statusCode {
        case 200 ... 206:
            return (data, response)
        default:
            let res = try await decodeError(error: errorType, data: data, code: response.statusCode)
            throw NetworkError.customError(res)
        }
    }

    ///  Create a GET network request that throws error for no valid data responses
    /// - Parameters:
    ///   - url: URL used in http request
    ///   - session:  Optional. URLSession with custom configuration
    ///   - logData: Optional. A boolean to print data response as string
    /// - Returns: Data and HTTPURLResponse
    @discardableResult public func get(
        url: URL,
        session: URLSession = .shared,
        logData: Bool = false
    ) async throws -> (Data, HTTPURLResponse) {
        let (data, response) = try await requestUrl(url: url, session: session)

        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.invalidRequest
        }

        registerData(data, isLogginData: logData)

        switch response.statusCode {
        case 200 ... 206:
            return (data, response)
        default:
            throw NetworkError.invalidStatusCode(response.statusCode)
        }
    }

    ///  Create a network request with a custom URLRequest that throws error for no valid data responses
    /// - Parameters:
    ///   - request: A custom URLRequest
    ///   - session:  Optional. URLSession with custom configuration
    ///   - logData: Optional. A boolean to print data response as string
    ///   - errorType: Expected custom error type
    /// - Returns: Expected result type and HTTPURLResponse
    @discardableResult public func request<T: Codable, E: Codable>(
        _ request: URLRequest,
        session: URLSession = .shared,
        logData: Bool = false,
        errorType: E.Type
    ) async throws -> (T, HTTPURLResponse) {
        let (data, response) = try await requestData(request: request, session: session)

        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.invalidRequest
        }

        registerData(data, isLogginData: logData)

        switch response.statusCode {
        case 200 ... 206:
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let res = try decoder.decode(T.self, from: data)
                return (res, response)
            } catch {
                throw NetworkError.invalidData(error)
            }
        default:
            let res = try await decodeError(error: errorType, data: data, code: response.statusCode)
            throw NetworkError.customError(res)
        }
    }

    ///  Create a network request with a custom URLRequest that throws error for no valid data responses
    /// - Parameters:
    ///   - request: A custom URLRequest
    ///   - session:  Optional. URLSession with custom configuration
    ///   - logData: Optional. A boolean to print data response as string
    ///   - errorType: Expected custom error type
    /// - Returns: Expected result type and HTTPURLResponse
    @discardableResult public func request<T: Codable>(
        _ request: URLRequest,
        session: URLSession = .shared,
        logData: Bool = false
    ) async throws -> (T, HTTPURLResponse) {
        let (data, response) = try await requestData(request: request, session: session)

        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.invalidRequest
        }

        registerData(data, isLogginData: logData)

        switch response.statusCode {
        case 200 ... 206:
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let res = try decoder.decode(T.self, from: data)
                return (res, response)
            } catch {
                throw NetworkError.invalidData(error)
            }
        default:
            throw NetworkError.invalidStatusCode(response.statusCode)
        }
    }

    ///  Create a network request with a custom URLRequest that throws error for no valid data responses
    /// - Parameters:
    ///   - request: A custom URLRequest
    ///   - session:  Optional. URLSession with custom configuration
    ///   - logData: Optional. A boolean to print data response as string
    ///   - errorType: Expected custom error type
    /// - Returns: Data and HTTPURLResponse
    @discardableResult public func request<E: Codable>(
        _ request: URLRequest,
        session: URLSession = .shared,
        logData: Bool = false,
        errorType: E.Type
    ) async throws -> (Data, HTTPURLResponse) {
        let (data, response) = try await requestData(request: request, session: session)

        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.invalidRequest
        }

        registerData(data, isLogginData: logData)

        switch response.statusCode {
        case 200 ... 206:
            return (data, response)
        default:
            let res = try await decodeError(error: errorType, data: data, code: response.statusCode)
            throw NetworkError.customError(res)
        }
    }

    ///  Create a network request with a custom URLRequest that throws error for no valid data responses
    /// - Parameters:
    ///   - request: A custom URLRequest
    ///   - session:  Optional. URLSession with custom configuration
    ///   - logData: Optional. A boolean to print data response as string
    /// - Returns: Data and HTTPURLResponse
    @discardableResult public func request(
        _ request: URLRequest,
        session: URLSession = .shared,
        logData: Bool = false
    ) async throws -> (Data, HTTPURLResponse) {
        let (data, response) = try await requestData(request: request, session: session)

        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.invalidRequest
        }
        
        registerData(data, isLogginData: logData)

        switch response.statusCode {
        case 200 ... 206:
            return (data, response)
        default:
            throw NetworkError.invalidStatusCode(response.statusCode)
        }
    }
}
