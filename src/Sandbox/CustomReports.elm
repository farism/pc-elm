module Sandbox.CustomReports exposing (..)

import Html exposing (..)
import CustomReports.Main as CustomReports


flags : CustomReports.Flags
flags =
    { companyId = "2675"
    , csrf = ""
    , host = "http://localhost:3000/"
    , projectId = Nothing
    , reportId = "380"
    }


main : Program Never CustomReports.Model CustomReports.Msg
main =
    Html.program
        { init = CustomReports.init flags
        , view = CustomReports.view
        , update = CustomReports.update
        , subscriptions = CustomReports.subscriptions
        }
