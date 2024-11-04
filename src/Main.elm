module Main exposing (main)

import Browser
import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)


type Message
    = Decrement Int
    | Increment Int
    | Reset


type alias Model =
    Int


init : Model
init =
    69


update : Message -> Model -> Model
update msg model =
    case msg of
        Decrement step ->
            model - step

        Increment step ->
            model + step

        Reset ->
            0


view : Model -> Html Message
view model =
    div []
        [ button [ onClick (Decrement 1) ] [ text "-" ]
        , button [ onClick (Decrement 10) ] [ text "- 10" ]
        , div [] [ text (String.fromInt model ++ " urmom") ]
        , button [ onClick (Increment 1) ] [ text "+" ]
        , button [ onClick (Increment 10) ] [ text "+ 10" ]
        , button [ onClick Reset ] [ text "reset" ]
        ]


main : Program () Model Message
main =
    Browser.sandbox
        { init = init
        , update = update
        , view = view
        }
