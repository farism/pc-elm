module Dashboards.Main exposing (..)

import Html exposing (..)
import Assets


type alias Flags =
    { companyId : String
    , host : String
    , projectId : Maybe String
    }


main : Program Flags Model Msg
main =
    Html.programWithFlags
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( (model flags), Cmd.none )



-- MODEL


type alias Model =
    {}


model : Flags -> Model
model flags =
    {}



-- UPDATE


type Msg
    = Message


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        _ ->
            ( model, Cmd.none )



--SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ text "Dashboards" ]
