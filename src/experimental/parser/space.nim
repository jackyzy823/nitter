import jsony, packedjson
import std/options
import user, ../types/space
from ../../types import AudioSpace, Video , VideoType , VideoVariant
# from ../../types import User, Result, Query, QueryKind

proc toAudioSpace(raw: RawAudioSpace) : AudioSpace =
  result = AudioSpace(
    rest_id: raw.metadata.rest_id,
    state: raw.metadata.state,
    title: raw.metadata.title,
    media_key: raw.metadata.media_key,
    created_at: raw.metadata.created_at,
    started_at: raw.metadata.started_at,
    scheduled_start: raw.metadata.scheduled_start,
    ended_at: raw.metadata.ended_at,
    is_locked: raw.metadata.is_locked,
    is_space_available_for_replay: raw.metadata.is_space_available_for_replay,
    total_replay_watched: raw.metadata.total_replay_watched,
    total_live_listeners: raw.metadata.total_live_listeners,
  )

proc parseGraphAudioSpace*(json: string): AudioSpace =
  let raw = json.fromJson(GraphAudioSpace)
  result = toAudioSpace raw.data.audioSpace

proc parseAudioSpaceStream*(js: JsonNode) : Option[Video] =
  let source =  js{ "source", "location" }.getStr 
  var video = Video(playbackType: m3u8 , url : source, available: true)
  video.variants.add VideoVariant( contentType: m3u8 , url: source)
  result = some video

