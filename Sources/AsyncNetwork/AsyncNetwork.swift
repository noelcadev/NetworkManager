import Foundation

public final class AsyncNetwork {
    
    ///  Create a GET network request that throws error for no valid data responses
    /// - Parameters:
    ///   - url: URL used in http request
    ///   - session:  Optional. URLSession with custom configuration
    ///   - logData: Optiona. A boolean to print data response as string
    ///   - builder: A function that convert the result Data response to your expected data
    /// - Returns: Result with succes or failure data and HTTPURLResponse
    @discardableResult public static func getData<Received>(
        url: URL,
        session: URLSession = .shared,
        logData: Bool = false,
        builder: @escaping (Data) throws -> Received
    ) async -> (Result<Received, NetworkError>, HTTPURLResponse?) {
        do {
            let (data, response) = try await session.data(from: url)
            guard let response = response as? HTTPURLResponse else {
                return (.failure(.noHTTP), nil)
            }
            
            if logData {
                let dataString = String(decoding: data, as: UTF8.self)
                print("Data response:\n \(dataString)")
            }
            
            switch response.statusCode {
            case 200...206:
                do {
                    let result = try builder(data)
                    return (.success(result), response)
                } catch {
                    return (.failure(.notExpectedData(error)), response)
                }
            default:
                return (.failure(.statusCode(response.statusCode)), response)
            }
        } catch {
            return (.failure(.general(error)), nil)
        }
    }
    
    ///  Create a GET network request that throws error for no valid data responses
    /// - Parameters:
    ///   - url: URL used in http request
    ///   - session:  Optional. URLSession with custom configuration
    ///   - logData: Optiona. A boolean to print data response as string
    ///   - builder: A function that convert the result Data response to your expected data
    ///   - builderError: A function that convert the result Error Data response to your expected error data
    /// - Returns: Result with succes or failure data and HTTPURLResponse
    @discardableResult public static func getData<Received, ErrorType>(
        url: URL,
        session: URLSession = .shared,
        logData: Bool = false,
        builder: @escaping (Data) throws -> Received,
        builderError: ((Data) throws -> ErrorType)? = nil
    ) async -> (Result<(Received?, ErrorType?), NetworkError>, HTTPURLResponse?) {
        do {
            let (data, response) = try await session.data(from: url)
            guard let response = response as? HTTPURLResponse else {
                return (.failure(.noHTTP), nil)
            }
            
            if logData {
                let dataString = String(decoding: data, as: UTF8.self)
                print("Data response:\n \(dataString)")
            }
            
            switch response.statusCode {
            case 200...206:
                do {
                    let result = try builder(data)
                    return (.success((result, nil)), response)
                } catch {
                    return (.failure(.notExpectedData(error)), response)
                }
            default:
                do {
                    guard let builderError = builderError else {
                        return (.failure(.statusCode(response.statusCode)), response)
                    }
                    
                    let result = try builderError(data)
                    return (.success((nil, result)), response)
                } catch {
                    return (.failure(.notExpectedData(error)), response)
                }
            }
        } catch {
            return (.failure(.general(error)), nil)
        }
    }
    
    ///  Create a network request with a custom URLRequest that throws error for no valid data responses
    /// - Parameters:
    ///   - request: A custom URLRequest
    ///   - session:  Optional. URLSession with custom configuration
    ///   - logData: Optiona. A boolean to print data response as string
    ///   - builder: A function that convert the result Data response to your expected data
    /// - Returns: Result with succes or failure data and HTTPURLResponse
    @discardableResult public static func data<Received>(
        request: URLRequest,
        session: URLSession = .shared,
        logData: Bool = false,
        builder: @escaping (Data) throws -> Received
    ) async -> (Result<Received, NetworkError>, HTTPURLResponse?) {
        do {
            let (data, response) = try await session.data(for: request)
            guard let response = response as? HTTPURLResponse else {
                return (.failure(.noHTTP), nil)
            }
            
            if logData {
                let dataString = String(decoding: data, as: UTF8.self)
                print("Data response:\n \(dataString)")
            }
            
            switch response.statusCode {
            case 200...206:
                do {
                    let result = try builder(data)
                    return (.success(result), response)
                } catch {
                    return (.failure(.notExpectedData(error)), response)
                }
            default:
                return (.failure(.statusCode(response.statusCode)), response)
            }
        } catch {
            return (.failure(.general(error)), nil)
        }
    }
    
    ///  Create a network request with a custom URLRequest that throws error for no valid data responses
    /// - Parameters:
    ///   - request: A custom URLRequest
    ///   - session:  Optional. URLSession with custom configuration
    ///   - logData: Optiona. A boolean to print data response as string
    ///   - builderError: A function that convert the result Error Data response to your expected error data
    ///   - builder: A function that convert the result Data response to your expected data
    ///   - builderError: A function that convert the result Error Data response to your expected error data
    /// - Returns: Result with succes or failure data and HTTPURLResponse
    @discardableResult public static func data<Received, ErrorType>(
        request: URLRequest,
        session: URLSession = .shared,
        logData: Bool = false,
        builder: @escaping (Data) throws -> Received,
        builderError: ((Data) throws -> ErrorType)? = nil
    ) async -> (Result<(Received?, ErrorType?), NetworkError>, HTTPURLResponse?) {
        do {
            let (data, response) = try await session.data(for: request)
            guard let response = response as? HTTPURLResponse else {
                return (.failure(.noHTTP), nil)
            }
            
            if logData {
                let dataString = String(decoding: data, as: UTF8.self)
                print("Data response:\n \(dataString)")
            }
            
            switch response.statusCode {
            case 200...206:
                do {
                    let result = try builder(data)
                    return (.success((result, nil)), response)
                } catch {
                    return (.failure(.notExpectedData(error)), response)
                }
            default:
                do {
                    guard let builderError = builderError else {
                        return (.failure(.statusCode(response.statusCode)), response)
                    }
                    
                    let result = try builderError(data)
                    return (.success((nil, result)), response)
                } catch {
                    return (.failure(.notExpectedData(error)), response)
                }
            }
        } catch {
            return (.failure(.general(error)), nil)
        }
    }
}
