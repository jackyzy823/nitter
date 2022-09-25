import user, list

import std/options

import jsony, packedjson

type
  ## struct like {"data":{"user":{"result":{"(timeline|timeline_v2 )":{"timeline":{"instructions":{}}}}}}}
  ##  For `Following`  `Followers`  -> TimelineUser -> Result[User]
  ##   `Likes` -> TimelineTweet -> Result[Tweet]
  ##   `CombinedLists` `ListMemberships` -> TimelineTwitterList -> Result[List]
  GraphUserTimelineResponse* = object
    data*: tuple[user: tuple [result: TimelineResult]]

  ## struct like {"data":{"user":{"result":{"id_str":"" ... }}}}
  ## Used by UserByRestId / UserByScreenName -> User
  GraphUserResponse* = object
    data*: tuple[user: tuple [result: UserResult]]

  ## struct like {"data":{"list":"(subscribers_timeline|members_timeline)"}}
  ## For `ListSubscribers` ` ListMembers` -> TimelineUser -> Result[User]
  GraphListTimelineResponse* = object
    data*: tuple[list: TimelineResult]

  # For ListByRestId/ListBySlug (with parseHook) -> List
  GraphListResponse* = object
    data*: tuple[list: RawList]

  TimelineResult = object
    timeline*: tuple[timeline: tuple [instructions: seq[Instruction]]]


  ## Common Parts
  Instruction = object
    kind*: string
    entries*: seq[tuple[content: Content]]

  ContentEntryType* = enum
    TimelineTimelineItem
    TimelineTimelineCursor

  ItemType* = enum
    TimelineUser
    TimelineTweet
    TimelineTwitterList

  Content = object
    case entryType*: ContentEntryType
    of TimelineTimelineItem:
      itemContent*: ItemContent
    of TimelineTimelineCursor:
      value*: string
      cursorType*: string

  ItemContent = object
    case itemType*: ItemType
    of TimelineUser:
      userResults*: tuple[result: UserResult]
    of TimelineTweet:
      # Currently it can be parsed with parseTweet
      # TODO: make this RawTweet -> Tweet to decouple parseTweet
      tweetResults*: tuple[result: tuple[legacy: JsonNode]]
    of TimelineTwitterList:
      list*: RawList

proc renameHook*(v: var TimelineResult; fieldName: var string) =
  if fieldName in @["subscribers_timeline", "members_timeline", "timeline_v2"]:
    fieldName = "timeline"

proc renameHook*(v: var Instruction; fieldName: var string) =
  if fieldName == "type":
    fieldName = "kind"

# normalize ListByRestId and ListBySlug
proc parseHook*(s: string; i: var int; v: var GraphListResponse) =
  var check: tuple[data: tuple[userByScreenName: Option[tuple[list: RawList]];
                                list: RawList]]
  parseHook(s, i, check)
  if not check.data.userByScreenName.isNone:
    v.data = check.data.userByScreenName.get
  else:
    v.data.list = check.data.list
