module Quotes exposing (..)

import Browser
import Html exposing (Html, blockquote, button, cite, div, h2, p, text)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)
import Http
import Json.Decode exposing (Decoder, field, int, map4, string)


type Model
    = Failure
    | Loading
    | Success Quote


type alias Quote =
    { quote : String
    , source : String
    , author : String
    , year : Int
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( Loading, getRandomQuote )


type Msg
    = MoarPlease
    | GotQuote (Result Http.Error Quote)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg _ =
    case msg of
        MoarPlease ->
            ( Loading, getRandomQuote )

        GotQuote res ->
            case res of
                Ok quote ->
                    ( Success quote, Cmd.none )

                Err _ ->
                    ( Failure, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


getRandomQuote : Cmd Msg
getRandomQuote =
    Http.get
        { url = "https://elm-lang.org/api/random-quotes"
        , expect = Http.expectJson GotQuote quoteDecoder
        }


quoteDecoder : Decoder Quote
quoteDecoder =
    map4 Quote
        (string |> field "quote")
        (string |> field "source")
        (string |> field "author")
        (int |> field "year")


viewQuote : Model -> Html Msg
viewQuote model =
    case model of
        Failure ->
            div []
                [ p [] [ text "I could not load a random quote for some reason." ]
                , button [ onClick MoarPlease ] [ text "Try Again!" ]
                ]

        Loading ->
            text "Loading ..."

        Success quote ->
            div []
                [ button [ style "letter-spacing" "0.3em", onClick MoarPlease ] [ text "Moar!!!!!!" ]
                , blockquote [] [ text quote.quote ]
                , p [ style "text-align" "right" ]
                    [ text "- "
                    , cite [] [ text quote.source ]
                    , text
                        (" by "
                            ++ quote.author
                            ++ " ("
                            ++ String.fromInt quote.year
                            ++ ")"
                        )
                    ]
                ]


view : Model -> Html Msg
view model =
    div
        [ style "margin" "20px"
        , style "padding" "12px"
        ]
        [ h2 [] [ text "Random Quote" ]
        , viewQuote model
        ]


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
