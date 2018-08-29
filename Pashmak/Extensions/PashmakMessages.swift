//
//  PashmakMessages.swift
//  Pashmak
//
//  Created by Mohammad Porooshani on 8/26/18.
//  Copyright © 2018 Mohammad Porooshani. All rights reserved.
//

import Foundation

struct Messages {
  struct Loading {
    static let messages = [
      "پول نمیدین سرور کُنده دیگه...",
      "ببخشید که وقت ارزشمند شما رو داریم تلف میکنیم!... 😒",
      "دو سوته خبرشو میدم... 😋",
      "بی خبری، خوش خبری... فعلاً که خبری نیست...",
      "یکم صبر کن...",
      "خب بابا... چه خبره؟! وایسا دیگه...",
      "لطفاً کمی صبر بفرمایید قربان..."
    ]

    static var random: String {
      return messages.randomElement() ?? messages[0]
    }
  }

  struct ServerErrors {
    static let messages = [
      "نشد که بشه!",
    "خطایی در سرور رخ داد.",
    "به من هیچ ربطی نداره، کد فرزاد کار نکرد!",
    "خطا در سرور.\n(فرززززاااددد.. بدو بیا ببینیم چی شده!)"
    ]

    static var random: String {
      return messages.randomElement() ?? messages[0]
    }
  }
}
