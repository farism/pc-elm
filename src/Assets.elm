module Assets exposing (..)


type AssetPath
    = AssetPath String


url : AssetPath -> String
url asset =
    case asset of
        AssetPath url ->
            url


header =
    AssetPath "./header.png"
