module Main exposing (..)

import Html exposing (..)
import Html.Attributes as Attr
import Assets exposing (..)


main : Html.Html a
main =
    img [ Attr.src (Assets.url Assets.header) ] []
