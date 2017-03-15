module CustomReports.Serializers
    exposing
        ( decodeDefinition
        , decodeFilterValue
        , decodeRecipients
        , decodeReport
        )

import Json.Encode as JE
import Json.Decode as JD
import Json.Decode.Pipeline as JDP exposing (decode, optional, required)
import CustomReports.Types exposing (..)


-- USER REPORT


decodeReport : JD.Decoder Report
decodeReport =
    decode Report
        |> optional "description" JD.string ""
        |> required "id" JD.int
        |> required "is_shared_with_provider" JD.bool
        |> required "name" JD.string
        |> required "report_tabs_attributes" (JD.list decodeReportTab)
        |> required "users" (JD.list JD.int)


encodeReport : Maybe Report -> JE.Value
encodeReport report =
    case report of
        Just re ->
            JE.object
                [ ( "id", JE.int re.id )
                , ( "is_shared_with_provider", JE.bool re.isSharedWithProvider )
                , ( "name", JE.string re.name )
                  -- , ( "report_tabs_attributes", JE.int re.id )
                , ( "users", encodeList JE.int re.users )
                ]

        Nothing ->
            JE.null


decodeReportTab : JD.Decoder ReportTab
decodeReportTab =
    decode ReportTab
        |> required "report_tab_charts_attributes" (JD.list decodeReportChart)
        |> required "report_tab_columns_attributes" (JD.list decodeReportColumn)
        |> required "report_tab_filters_attributes" (JD.list decodeReportFilter)
        |> required "id" JD.int
        |> required "name" JD.string
        |> required "report_tab_sorts_attributes" (JD.list decodeReportSort)
        |> required "tool_types" (JD.list JD.string)


decodeReportChart : JD.Decoder ReportChart
decodeReportChart =
    decode ReportChart
        |> required "category_column" JD.string
        |> required "color_by" JD.bool
        |> required "filterable" JD.bool
        |> required "graph_type" JD.string
        |> required "id" JD.int
        |> required "measure_column" JD.string
        |> required "supported_filter_operators" decodeFilterOperatorList
        |> required "title" JD.string
        |> required "tool_type" JD.string


decodeReportColumn : JD.Decoder ReportColumn
decodeReportColumn =
    decode ReportColumn
        |> (required "aggregation"
                (JD.nullable
                    (JD.string |> JD.andThen decodeAggregation)
                )
           )
        |> required "attribute" JD.string
        |> required "data_type" JD.string
        |> required "filterable" JD.bool
        |> required "formula" (JD.nullable JD.string)
        |> required "groupable" JD.bool
        |> required "grouped" JD.bool
        |> required "group_position" (JD.nullable JD.int)
        |> required "hidden" JD.bool
        |> required "id" JD.int
        |> required "label" JD.string
        |> required "name" JD.string
        |> required "position" JD.int
        |> required "sortable" JD.bool
        |> required "supported_aggregation" decodeAggregationList
        |> required "supported_filter_operators" decodeFilterOperatorList
        |> required "tool_type" JD.string


decodeReportFilter : JD.Decoder ReportFilter
decodeReportFilter =
    decode ReportFilter
        |> required "attribute" JD.string
        |> required "id" JD.int
        |> required "label" JD.string
        |> required "name" JD.string
        |> required "operator" JD.string
        |> required "supported_filter_operators" decodeFilterOperatorList
        |> required "tool_type" JD.string
        |> required "values" (JD.list JD.string)


decodeReportSort : JD.Decoder ReportSort
decodeReportSort =
    decode ReportSort
        |> required "attribute" JD.string
        |> required "direction" (JD.string |> JD.andThen decodeSortDirection)
        |> required "id" JD.int
        |> required "label" JD.string
        |> required "name" JD.string
        |> required "position" JD.int
        |> required "tool_type" JD.string


