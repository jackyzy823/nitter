# SPDX-License-Identifier: AGPL-3.0-only
import std/[options,times]
import karax/[karaxdsl, vdom]
import tweet,renderutils
import ".."/[formatters,types]

proc convertTimestamp(ts: int): DateTime =
  result = fromUnixFloat(ts/1000).utc

proc renderSpace*(audiospace: AudioSpace; prefs: Prefs; path: string): VNode =
  buildHtml(tdiv(class="timeline-container")):
    tdiv(class="tweet-header"):
      a(class="tweet-avatar", href=("/" & audiospace.creator.username)):
        genImg(audiospace.creator.getUserPic("_bigger"), class=prefs.getAvatarClass)
      
    tdiv(class="tweet-name-row"):
      tdiv(class="fullname-and-username"):
        linkUser(audiospace.creator, class="fullname")
        linkUser(audiospace.creator, class="username")
    
    p: text audiospace.title
    p: text "State:" & $audiospace.state

    p: text "Replay watched:" & $audiospace.total_replay_watched
    p: text "Live listeners:" & $audiospace.total_live_listeners
    p: text "Created at:" & $ audiospace.created_at.convertTimestamp
    p: text "Updated at:" & $ audiospace.updated_at.convertTimestamp
    if audiospace.started_at.isSome:
      p: text "Started at:" & $ audiospace.started_at.get().convertTimestamp
    if audiospace.scheduled_start.isSome:
      p: text "Scheduled at:" & $ audiospace.scheduled_start.get().convertTimestamp

    if audiospace.ended_at.isSome:
      p: text "Ended at:" & $ audiospace.ended_at.get().convertTimestamp

    if audiospace.source.isSome:
      if not prefs.proxyVideos:
        p: text "AudioSpace only work with Preferences:\"Proxy video streaming through the server\""
      else:
        renderVideo(audiospace.source.get(), prefs , path)

