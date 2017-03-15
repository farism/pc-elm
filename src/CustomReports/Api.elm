module CustomReports.Api
    exposing
        ( Params
        , Msg(..)
        , getDefinitions
        , getFilterValues
        , getRecipients
        , getReport
        )

import Http exposing (Body, Error, Request, emptyBody, expectJson, header, request)
import Json.Decode exposing (Decoder, list)
import CustomReports.Serializers exposing (decodeDefinition, decodeFilterValue, decodeRecipients, decodeReport)
import CustomReports.Types exposing (..)


type alias Params a =
    { a
        | companyId : String
        , csrf : String
        , host : String
        , projectId : Maybe String
        , reportId : String
    }


type Msg
    = FetchedDefinitions (Result Error (List Definition))
    | FetchedFilterValues String String (Result Error (List FilterValue))
    | FetchedRecipients (Result Error Recipients)
    | FetchedReport (Result Error Report)


getDefinitions : Params {} -> Cmd Msg
getDefinitions params =
    let
        path =
            "/" ++ params.companyId ++ "/company/report/definition.json"

        req =
            get params path (list decodeDefinition)
    in
        Http.send FetchedDefinitions req


getFilterValues : Params {} -> String -> String -> Cmd Msg
getFilterValues params toolType column =
    let
        path =
            "/" ++ params.companyId ++ "/company/report/" ++ toolType ++ "/" ++ column ++ "/filter_value.json"

        req =
            get params path (list decodeFilterValue)
    in
        Http.send (FetchedFilterValues toolType column) req


getRecipients : Params {} -> Cmd Msg
getRecipients params =
    let
        path =
            "/" ++ params.companyId ++ "/company/report/" ++ params.reportId ++ "/available_recipients"

        req =
            get params path decodeRecipients
    in
        Http.send FetchedRecipients req


getReport : Params {} -> Cmd Msg
getReport params =
    let
        path =
            "/" ++ params.companyId ++ "/company/report/" ++ params.reportId ++ ".json"

        req =
            get params path decodeReport
    in
        Http.send FetchedReport req


createRequest : String -> Body -> Params {} -> String -> Decoder a -> Request a
createRequest method body params path decoder =
    request
        { method = method
        , url = params.host ++ path
        , body = body
        , headers = [ header "X-CSRF-Token" params.csrf ]
        , expect = expectJson decoder
        , timeout = Nothing
        , withCredentials = False
        }


del =
    createRequest "DEL" emptyBody


get =
    createRequest "GET" emptyBody


post =
    createRequest "DEL"


put =
    createRequest "PUT"
