module CustomReports.Types exposing (..)


type alias Report =
    { description : String
    , id : Int
    , isSharedWithProvider : Bool
    , name : String
    , tabs : List ReportTab
    , users : List Int
    }


type alias ReportTab =
    { charts : List ReportChart
    , columns : List ReportColumn
    , filters : List ReportFilter
    , id : Int
    , name : String
    , sorts : List ReportSort
    , toolTypes : List String
    }


type alias ReportChart =
    { categoryColumn : String
    , colorBy : Bool
    , filterable : Bool
    , graphType : String
    , id : Int
    , measureColumn : String
    , supportedFilterOperators : List FilterOperator
    , title : String
    , toolType : String
    }


type alias ReportColumn =
    { aggregation : Maybe Aggregation
    , attribute : String
    , dataType : String
    , filterable : Bool
    , formula : Maybe String
    , groupable : Bool
    , grouped : Bool
    , groupPosition : Maybe Int
    , hidden : Bool
    , id : Int
    , label : String
    , name : String
    , position : Int
    , sortable : Bool
    , supportedAggregation : List Aggregation
    , supportedFilterOperators : List FilterOperator
    , toolType : String
    }


type alias ReportFilter =
    { attribute : String
    , id : Int
    , label : String
    , name : String
    , operator : String
    , supportedFilterOperators : List FilterOperator
    , toolType : String
    , values : List String
    }


type alias ReportSort =
    { attribute : String
    , direction : SortDirection
    , id : Int
    , label : String
    , name : String
    , position : Int
    , toolType : String
    }


type SortDirection
    = Asc
    | Desc
    | InvalidSortDirection


type alias FilterValue =
    { label : String
    , value : FilterValueType
    }


type FilterValueType
    = FilterValueTypeString String
    | FilterValueTypeInt Int


type alias Definition =
    { columns : List Column
    , groupLabel : Maybe String
    , label : String
    , toolType : String
    , type_ : String
    }


type alias Column =
    { attribute : String
    , dataType : String
    , filterable : Bool
    , groupable : Bool
    , label : String
    , name : String
    , sortable : Bool
    , supportedAggregation : List Aggregation
    , supportedFilterOperators : List FilterOperator
    }


type Aggregation
    = Count
    | Sum
    | Min
    | Max
    | Average
    | InvalidAggregation


type FilterOperator
    = FilterOperatorMultiValue MultiValue
    | FilterOperatorRange Range
    | FilterOperatorDefaultDateRange DefaultDateRange
    | FilterOperatorBlankDate BlankDate


type alias MultiValue =
    { name : String
    , minValuesLength : Int
    }


type alias Range =
    { name : String
    , minValuesLength : Int
    }


type alias DefaultDateRange =
    { name : String
    , values : List DefaultDateRangeValue
    }


type alias DefaultDateRangeValue =
    { label : String
    , value : String
    }


type alias BlankDate =
    { name : String
    }


type alias Recipients =
    { contacts : List Contact
    , groups : List ContactGroup
    }


type alias Contact =
    { firstName : String
    , groupIds : List Int
    , lastName : String
    , id : Int
    , vendor : String
    }


type alias ContactGroup =
    { id : Int
    , label : String
    }
