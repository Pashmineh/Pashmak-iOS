//
//  PashmakMessages.swift
//  Pashmak
//
//  Created by Mohammad Porooshani on 8/26/18.
//  Copyright © 2018 Mohammad Porooshani. All rights reserved.
//

import Foundation

struct Messages {

  let messages: [String]
  var random: String {
    return messages.randomElement() ?? messages[0]
  }

  private static let loadingMessages = [
    "پول نمیدین سرور کُنده دیگه...",
    "ببخشید که وقت ارزشمند شما رو داریم تلف میکنیم!... 😒",
    "دو سوته خبرشو میدم... 😋",
    "بی خبری، خوش خبری... فعلاً که خبری نیست...",
    "یکم صبر کن...",
    "خب بابا... چه خبره؟! وایسا دیگه...",
    "لطفاً کمی صبر بفرمایید قربان..."
  ]

  static let Loading = Messages(messages: Messages.loadingMessages)

  private static let rangingMessages = [
    "وایسا ببینم کجایی ...",
    "هنوز معلوم نیست کجایی ...",
    "مطمئنی رسیدی شرکت کلک؟...",
    "الان بهت میگم کجایی!..."
  ]

  static let Ranging = Messages(messages: Messages.rangingMessages)

  private static let rangingErrorMessages = [
    "نتونستیم ببینیم کجایی! یه مشکلی داری تو!",
    "کلک، نکنه تو شرکت نیستی!",
    "مگه من پیدات نکنم!"
  ]

  static let RangingError = Messages(messages: Messages.rangingErrorMessages)

  private static let serverErrorMessages = [
    "نشد که بشه!",
    "خطایی در سرور رخ داد.",
    "به من هیچ ربطی نداره، کد فرزاد کار نکرد!",
    "خطا در سرور.\n(فرززززاااددد.. بدو بیا ببینیم چی شده!)"
  ]

  static let ServerErrors = Messages(messages: Messages.serverErrorMessages)

}
