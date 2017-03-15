module Assets exposing (..)

import Html
import Html.Attributes


type AssetPath
    = AssetPath String


url : AssetPath -> String
url asset =
    case asset of
        AssetPath url ->
            url


src : AssetPath -> Html.Attribute msg
src asset =
    Html.Attributes.src <| url <| asset
