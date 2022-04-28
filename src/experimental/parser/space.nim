import std/[options, sequtils, strutils]
import jsony, packedjson
import user, utils
import ../types/space
from ../../types import AudioSpace, Video , VideoType , VideoVariant, User

proc toUser(p: Participant): User =
  result = User(
    id: p.user.restId,
    username: p.twitter_screen_name,
    fullname: p.display_name,
    verified: p.is_verified,
    userPic:  getImageUrl(p.avatar_url).replace("_normal", "")
  )

proc toAudioSpace(raw: RawAudioSpace) : AudioSpace =
  result = AudioSpace(
    rest_id: raw.metadata.rest_id,
    state: raw.metadata.state,
    title: raw.metadata.title,
    media_key: raw.metadata.media_key,
    created_at: raw.metadata.created_at,
    started_at: raw.metadata.started_at,
    updated_at: raw.metadata.updated_at,
    scheduled_start: raw.metadata.scheduled_start,
    ended_at:  raw.metadata.ended_at.map(parseInt),
    is_locked: raw.metadata.is_locked,
    is_space_available_for_replay: raw.metadata.is_space_available_for_replay,
    total_replay_watched: raw.metadata.total_replay_watched,
    total_live_listeners: raw.metadata.total_live_listeners,
    creator: toUser raw.metadata.creator_results.result.legacy,
    participants_total: raw.participants.total,
    admins: raw.participants.admins.map(toUser),
    speakers: raw.participants.speakers.map(toUser),
    listeners: raw.participants.listeners.map(toUser)
  )

proc parseGraphAudioSpace*(json: string): AudioSpace =
  let raw = json.fromJson(GraphAudioSpace)
  result = toAudioSpace raw.data.audioSpace

proc parseAudioSpaceStream*(js: JsonNode) : Option[Video] =
  if js.hasKey("errors"): return none Video
  let source =  js{ "source", "location" }.getStr 
  var video = Video(playbackType: m3u8 , url : source, available: true)
  video.variants.add VideoVariant( contentType: m3u8 , url: source)
  result = some video

