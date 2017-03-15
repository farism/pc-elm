module Ui.Dropdown exposing (Config, State, config, initialState, view)

import Html exposing (..)
import Html.Attributes exposing (..)


-- MODEL


type State
    = State
        { open : Bool
        }



-- UPDATE
-- VIEW


type Config data msg
    = Config
        { item : data -> Html msg
        , toId : data -> String
        , toMsg : State -> msg
        }


config :
    { item : data -> Html msg
    , toId : data -> String
    , toMsg : State -> msg
    }
    -> Config data msg
config { item, toId, toMsg } =
    Config
        { item = item
        , toId = toId
        , toMsg = toMsg
        }


initialState : State
initialState =
    State { open = False }


view : Config data msg -> State -> List data -> Html msg
view (Config { item, toId, toMsg }) state items =
    let
        foo =
            items |> Debug.log "items"
    in
        div []
            [ div []
                [ ul [] ([] ++ List.map item items)
                ]
            ]
