port module AnimationButtonPort exposing (main)

import Browser
import Html exposing (Html)
import Html.Attributes
import Html.Events


port show : Int -> Cmd msg


port enableRaf : () -> Cmd msg


port raf : (() -> msg) -> Sub msg


type Model
    = Idle
    | Animating Int String


init : () -> ( Model, Cmd Msg )
init () =
    ( Idle, Cmd.none )


type Msg
    = Start
    | Increment
    | Text String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Start ->
            ( Animating 0 "", Cmd.batch [ show 0, enableRaf () ] )

        Increment ->
            case model of
                Idle ->
                    ( model, Cmd.none )

                Animating n s ->
                    let
                        count =
                            n + 1
                    in
                    ( Animating count s, show count )

        Text text ->
            case model of
                Idle ->
                    ( model, Cmd.none )

                Animating n _ ->
                    ( Animating n text, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    case model of
        Idle ->
            Sub.none

        Animating _ _ ->
            raf (always Increment)


view : Model -> Html Msg
view model =
    case model of
        Idle ->
            Html.button [ Html.Events.onClick Start ] [ Html.text "Start" ]

        Animating n s ->
            Html.div []
                [ Html.text <| "view: " ++ String.fromInt n ++ " "
                , Html.input [ Html.Attributes.value s, Html.Events.onInput Text ] []
                ]


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
