port module AnimationInit exposing (main)

import Browser
import Browser.Events
import Html exposing (Html)
import Html.Attributes
import Html.Events


port show : Int -> Cmd msg


type alias Model =
    { count : Int
    , text : String
    }


init : () -> ( Model, Cmd Msg )
init () =
    ( { count = 0, text = "" }, show 0 )


type Msg
    = Increment
    | Text String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Increment ->
            let
                count =
                    model.count + 1
            in
            ( { model | count = count }, show count )

        Text text ->
            ( { model | text = text }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Browser.Events.onAnimationFrame (always Increment)


view : Model -> Html Msg
view model =
    Html.div []
        [ Html.text <| "view: " ++ String.fromInt model.count ++ " "
        , Html.input [ Html.Attributes.value model.text, Html.Events.onInput Text ] []
        ]


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
