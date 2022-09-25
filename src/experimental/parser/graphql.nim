import jsony
import user, list, ../types/graphcommon
from ../../types import User, List, Result, Query, QueryKind

proc parseGraphUser*(json: string): User =
  let raw = json.fromJson(GraphUserResponse)
  result = toUser raw.data.user.result.legacy
  result.id = raw.data.user.result.restId

proc parseGraphList*(json: string): List =
  let raw = json.fromJson(GraphListResponse)
  result = toList raw.data.list

proc parseGraphListMembers*(json, cursor: string): Result[User] =
  result = Result[User](
    beginning: cursor.len == 0,
    query: Query(kind: userList)
  )

  let raw = json.fromJson(GraphListTimelineResponse)
  for instruction in raw.data.list.timeline.timeline.instructions:
    if instruction.kind == "TimelineAddEntries":
      for entry in instruction.entries:
        case entry.content.entryType
        of TimelineTimelineItem:
          let userResult = entry.content.itemContent.userResults.result
          if userResult.restId.len > 0:
            result.content.add toUser userResult.legacy
        of TimelineTimelineCursor:
          if entry.content.cursorType == "Bottom":
            result.bottom = entry.content.value
