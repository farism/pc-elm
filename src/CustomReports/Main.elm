module CustomReports.Main exposing (..)

import Html exposing (..)
import Html.Attributes as Attr
import Http
import CustomReports.Api as Api
import CustomReports.Types exposing (..)
import Ui.Dropdown as Dropdown
import Assets


type alias Flags =
    Api.Params {}


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
    ( (model flags)
    , Cmd.batch
        (List.map
            (Cmd.map ApiMsg)
            [ (Api.getDefinitions flags)
            , (Api.getRecipients flags)
            , (Api.getReport flags)
            ]
        )
    )



-- MODEL


type alias Model =
    { contacts : List Contact
    , contactGroups : List ContactGroup
    , definitions : List Definition
    , flags : Flags
    , report : Maybe Report
    , dropdown : Dropdown.State
    }


model : Flags -> Model
model flags =
    { contacts = []
    , contactGroups = []
    , definitions = []
    , flags = flags
    , report = Nothing
    , dropdown = Dropdown.initialState
    }



-- UPDATE


type Msg
    = ApiMsg Api.Msg
    | SetDropdownState Dropdown.State


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ApiMsg apiMsg ->
            handleApiMsg apiMsg model

        SetDropdownState state ->
            let
                foo =
                    state |> Debug.log "dropdown state"
            in
                ( model, Cmd.none )


handleApiMsg : Api.Msg -> Model -> ( Model, Cmd Msg )
handleApiMsg msg model =
    case msg |> Debug.log "msg" of
        Api.FetchedDefinitions (Ok definitions) ->
            ( { model | definitions = definitions }, Cmd.none )

        Api.FetchedDefinitions (Err _) ->
            ( model, Cmd.none )

        Api.FetchedFilterValues toolType column (Ok filterValues) ->
            ( model, Cmd.none )

        Api.FetchedFilterValues toolType column (Err _) ->
            ( model, Cmd.none )

        Api.FetchedRecipients (Ok recipients) ->
            ( { model
                | contacts = recipients.contacts
                , contactGroups = recipients.groups
              }
            , Cmd.none
            )

        Api.FetchedRecipients (Err _) ->
            ( model, Cmd.none )

        Api.FetchedReport (Ok report) ->
            ( { model | report = Just report }, Cmd.none )

        Api.FetchedReport (Err _) ->
            ( model, Cmd.none )



--SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


config : Dropdown.Config Definition Msg
config =
    Dropdown.config
        { item = (\x -> li [] [ text x.type_ ])
        , toId = .type_
        , toMsg = SetDropdownState
        }


view : Model -> Html Msg
view model =
    case model.report of
        Just report ->
            div []
                [ img [ Assets.src (Assets.AssetPath "../assets/header.png") ] []
                , div [ Attr.class "tool-header" ]
                    [ h1 [] [ text report.name ]
                    , tabs report.tabs
                    , (toolsList report) model.definitions
                    , Dropdown.view config model.dropdown model.definitions
                    ]
                ]

        Nothing ->
            div [] []


tabs : List ReportTab -> Html Msg
tabs tabs =
    ul [] (List.map tab tabs)


tab : ReportTab -> Html Msg
tab tab =
    li [] [ text tab.name ]


toolsList : Report -> List Definition -> Html Msg
toolsList report definitions =
    ul [] (List.indexedMap (toolsListItem report) definitions)


toolsListItem : Report -> Int -> Definition -> Html Msg
toolsListItem report id def =
    let
        allToolTypes =
            List.foldl (\tab acc -> acc ++ tab.toolTypes) [] report.tabs

        isChecked =
            List.member def.type_ allToolTypes
    in
        li []
            [ label []
                [ input [ Attr.type_ "checkbox", Attr.checked isChecked ] []
                , text def.label
                ]
            ]
