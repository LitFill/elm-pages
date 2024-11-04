module Text exposing (..)

import Browser
import Html exposing (Html, div, input, text)
import Html.Attributes exposing (placeholder, value)
import Html.Events exposing (onInput)


type alias Content =
    String


type alias Model =
    { content : Content }


init : Model
init =
    { content = "Text to reverse" }


type Msg
    = Change Content


update : Msg -> Model -> Model
update msg model =
    case msg of
        Change new ->
            { model | content = new }


view : Model -> Html Msg
view model =
    div []
        [ input [ placeholder "Text to reverse", value model.content, onInput Change ] []
        , div [] [ text (String.reverse model.content) ]
        , div []
            [ model.content
                |> String.length
                |> String.fromInt
                |> text
            ]
        ]


main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , view = view
        , update = update
        }
