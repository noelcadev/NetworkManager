import Foundation

public final class AsyncNetwork {
    public static let shared = AsyncNetwork()
    
    private init() { }

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
    
    private func decodeError<E: Codable>(error: E.Type, data: Data, code: Int) async throws -> (E) {
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let res = try decoder.decode(E.self, from: data)
            return res
        } catch {
            throw NetworkError.invalidStatusCode(code)
        }
    }
    
    ///  Create a GET network request that throws error for no valid data responses. Result and error types parameters.
    /// - Parameters:
    ///   - url: URL used in http request
    ///   - session:  Optional. URLSession with custom configuration
    ///   - logData: Optiona. A boolean to print data response as string
    ///   - resultType: Expected result type
    ///   - errorType: Expected custom error type
    /// - Returns: Expected result type and HTTPURLResponse
    @discardableResult public func getRequest<T: Codable, E: Codable>(
        url: URL,
        session: URLSession = .shared,
        logData: Bool = false,
        resultType: T.Type,
        errorType: E.Type
    ) async throws -> (T, HTTPURLResponse) {
        let (data, response) = try await requestUrl(url: url, session: session)

        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.invalidRequest
        }
        
        if logData {
            let dataString = String(decoding: data, as: UTF8.self)
            print("Data response:\n \(dataString)")
        }
        
        switch response.statusCode {
        case 200...206:
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let res = try decoder.decode(resultType, from: data)
                return (res, response)
            } catch {
                throw NetworkError.invalidData(error)
            }
        default:
            let res = try await decodeError(error: errorType, data: data, code: response.statusCode)
            throw NetworkError.customError(res)
        }
    }
    
    ///  Create a GET network request that throws error for no valid data responses.  No error type parameter.
    /// - Parameters:
    ///   - url: URL used in http request
    ///   - session:  Optional. URLSession with custom configuration
    ///   - logData: Optiona. A boolean to print data response as string
    ///   - resultType: Expected result type
    /// - Returns: Expected result type and HTTPURLResponse
    @discardableResult public func getRequest<T: Codable>(
        url: URL,
        session: URLSession = .shared,
        logData: Bool = false,
        resultType: T.Type
    ) async throws -> (T, HTTPURLResponse) {
        let (data, response) = try await requestUrl(url: url, session: session)

        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.invalidRequest
        }
        
        if logData {
            let dataString = String(decoding: data, as: UTF8.self)
            print("Data response:\n \(dataString)")
        }
        
        switch response.statusCode {
        case 200...206:
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let res = try decoder.decode(resultType, from: data)
                return (res, response)
            } catch {
                throw NetworkError.invalidData(error)
            }
        default:
            throw NetworkError.invalidStatusCode(response.statusCode)
        }
    }
    
    ///  Create a GET network request that throws error for no valid data responses. No result type parameter.
    /// - Parameters:
    ///   - url: URL used in http request
    ///   - session:  Optional. URLSession with custom configuration
    ///   - logData: Optiona. A boolean to print data response as string
    ///   - errorType: Expected custom error type
    /// - Returns: Data and HTTPURLResponse
    @discardableResult public func getRequest<E: Codable>(
        url: URL,
        session: URLSession = .shared,
        logData: Bool = false,
        errorType: E.Type
    ) async throws -> (Data, HTTPURLResponse) {
        let (data, response) = try await requestUrl(url: url, session: session)

        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.invalidRequest
        }
        
        if logData {
            let dataString = String(decoding: data, as: UTF8.self)
            print("Data response:\n \(dataString)")
        }
        
        switch response.statusCode {
        case 200...206:
            return (data, response)
        default:
            let res = try await decodeError(error: errorType, data: data, code: response.statusCode)
            throw NetworkError.customError(res)
        }
    }
    
    ///  Create a GET network request that throws error for no valid data responses.  No result and error types parameters.
    /// - Parameters:
    ///   - url: URL used in http request
    ///   - session:  Optional. URLSession with custom configuration
    ///   - logData: Optiona. A boolean to print data response as string
    /// - Returns: Data and HTTPURLResponse
    @discardableResult public func getRequest(
        url: URL,
        session: URLSession = .shared,
        logData: Bool = false
    ) async throws -> (Data, HTTPURLResponse) {
        let (data, response) = try await requestUrl(url: url, session: session)

        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.invalidRequest
        }
        
        if logData {
            let dataString = String(decoding: data, as: UTF8.self)
            print("Data response:\n \(dataString)")
        }
        
        switch response.statusCode {
        case 200...206:
            return (data, response)
        default:
            throw NetworkError.invalidStatusCode(response.statusCode)
        }
    }
    
    ///  Create a network request with a custom URLRequest that throws error for no valid data responses. Result and error types parameters.
    /// - Parameters:
    ///   - request: A custom URLRequest
    ///   - session:  Optional. URLSession with custom configuration
    ///   - logData: Optiona. A boolean to print data response as string
    ///   - resultType: Expected result type
    ///   - errorType: Expected custom error type
    /// - Returns: Expected result type and HTTPURLResponse
    @discardableResult public func request<T: Codable, E: Codable>(
        _ request: URLRequest,
        session: URLSession = .shared,
        logData: Bool = false,
        resultType: T.Type,
        errorType: E.Type
    ) async throws -> (T, HTTPURLResponse) {
        let (data, response) = try await requestData(request: request, session: session)

        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.invalidRequest
        }
        
        if logData {
            let dataString = String(decoding: data, as: UTF8.self)
            print("Data response:\n \(dataString)")
        }
        
        switch response.statusCode {
        case 200...206:
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let res = try decoder.decode(resultType, from: data)
                return (res, response)
            } catch {
                throw NetworkError.invalidData(error)
            }
        default:
            let res = try await decodeError(error: errorType, data: data, code: response.statusCode)
            throw NetworkError.customError(res)
        }
    }
    
    ///  Create a network request with a custom URLRequest that throws error for no valid data responses. No error type parameter.
    /// - Parameters:
    ///   - request: A custom URLRequest
    ///   - session:  Optional. URLSession with custom configuration
    ///   - logData: Optiona. A boolean to print data response as string
    ///   - resultType: Expected result type
    ///   - errorType: Expected custom error type
    /// - Returns: Expected result type and HTTPURLResponse
    @discardableResult public func request<T: Codable>(
        _ request: URLRequest,
        session: URLSession = .shared,
        logData: Bool = false,
        resultType: T.Type
    ) async throws -> (T, HTTPURLResponse) {
        let (data, response) = try await requestData(request: request, session: session)

        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.invalidRequest
        }
        
        if logData {
            let dataString = String(decoding: data, as: UTF8.self)
            print("Data response:\n \(dataString)")
        }
        
        switch response.statusCode {
        case 200...206:
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let res = try decoder.decode(resultType, from: data)
                return (res, response)
            } catch {
                throw NetworkError.invalidData(error)
            }
        default:
            throw NetworkError.invalidStatusCode(response.statusCode)
        }
    }
    
    ///  Create a network request with a custom URLRequest that throws error for no valid data responses. No result type parameter.
    /// - Parameters:
    ///   - request: A custom URLRequest
    ///   - session:  Optional. URLSession with custom configuration
    ///   - logData: Optiona. A boolean to print data response as string
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
        
        if logData {
            let dataString = String(decoding: data, as: UTF8.self)
            print("Data response:\n \(dataString)")
        }
        
        switch response.statusCode {
        case 200...206:
            return (data, response)
        default:
            let res = try await decodeError(error: errorType, data: data, code: response.statusCode)
            throw NetworkError.customError(res)
        }
    }
    
    ///  Create a network request with a custom URLRequest that throws error for no valid data responses. No result and error types parameters.
    /// - Parameters:
    ///   - request: A custom URLRequest
    ///   - session:  Optional. URLSession with custom configuration
    ///   - logData: Optiona. A boolean to print data response as string
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
        
        if logData {
            let dataString = String(decoding: data, as: UTF8.self)
            print("Data response:\n \(dataString)")
        }
        
        switch response.statusCode {
        case 200...206:
            return (data, response)
        default:
            throw NetworkError.invalidStatusCode(response.statusCode)
        }
    }
}
