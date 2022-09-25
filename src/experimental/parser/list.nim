from ../types/list import RawList
from ../../types import List

import std/options

proc toList*(raw: RawList): List =
  result = List(
    id: raw.idStr,
    name: raw.name,
    username: raw.userResults.result.legacy.screenName,
    userId: raw.userResults.result.restId,
    description: raw.description,
    members: raw.memberCount,
    banner: if raw.customBannerMedia.isNone: 
              raw.defaultBannerMedia.mediaInfo.originalImgUrl
            else: 
              raw.customBannerMedia.get.mediaInfo.originalImgUrl
  )
