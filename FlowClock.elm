import Html exposing (Html, p, text, button, div)
import Time exposing (Time, second, millisecond)
import Html.Events exposing (onClick)


main : Program Never Model Msg
main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }



-- MODEL


type alias Model = {tick : Time, runningSeconds : Int, isRunning : Bool}


init : (Model, Cmd Msg)
init =
  ({tick = 0, runningSeconds = 0, isRunning = False}, Cmd.none)



-- UPDATE


type Msg
  = Tick Time | Start | Stop


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Tick newTime ->
      let
          newModel = {model | tick = newTime}
      in
          someFunction newModel
    Start ->
      ({model | runningSeconds = 0, isRunning = True}, Cmd.none)
    Stop ->
      let
          newModel = {model | isRunning = False}
      in
          someFunction newModel



someFunction : Model -> (Model, Cmd Msg)
someFunction model =
  let
      state = model.isRunning
  in
      if state then
        ({model | runningSeconds = model.runningSeconds + 1}, Cmd.none)
      else
        (model, Cmd.none)

increment_number : Int -> Int
increment_number number =
  if number == 9 then 0 else number + 1

-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
  Time.every second Tick



-- VIEW

view : Model -> Html Msg
view model =
    let
      foo = turns (Time.inMinutes model.tick)
    in
      div []
        [ p [] [text (toString model) ]
        , p [] [text (toString model.runningSeconds)]
        , button [onClick Start] [text "Start"]
        , button [onClick Stop] [text "Stop"]
        , p [] [text (toString model.isRunning)]
        ]
