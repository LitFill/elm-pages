module Termo exposing (..)

import Browser
import Html exposing (Html, input, span, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)


main : Program () Model Msg
main =
    Browser.sandbox { init = init, update = update, view = view }


type alias Model =
    { input : String
    }


init : Model
init =
    { input = "" }


type Msg
    = ToCelcius String


update : Msg -> Model -> Model
update msg model =
    case msg of
        ToCelcius newInput ->
            { model | input = newInput }


view : Model -> Html Msg
view model =
    case String.toFloat model.input of
        Just celsius ->
            viewConverter model.input "blue" (String.fromFloat (celsius * 1.8 + 32))

        Nothing ->
            viewConverter model.input "red" "???"


viewConverter : String -> String -> String -> Html Msg
viewConverter userInput color equivalentTemp =
    span [ align "center" ]
        [ input [ value userInput, onInput ToCelcius, style "width" "40px" ] []
        , text "°C = "
        , span [ style "color" color ] [ text equivalentTemp ]
        , text "°F"
        ]
