import Foundation

public final class AsyncNetwork {
    
    ///  Create a GET network request that throws error for no valid data responses
    /// - Parameters:
    ///   - url: URL used in http request
    ///   - session:  Optional. URLSession with custom configuration
    ///   - errorCode:  Optional. An Int status code for expected error responses
    ///   - logData: Optiona. A boolean to print data response as string
    ///   - builder: A function that convert the result Data response to your expected data
    ///   - builderError: A function that convert the result Error Data response to your expected error data
    /// - Returns: Result with succes or failure data
    @discardableResult public static func getData<Received>(
        url: URL,
        session: URLSession = .shared,
        errorCode: Int? = nil,
        logData: Bool = false,
        builder: @escaping (Data) throws -> Received,
        builderError: ((Data) throws -> Received)? = nil
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
                    let result = try builder(data)
                    return .success(result)
                } catch {
                    return .failure(.notExpectedData(error))
                }
            case errorCode:
                do {
                    guard let builderError = builderError else {
                        return .failure(.noBuilderError)
                    }
                    let result = try builderError(data)
                    return .success(result)
                } catch {
                    return .failure(.notExpectedData(error))
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
    ///   - session:  Optional. URLSession with custom configuration
    ///   - errorCode:  Optional. An Int status code for expected error responses
    ///   - logData: Optiona. A boolean to print data response as string
    ///   - builder: A function that convert the result Data response to your expected data
    ///   - builderError: A function that convert the result Error Data response to your expected error data
    /// - Returns: Result with succes or failure data
    @discardableResult public static func data<Received, T: Decodable>(
        request: URLRequest,
        session: URLSession = .shared,
        errorCode: Int? = nil,
        errorType: T? = nil,
        logData: Bool = false,
        builder: @escaping (Data) throws -> Received
//        builderError: ((Data) throws -> T)? = nil
    ) async -> Result<(Received?, T?), NetworkError> {
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
            case 200...206:
                do {
                    let result = try builder(data)
                    return .success((result, nil))
                } catch {
                    return .failure(.notExpectedData(error))
                }
            case errorCode:
                do {
//                    guard let builderError = builderError else {
//                        return .failure(.noBuilderError)
//                    }
                    guard let errType = errorType else {
                        return .failure(.noBuilderError)
                    }

//                    let result = try builderError(data)
                    let result = try JSONDecoder().decode(T.self, from: data)
                    return .success((nil, result))
                } catch {
                    return .failure(.notExpectedData(error))
                }
            default:
                return .failure(.statusCode(response.statusCode))
            }
        } catch {
            return .failure(.general(error))
        }
    }
}
