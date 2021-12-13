import strformat
import karax/[karaxdsl, vdom]

import renderutils
import ".."/[types, utils]
import timeline

proc renderListTabs*(query: Query; path: string): VNode =
  buildHtml(ul(class="tab")):
    li(class=query.getTabClass(posts)):
      a(href=(path)): text "Tweets"
    li(class=query.getTabClass(userList)):
      a(href=(path & "/members")): text "Members"

proc renderList*(body: VNode; query: Query; list: List): VNode =
  buildHtml(tdiv(class="timeline-container")):
    if list.banner.len > 0:
      tdiv(class="timeline-banner"):
        a(href=getPicUrl(list.banner), target="_blank"):
          genImg(list.banner)

    tdiv(class="timeline-header"):
      text &"\"{list.name}\" by @{list.username}"

      tdiv(class="timeline-description"):
        text list.description

    renderListTabs(query, &"/i/lists/{list.id}")
    body



proc renderListsTabs*(query: Query; path: string): VNode =
  buildHtml(ul(class="tab")):
    # TODO which active?
    li(class=query.getTabClass(lists)):
      a(href=(path & "/lists")): text "Lists"
    li(class=query.getTabClass(lists)):
      a(href=(path & "/lists/memberships")): text "Memberships"

#TODO
proc renderListInfo(list: List; prefs: Prefs): VNode =
  buildHtml(tdiv(class="timeline-item")):
    tdiv(class=""):
      a(href=getPicUrl(list.banner), target="_blank"):
        genImg(list.banner)
      a(href="/i/lists/"& list.id):
        tdiv(class="timeline-description"):
          text list.name
      tdiv(class="timeline-description"):
        text list.description
      text list.username 
      text list.userId


    # tdiv(class="tweet-body profile-result"):
    #   tdiv(class="tweet-header"):
    #     a(class="tweet-avatar", href=("/" & user.username)):
          # genImg(user.getUserpic("_bigger"), class="avatar")

    #     tdiv(class="tweet-name-row"):
    #       tdiv(class="fullname-and-username"):
    #         linkUser(user, class="fullname")
    #     linkUser(user, class="username")

    #   tdiv(class="tweet-content media-body", dir="auto"):
    #     verbatim replaceUrl(user.bio, prefs)


proc renderNoMore(): VNode =
  buildHtml(tdiv(class="timeline-footer")):
    h2(class="timeline-end"):
      text "No more items"

proc renderNoneFound(): VNode =
  buildHtml(tdiv(class="timeline-header")):
    h2(class="timeline-none"):
      text "No items found"

proc renderLists*(results: Result[List]; name: string; prefs: Prefs; path=""): VNode =
  echo "renderlists"
  echo name
  buildHtml(tdiv(class="timeline-container")):
    renderListsTabs(results.query, &"/lists/{name}")
    if not results.beginning:
      renderNewer(results.query, path)
    if results.content.len > 0:
      for list in results.content:
        renderListInfo(list, prefs)
      if results.bottom.len > 0:
        renderMore(results.query, results.bottom)
      renderToTop()
    elif results.beginning:
      renderNoneFound()
    else:
      renderNoMore()
