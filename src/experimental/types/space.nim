import options
from ../../types import AudioSpaceState

type 
  GraphAudioSpace* = object
    data*: Data

  Data = object
    audioSpace*: RawAudioSpace

  RawAudioSpace* = object
    metadata*: Metadata
#    sharings*: Option[Sharings]
    participants*: Participants

  Metadata = object
    rest_id*: string
    state*: AudioSpaceState
    title*: string
    media_key*: string
    created_at*: int
    started_at*: int
    scheduled_start*: Option[int]
    # stateEnded/stateTimedOut
    ended_at*: Option[string]
    # only stateRunning
    updated_at*: int
    is_employee_only*: bool
    is_locked*: bool
    is_space_available_for_replay*: bool
    conversation_controls*: int
    total_replay_watched*: int
    total_live_listeners*: int
    # creator_results 


# TODO maybe sharing tweet in space
# but we do not auto reload , so ??
#  Sharings = object
#    items*: seq[object]
#    slice_info*: object 

  Participants = object
    total*: int
    admins*: seq[Paticipant]
    speakers*: seq[Paticipant]
    listeners*: seq[Paticipant]

  Paticipant = object
    periscope_user_id*: string
    start*: int
    twitter_screen_name*: string
    display_name*: string
    avatar_url*: string
    is_verified*: bool
    is_muted_by_admin*: bool
    is_muted_by_guest*: bool
    # user_results -> result -> { __typename , has_nft_avatar}
    # user -> rest_id
    