decodeSortDirection : String -> JD.Decoder SortDirection
decodeSortDirection value =
    JD.succeed
        (case value of
            "asc" ->
                Asc

            "desc" ->
                Desc

            _ ->
                InvalidSortDirection
        )



-- FILTER VALUES


decodeFilterValue : JD.Decoder FilterValue
decodeFilterValue =
    decode FilterValue
        |> required "label" JD.string
        |> required "value" (JD.value |> JD.andThen decodeFilterValueType)


decodeFilterValueType : JD.Value -> JD.Decoder FilterValueType
decodeFilterValueType value =
    JD.oneOf
        [ JD.string |> JD.andThen (\x -> JD.succeed (FilterValueTypeString x))
        , JD.int |> JD.andThen (\x -> JD.succeed (FilterValueTypeInt x))
        ]



-- REPORT DEFINITION


decodeDefinition : JD.Decoder Definition
decodeDefinition =
    decode Definition
        |> required "columns" (JD.list decodeColumn)
        |> required "group_label" (JD.nullable JD.string)
        |> required "label" JD.string
        |> required "tool_type" JD.string
        |> required "type" JD.string


encodeDefinition : Definition -> JE.Value
encodeDefinition definition =
    JE.object
        [ ( "columns", (encodeList encodeColumn definition.columns) )
        , ( "group_label", (encodeMaybe JE.string definition.groupLabel) )
        , ( "label", JE.string definition.label )
        , ( "tool_type", JE.string definition.toolType )
        , ( "type", JE.string definition.type_ )
        ]



-- COLUMN DEFINITION


decodeColumn : JD.Decoder Column
decodeColumn =
    decode Column
        |> required "attribute" JD.string
        |> required "data_type" JD.string
        |> required "filterable" JD.bool
        |> required "groupable" JD.bool
        |> required "label" JD.string
        |> required "name" JD.string
        |> required "sortable" JD.bool
        |> required "supported_aggregation" decodeAggregationList
        |> required "supported_filter_operators" decodeFilterOperatorList


encodeColumn : Column -> JE.Value
encodeColumn col =
    JE.object
        [ ( "attribute", JE.string col.attribute )
        , ( "data_type", JE.string col.dataType )
        , ( "filterable", JE.bool col.filterable )
        , ( "groupable", JE.bool col.groupable )
        , ( "label", JE.string col.label )
        , ( "name", JE.string col.name )
        , ( "sortable", JE.bool col.sortable )
        , ( "supported_aggregation", encodeList encodeAggregation col.supportedAggregation )
        , ( "supported_filter_operators", encodeList encodeFilterOperator col.supportedFilterOperators )
        ]



-- AGGREGATION DEFINITION


decodeAggregationList : JD.Decoder (List Aggregation)
decodeAggregationList =
    (JD.list
        (JD.string |> JD.andThen decodeAggregation)
    )


decodeAggregation : String -> JD.Decoder Aggregation
decodeAggregation value =
    JD.succeed
        (case value of
            "COUNT" ->
                Count

            "SUM" ->
                Sum

            "MIN" ->
                Min

            "MAX" ->
                Max

            "AVG" ->
                Average

            _ ->
                InvalidAggregation
        )


encodeAggregation : Aggregation -> JE.Value
encodeAggregation aggregation =
    JE.string
        (case aggregation of
            Count ->
                "COUNT"

            Sum ->
                "SUM"

            Min ->
                "MIN"

            Max ->
                "MAX"

            Average ->
                "AVG"

            InvalidAggregation ->
                ""
        )



-- FILTER OPERATOR DEFINTIONS


decodeFilterOperatorList : JD.Decoder (List FilterOperator)
decodeFilterOperatorList =
    (JD.list
        ((JD.field "name" JD.string) |> JD.andThen decodeFilterOperator)
    )


