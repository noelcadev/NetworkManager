import Foundation

public final class AsyncNetwork {
    
    ///  Create a GET network request
    /// - Parameters:
    ///   - url: URL used in http request
    ///   - builder: A function that convert the result Data response to your expected data
    ///   - session:  Optional. URLSession with custom configuration
    ///   - errorCode:  Optional. An Int status code for expected error responses
    ///   - logData: Optiona. A boolean to print data response as string
    /// - Returns: Result with succes or failure data
    @discardableResult public static func getData<Received>(
        url: URL,
        builder: @escaping (Data, Int) -> Received?,
        session: URLSession = .shared,
        errorCode: Int? = nil,
        logData: Bool = false
    ) async -> Result<Received, NetworkError> {
        do {
            let (data, response) = try await session.data(from: url)
            guard let response = response as? HTTPURLResponse else {
                return .failure(.noHTTP)
            }
            
            if logData {
                let dataString = String(decoding: data, as: UTF8.self)
                print("Data response:\n \(dataString)")
            }
            
            switch response.statusCode {
            case 200...206, errorCode:
                if let result = builder(data, response.statusCode) {
                    return .success(result)
                } else {
                    return .failure(.notExpectedData)
                }
            default:
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
    ///   - errorCode:  Optional. An Int status code for expected error responses
    ///   - logData: Optiona. A boolean to print data response as string
    /// - Returns: Result with succes or failure data
    @discardableResult public static func getData<Received>(
        url: URL,
        builder: @escaping (Data, Int) throws -> Received,
        session: URLSession = .shared,
        errorCode: Int? = nil,
        logData: Bool = false
    ) async -> Result<Received, NetworkError> {
        do {
            let (data, response) = try await session.data(from: url)
            guard let response = response as? HTTPURLResponse else {
                return .failure(.noHTTP)
            }
            
            if logData {
                let dataString = String(decoding: data, as: UTF8.self)
                print("Data response:\n \(dataString)")
            }
            
            switch response.statusCode {
            case 200...206, errorCode:
                do {
                    let result = try builder(data, response.statusCode)
                    return .success(result)
                } catch {
                    return .failure(.notExpectedDataWithError(error))
                }
            default:
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
    ///   - errorCode:  Optional. An Int status code for expected error responses
    ///   - logData: Optiona. A boolean to print data response as string
    /// - Returns: Result with succes or failure data
    @discardableResult public static func data<Received>(
        request: URLRequest,
        builder: @escaping (Data, Int) -> Received?,
        session: URLSession = .shared,
        errorCode: Int? = nil,
        logData: Bool = false
    ) async -> Result<Received, NetworkError> {
        do {
            let (data, response) = try await session.data(for: request)
            guard let response = response as? HTTPURLResponse else {
                return .failure(.noHTTP)
            }
            
            if logData {
                let dataString = String(decoding: data, as: UTF8.self)
                print("Data response:\n \(dataString)")
            }
            
            switch response.statusCode {
            case 200...206, errorCode:
                if let result = builder(data, response.statusCode) {
                    return .success(result)
                } else {
                    return .failure(.notExpectedData)
                }
            default:
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
    ///   - errorCode:  Optional. An Int status code for expected error responses
    ///   - logData: Optiona. A boolean to print data response as string
    /// - Returns: Result with succes or failure data
    @discardableResult public static func data<Received>(
        request: URLRequest,
        builder: @escaping (Data, Int) throws -> Received,
        session: URLSession = .shared,
        errorCode: Int? = nil,
        logData: Bool = false
    ) async -> Result<Received, NetworkError> {
        do {
            let (data, response) = try await session.data(for: request)
            guard let response = response as? HTTPURLResponse else {
                return .failure(.noHTTP)
            }
            
            if logData {
                let dataString = String(decoding: data, as: UTF8.self)
                print("Data response:\n \(dataString)")
            }
            
            switch response.statusCode {
            case 200...206, errorCode:
                do {
                    let result = try builder(data, response.statusCode)
                    return .success(result)
                } catch {
                    return .failure(.notExpectedDataWithError(error))
                }
            default:
                return .failure(.statusCode(response.statusCode))
            }
        } catch {
            return .failure(.general(error))
        }
    }
}
