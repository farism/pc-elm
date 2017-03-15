module Sandbox.CustomReports exposing (..)

import Html exposing (..)
import CustomReports.Main as CR


flags : CR.Flags
flags =
    { companyId = "2675"
    , csrf = ""
    , host = "http://localhost:3000/"
    , projectId = Nothing
    , reportId = "380"
    }


main : Program Never CR.Model CR.Msg
main =
    Html.program
        { init = CR.init flags
        , view = CR.view
        , update = CR.update
        , subscriptions = CR.subscriptions
        }
