import user

import std/options

type
  RawList* = object
    createdAt*: int
    customBannerMedia*: Option[tuple[mediaInfo: tuple[originalImgUrl: string]]]
    defaultBannerMedia*: tuple[mediaInfo: tuple[originalImgUrl: string]]
    description*: string
    idStr*: string
    mode*: string
    memberCount*: int
    userResults*: tuple[result: UserResult]
    name*: string
    subscriberCount*: int


