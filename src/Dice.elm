module Dice exposing (..)

import Browser
import Element as E
import Html exposing (Html, button, h1, text)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)
import Random


type alias Model =
    { dieFace6 : Int
    , dieFace20 : Int
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model 6 20, Cmd.none )


type Msg
    = Roll6
    | Roll20
    | NewFace6 Int
    | NewFace20 Int


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Roll6 ->
            ( model
            , Random.generate NewFace6 (Random.int 1 6)
            )

        Roll20 ->
            ( model
            , Random.generate NewFace20 (Random.int 1 20)
            )

        NewFace6 newFace ->
            ( { model | dieFace6 = newFace }
            , Cmd.none
            )

        NewFace20 newFace ->
            ( { model | dieFace20 = newFace }
            , Cmd.none
            )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


columnStyle : List (E.Attribute msg)
columnStyle =
    [ E.spacing 16
    , E.padding 8
    ]


view : Model -> Html Msg
view model =
    E.layout []
        (E.row [ E.centerX, E.centerY ]
            [ E.column
                columnStyle
                [ E.html
                    (h1 [ style "align-self" "center" ]
                        [ text (String.fromInt model.dieFace6) ]
                    )
                , E.html (button [ onClick Roll6 ] [ text "Roll" ])
                ]
            , E.column
                columnStyle
                [ E.html
                    (h1 [ style "align-self" "center" ]
                        [ text (String.fromInt model.dieFace20) ]
                    )
                , E.html (button [ onClick Roll20 ] [ text "Roll" ])
                ]
            ]
        )


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
