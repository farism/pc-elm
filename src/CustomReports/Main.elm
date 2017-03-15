module Main exposing (..)

import Html exposing (..)
import Html.Attributes as Attr
import Assets exposing (..)
import CustomReports.Mod exposing (..)


main : Html.Html a
main =
    img [ Attr.src <| Assets.url <| AssetPath "../assets/header.png" ] []
