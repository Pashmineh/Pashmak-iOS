//
//  LoginInteractor.swift
//  Pashmak
//
//  Created by Mohammad Porooshani on 8/21/18.
//  Copyright (c) 2018 Mohammad Porooshani. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import Regex

protocol LoginBusinessLogic {
  func verify(request: Login.Verify.Request)

  func login(request: Login.Authenticate.Request)
}

protocol LoginDataStore {

}

class LoginInteractor: LoginBusinessLogic, LoginDataStore {
  var presenter: LoginPresentationLogic?

  func verify(request: Login.Verify.Request) {
    let phone = request.phone
    let nationalID = request.nationalID
    let phoneIsValid = verifyPhone(phone: phone)
    let nationalIDIsValid = verifyNationalID(nationalID: nationalID)

    let response: Login.Verify.Response = Login.Verify.Response(phoneIsValid: phoneIsValid, nationalIdIsValid: nationalIDIsValid)
    presenter?.presentVerify(response: response)
  }

  private func verifyPhone(phone: String) -> Bool {

    return Regex.KD.phoneNumber.matches(phone)

  }

  private func verifyNationalID(nationalID: String) -> Bool {

    guard Regex.KD.nationalID.matches(nationalID) else {
      return false
    }

    var chars = Array(nationalID.compactMap({ Int("\($0)")}))

    let controlDigit = chars.removeFirst()

    var acc = 0
    for indx in 1...9 {
      acc += ((indx + 1) * chars[indx-1])
    }

    var res = acc % 11

    if res > 1 {
      res = 11 - res
    }

    return res == controlDigit
  }

  func login(request: Login.Authenticate.Request) {

    let userName = request.userName
    let password = request.password

    func sendFailed(error: Error) {

      let response = Login.Authenticate.Response.init(state: .failure(error))
      presenter?.presentAuthenticate(response: response)
      Log.error("Error Authenticating:\n\(error.localizedDescription)")
    }

    func sendAuthenticationLoading() {
      let response = Login.Authenticate.Response.init(state: .loading)
      presenter?.presentAuthenticate(response: response)
    }

    func preserveAuthenticationResults(response: ServerModels.Authentication.Response, phoneNumber: String) {
      guard let token = response.token else {
        Log.trace("Oauth token not found!")
        return
      }
      Log.trace("OauthToken: [\(token)]")
      Settings.current.update(oauthToken: token)

      let firstName = response.name ?? ""
      let lastName = response.lastName ?? ""

      Settings.current.update(firstName: firstName, lastName: lastName)

      let avatarURL = "http://178.62.20.28/Photos/\(phoneNumber).jpeg"
      Settings.current.update(avatarURL: avatarURL)

      Settings.current.update(phoneNumber: phoneNumber)

    }

    guard self.verifyPhone(phone: userName) && self.verifyNationalID(nationalID: password) else {
      let error = APIError.invalidParameters("Username or Password")
      sendFailed(error: error)
      return
    }

    sendAuthenticationLoading()

    let authInfo = ServerModels.Authentication.Request(username: userName, password: password)

    PashmakServer.perform(request: ServerRequest.Authentication.authenticate(info: authInfo), validResponseCodes: [200, 201])
      .done { (ressult: ServerData<ServerModels.Authentication.Response>) in
        let model = ressult.model
        preserveAuthenticationResults(response: model, phoneNumber: userName)
        let response = Login.Authenticate.Response.init(state: .success(model))
        self.presenter?.presentAuthenticate(response: response)

    }
      .catch { (error) in
        sendFailed(error: error)
    }

  }

}
