module Login exposing (..)

import Browser
import Element
    exposing
        ( Element
        , centerX
        , centerY
        , column
        , el
        , fill
        , layout
        , maximum
        , padding
        , rgb
        , rgb255
        , spacing
        , text
        , width
        )
import Element.Background as Background
import Element.Font as Font
import Element.Input as Input
import Html exposing (Html)


{-| Main entry point
-}
main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , view = view
        , update = update
        }


{-| Model Record
-}
type alias Model =
    { name : String
    , password : String
    , passwordAgain : String
    }


{-| initialization
-}
init : Model
init =
    Model "" "" ""


{-| Msg controller
-}
type Msg
    = Name String
    | Password String
    | PasswordAgain String


{-| update function
-}
update : Msg -> Model -> Model
update msg model =
    case msg of
        Name name ->
            { model | name = name }

        Password password ->
            { model | password = password }

        PasswordAgain password ->
            { model | passwordAgain = password }


{-| types for validation
-}
type PasswordRequirement
    = Uppercase
    | Lowercase
    | Numeric


type PasswordValidation
    = LessThan8
    | NotMatch
    | NotContain PasswordRequirement
    | Valid


reqToString : PasswordRequirement -> String
reqToString req =
    case req of
        Uppercase ->
            "huruf kapital"

        Lowercase ->
            "huruf kecil"

        Numeric ->
            "angka"


{-| validate and its helpers functions
-}
validateRequirement : String -> Maybe PasswordRequirement
validateRequirement password =
    case
        ( String.any Char.isUpper password
        , String.any Char.isLower password
        , String.any Char.isDigit password
        )
    of
        ( False, _, _ ) ->
            Just Uppercase

        ( _, False, _ ) ->
            Just Lowercase

        ( _, _, False ) ->
            Just Numeric

        _ ->
            Nothing


validate : Model -> PasswordValidation
validate model =
    case validateRequirement model.password of
        Just req ->
            NotContain req

        Nothing ->
            if String.length model.password < 8 then
                LessThan8

            else if model.password /= model.passwordAgain then
                NotMatch

            else
                Valid


{-| view function and its helpers
-}
viewNameInput : String -> Element Msg
viewNameInput name =
    Input.text
        [ width (fill |> maximum 500) ]
        { text = name
        , onChange = Name
        , placeholder =
            Just <|
                Input.placeholder [] <|
                    text "Name"
        , label =
            Input.labelAbove [ Font.color <| rgb 200 200 200 ] <|
                text "Name :"
        }


viewPassword : String -> String -> (String -> msg) -> Element msg
viewPassword teks placeholder toMsg =
    Input.newPassword
        [ width
            (fill |> maximum 500)
        ]
        { text = teks
        , show = False
        , onChange = toMsg
        , placeholder =
            Just <|
                Input.placeholder [] <|
                    text placeholder
        , label =
            Input.labelAbove [ Font.color <| rgb 200 200 200 ] <|
                text (placeholder ++ " :")
        }


viewValidation : Model -> Element msg
viewValidation model =
    let
        err isi =
            el [ Font.color <| rgb 1 0 0 ] <| text isi
    in
    case validate model of
        Valid ->
            el [ Font.color <| rgb 0 1 0 ] <| text "Ok"

        NotContain req ->
            err ("Passwor kurang: " ++ reqToString req)

        LessThan8 ->
            err "Panjang password harus lebih dari 8"

        NotMatch ->
            err "Password tidak cocok"


view : Model -> Html Msg
view model =
    layout [ Background.color <| rgb255 18 18 18 ] <|
        column
            [ centerX
            , centerY
            , spacing 16
            , padding 8
            ]
            [ viewNameInput model.name
            , viewPassword model.password "Password" Password
            , viewPassword model.passwordAgain "Re-enter Password" PasswordAgain
            , viewValidation model
            ]
