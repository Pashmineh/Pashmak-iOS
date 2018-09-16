//
//  Network.swift
//  Pashmak
//
//  Created by Mohammad Porooshani on 8/25/18.
//  Copyright © 2018 Mohammad Porooshani. All rights reserved.
//

import Foundation
import Log
import PromiseKit

enum PashmakServer {

  private static var networkActivity: Int = 0 {
    didSet {
      updateAppNetworkActivity()
    }
  }

  static func increaseNetworkActivity() {
    PashmakServer.networkActivity += 1
  }

  static func decreaseNetworkActivity() {
    PashmakServer.networkActivity = max(0, PashmakServer.networkActivity - 1)
  }

  private static func updateAppNetworkActivity() {
    DispatchQueue.main.async {
      if networkActivity > 0 {
        guard !UIApplication.shared.isNetworkActivityIndicatorVisible else {
        return
      }
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
      } else {
        guard UIApplication.shared.isNetworkActivityIndicatorVisible else {
        return
      }
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
      }
    }
  }

  static func perform<T: Codable>(request: HTTPRequest, validResponseCodes: [Int] = [200], dispatchQueue: DispatchQueue = DispatchQueue.main) -> Promise<ServerData<T>> {
    return Promise { seal in

      func reject(_ error: APIError) {
        Log.trace("at: \(error.localizedDescription)")
        dispatchQueue.async {
          seal.reject(error)
        }

      }

      // Check to see if we have a valid request
      guard let urlRequest = request.request as URLRequest? else {
        return reject(APIError.invalidRequest)
      }

      // Use shared Session
      let session = URLSession.shared

      // Generate the task
      let dataTask = session.dataTask(with: urlRequest) { responseData, urlResponse, err -> Void in

        // Remove the activity because the network call has been concluded here.
        PashmakServer.decreaseNetworkActivity()

        // If error is not nil, it means there was an error in netowk connection.
        if let netError = err {
          return reject(APIError.networkError(netError))
        }

        // Convert the response to usable response.
        guard let httpResponse = urlResponse as? HTTPURLResponse else {
          return reject(APIError.invalidResponse)
        }

        // Check to see if the response code is what we were waiting for.
        guard validResponseCodes.contains(httpResponse.statusCode) else {
//          let errorModel = generateServerError(from: urlResponse, responseData: responseData, status: httpResponse.statusCode)
          return reject(APIError.invalidResponseCode(httpResponse.statusCode))
        }

        // Get the data
        guard var responseData = responseData else {
          return reject(APIError.noResponseData)
        }

        // Parse Response
        do {
          if responseData.isEmpty {
            responseData = "{}".data(using: .utf8) ?? Data()
          }

          let responseObject = try JSONDecoder().decode(T.self, from: responseData)
          let serverData = ServerData(httpStatus: httpResponse.statusCode, model: responseObject)

          dispatchQueue.async {
            seal.fulfill(serverData)
          }

        } catch {
          //          let responseBody = String(data: responseData, encoding: .utf8)
          //          Log.trace(responseBody)
          return reject(APIError.parserFailed(error))
        }

      }

      // Increase number of network activities
      PashmakServer.increaseNetworkActivity()

      // Start the URL Task
      dataTask.resume()

    }
  }
  /*
  static private func generateServerError(from urlResponse: URLResponse?, responseData: Data?, status: Int) -> ServerErrorModel {

    let url = (urlResponse as? HTTPURLResponse)?.url?.absoluteString

    func fallbackErrorModel() -> ServerErrorModel {

      return ServerErrorModel(statusCode: status, url: url, messages: nil)
    }

    guard let responseData = responseData else {
      return fallbackErrorModel()
    }

    do {
      let errorMessages = try JSONDecoder().decode([ServerErrorModel.serverErrorMessage].self, from: responseData)

      let errorModel = ServerErrorModel(statusCode: status, url: url, messages: errorMessages)
      return errorModel
    } catch {
      Log.trace("Could not parse server error message!\n\(error)")
      let errorString = String(data: responseData, encoding: .utf8)
      Log.trace("++++++++ [\(url ?? "")] ERROR: \(errorString ?? "")")
      return fallbackErrorModel()
    }

  }
  */

}
