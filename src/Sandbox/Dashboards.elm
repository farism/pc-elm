module Sandbox.Dashboards exposing (..)

import Html exposing (..)
import Dashboards.Main as Dashboards


flags : Dashboards.Flags
flags =
    { companyId = "2675"
    , host = "http://localhost:3000/"
    , projectId = Nothing
    }


main : Program Never Dashboards.Model Dashboards.Msg
main =
    Html.program
        { init = Dashboards.init flags
        , view = Dashboards.view
        , update = Dashboards.update
        , subscriptions = Dashboards.subscriptions
        }
