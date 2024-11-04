module Index exposing (..)

import Browser
import Element as E
import Element.Region as Region
import Html exposing (Html, a, h1, h2, li, text, ul)
import Html.Attributes exposing (href, style)
import Task
import Time


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


type alias Model =
    { zone : Time.Zone
    , time : Time.Posix
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model Time.utc (Time.millisToPosix 0)
    , Task.perform AdjustTimeZone Time.here
    )


type Msg
    = Tick Time.Posix
    | AdjustTimeZone Time.Zone


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick time ->
            ( { model | time = time }, Cmd.none )

        AdjustTimeZone zone ->
            ( { model | zone = zone }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Time.every 1000 Tick


viewTime : Model -> E.Element msg
viewTime model =
    let
        pad t =
            if String.length t == 1 then
                "0" ++ t

            else
                t

        hour =
            pad <| String.fromInt (Time.toHour model.zone model.time)

        minute =
            pad <| String.fromInt (Time.toMinute model.zone model.time)

        second =
            pad <| String.fromInt (Time.toSecond model.zone model.time)
    in
    E.html <| h2 [] [ text (hour ++ ":" ++ minute ++ ":" ++ second) ]


type alias Page =
    { url : String
    , title : String
    }


pages : List Page
pages =
    [ Page "/pages/book.html" "Book from elm.org"
    , Page "/pages/dice.html" "Dice simulator"
    , Page "/pages/login.html" "Login page example"
    , Page "/pages/main.html" "Main page"
    , Page "/pages/quotes.html" "Random Quotes"
    , Page "/pages/termo.html" "Converter: Thermo"
    , Page "/pages/text.html" "Text"
    ]


domain : String
domain =
    "/elm-pages"


viewPage : Page -> E.Element Msg
viewPage p =
    -- E.link []
    --     { url = p.url
    --     , label = E.text p.title
    --     }
    E.html <| a [ href p.url ] [ text p.title ]


viewPages : List Page -> List (E.Element Msg)
viewPages pgs =
    pgs |> List.map viewPage


viewPages2 : List Page -> Html msg
viewPages2 pgs =
    let
        viewP p =
            li [] [ a [ href <| domain ++ p.url ] [ text p.title ] ]
    in
    ul [ style "line-heigth" "normal !important" ] <| List.map viewP pgs


view : Model -> Html Msg
view model =
    E.layout [] <|
        E.column
            [ E.centerX
            , E.centerY
            , E.spacing 10
            , E.padding 7
            ]
        <|
            [ E.html <| h1 [] [ text "LitFill's pages built with Elm" ]
            , E.el
                [ Region.mainContent
                , E.centerX
                , E.centerY
                ]
              <|
                viewTime model

            -- , E.column
            --     [ Region.navigation
            --     , E.spacing 10
            --     , E.padding 7
            --     ]
            --   <|
            --     viewPages pages
            , E.html <| viewPages2 pages
            ]
