import strutils
import uri

import jester

import router_utils
import ".."/[query, types, redis_cache, api]
import ../views/[general, timeline, list]
export getListTimeline, getGraphList

template respList*(list, timeline, title, vnode: typed) =
  if list.id.len == 0:
    resp Http404, showError("List \"" & @"list" & "\" not found", cfg)

  let
    html = renderList(vnode, timeline.query, list)
    rss = "/i/lists/$1/rss" % [@"id"]

  resp renderMain(html, request, cfg, prefs, titleText=title, rss=rss, banner=list.banner)

proc createListRouter*(cfg: Config) =
  router list:
    get "/@name/lists/@slug/?":
      cond '.' notin @"name"
      cond @"name" != "i"
      cond @"slug" != "memberships"
      let
        slug = decodeUrl(@"slug")
        list = await getCachedList(@"name", slug)
      if list.id.len == 0:
        resp Http404
      redirect("/i/lists/" & list.id)

    get "/i/lists/@id/?":
      cond '.' notin @"id"
      let
        prefs = cookiePrefs()
        list = await getCachedList(id=(@"id"))
        title = "@" & list.username & "/" & list.name
        timeline = await getListTimeline(list.id, getCursor())
        vnode = renderTimelineTweets(timeline, prefs, request.path)
      respList(list, timeline, title, vnode)

    get "/i/lists/@id/members":
      cond '.' notin @"id"
      let
        prefs = cookiePrefs()
        list = await getCachedList(id=(@"id"))
        title = "@" & list.username & "/" & list.name
        members = await getListMembers(list, getCursor())
      respList(list, members, title, renderTimelineUsers(members, prefs, request.path))