decodeFilterOperator : String -> JD.Decoder FilterOperator
decodeFilterOperator name =
    case name of
        "=" ->
            decode MultiValue
                |> required "name" JD.string
                |> required "min_values_length" JD.int
                |> JD.andThen (\x -> decode (FilterOperatorMultiValue x))

        "!=" ->
            decode MultiValue
                |> required "name" JD.string
                |> required "min_values_length" JD.int
                |> JD.andThen (\x -> decode (FilterOperatorMultiValue x))

        "range" ->
            decode Range
                |> required "name" JD.string
                |> required "min_values_length" JD.int
                |> JD.andThen (\x -> decode (FilterOperatorRange x))

        "default_date_range" ->
            decode DefaultDateRange
                |> required "name" JD.string
                |> required "values" (JD.list decodeDefaultDateRangeValue)
                |> JD.andThen (\x -> decode (FilterOperatorDefaultDateRange x))

        "blank_date" ->
            decode BlankDate
                |> required "name" JD.string
                |> JD.andThen (\x -> decode (FilterOperatorBlankDate x))

        _ ->
            decode MultiValue
                |> required "name" JD.string
                |> optional "min_values_length" JD.int 0
                |> JD.andThen (\x -> decode (FilterOperatorMultiValue x))


encodeFilterOperator : FilterOperator -> JE.Value
encodeFilterOperator type_ =
    case type_ of
        FilterOperatorMultiValue op ->
            JE.object
                [ ( "name", JE.string op.name )
                , ( "min_values_length", JE.int op.minValuesLength )
                ]

        FilterOperatorRange op ->
            JE.object
                [ ( "name", JE.string op.name )
                , ( "min_values_length", JE.int op.minValuesLength )
                ]

        FilterOperatorDefaultDateRange op ->
            JE.object
                [ ( "name", JE.string op.name )
                , ( "values", encodeList encodeDefaultDateRangeValue op.values )
                ]

        FilterOperatorBlankDate op ->
            JE.object
                [ ( "name", JE.string op.name )
                ]


decodeDefaultDateRangeValue : JD.Decoder DefaultDateRangeValue
decodeDefaultDateRangeValue =
    decode DefaultDateRangeValue
        |> required "label" JD.string
        |> required "value" JD.string


encodeDefaultDateRangeValue : DefaultDateRangeValue -> JE.Value
encodeDefaultDateRangeValue value =
    JE.object
        [ ( "label", JE.string value.label )
        , ( "value", JE.string value.value )
        ]



-- RECIPIENTS


decodeRecipients : JD.Decoder Recipients
decodeRecipients =
    decode Recipients
        |> required "contacts" (JD.list decodeContact)
        |> required "groups" (JD.list decodeContactGroup)



-- CONTACT


decodeContact : JD.Decoder Contact
decodeContact =
    decode Contact
        |> required "first_name" JD.string
        |> required "group_ids" (JD.list JD.int)
        |> required "last_name" JD.string
        |> required "user_id" JD.int
        |> required "vendor_name" JD.string


encodeContact : Contact -> JE.Value
encodeContact c =
    JE.object
        [ ( "first_name", JE.string c.firstName )
        , ( "group_ids", encodeList JE.int c.groupIds )
        , ( "last_name", JE.string c.lastName )
        , ( "user_id", JE.int c.id )
        , ( "vendor_name", JE.string c.vendor )
        ]



-- CONTACT GROUP


decodeContactGroup : JD.Decoder ContactGroup
decodeContactGroup =
    decode ContactGroup
        |> required "id" JD.int
        |> required "label" JD.string


encodeContactGroup : ContactGroup -> JE.Value
encodeContactGroup cg =
    JE.object
        [ ( "id", JE.int cg.id )
        , ( "label", JE.string cg.label )
        ]



-- SERIALIZER HELPERS


encodeList : (a -> JE.Value) -> List a -> JE.Value
encodeList encoder items =
    JE.list (List.map encoder items)


encodeMaybe : (a -> JE.Value) -> Maybe a -> JE.Value
encodeMaybe encoder value =
    case value of
        Just val ->
            encoder val

        Nothing ->
            JE.null
