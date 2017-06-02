import Html exposing (Html, p, text, button, div, h1, span, input)
import Time exposing (Time, second, millisecond)
import Html.Events exposing (onClick, onInput)
import Html.Attributes exposing (placeholder)


main : Program Never Model Msg
main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }



-- MODEL

type State = Running | Stopped | Disturbed
type Concentration = JustStarted | GettingThere | WorkingOnIt | OnFire | Ommmmm

type alias User = {name : String, hourlySalary : Int}

type alias Model = {tick : Time, runningSeconds : Int, state : State, concentration : Concentration, user : User}


init : (Model, Cmd Msg)
init =
  ({tick = 0, runningSeconds = 0, state = Stopped, concentration = JustStarted, user = {name = "", hourlySalary = 0}}, Cmd.none)



-- UPDATE


type Msg
  = Tick Time | Start | Stop | Name String | Salary String


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Tick newTime ->
      let
        newModel = {model | tick = newTime}
      in
        someFunction newModel
    Start ->
      ({model | runningSeconds = 0, state = Running}, Cmd.none)
    Stop ->
      let
        newModel = {model | state = Disturbed}
      in
        someFunction newModel
    Name n ->
      let
        setUserName = \user n -> {user | name = n}
        oldUser = model.user
        updatedUser = setUserName oldUser n
      in
        ({model | user = updatedUser}, Cmd.none)
    Salary s ->
      case String.toInt s of
        Err err->
          (model, Cmd.none)
        Ok s ->
          let
            setUserSalary = \user s -> {user | hourlySalary = s}
            oldUser = model.user
            updatedUser = setUserSalary oldUser s
          in
            ({model | user = updatedUser}, Cmd.none)



updateConcentration : Model -> Model
updateConcentration model =
    if model.runningSeconds <= 5*60 then
        {model | concentration = JustStarted}
    else if model.runningSeconds <= 10*60 then
        {model | concentration = GettingThere}
    else if model.runningSeconds <= 20*60 then
        {model | concentration = WorkingOnIt}
    else if model.runningSeconds <= 30*60 then
        {model | concentration = OnFire}
    else
        {model | concentration = Ommmmm}

someFunction : Model -> (Model, Cmd Msg)
someFunction model =
  let
      state = model.state
      newModel = updateConcentration model

  in
      case state of
        Running ->
          ({newModel | runningSeconds = newModel.runningSeconds + 1}, Cmd.none)
        Stopped ->
          (newModel, Cmd.none)
        Disturbed ->
          (newModel, Cmd.none)


showButton : Model -> Html Msg
showButton model =
    case model.state of
      Running ->
        button [onClick Stop] [text "Stop"]
      Stopped ->
        button [onClick Start] [text "Start"]
      Disturbed ->
        button [onClick Start] [text "Start"]


showProductivity : Model -> Html Msg
showProductivity model =
  if model.state == Stopped then
    p [] []
  else
    case model.concentration of
      _ -> p [] [ text "fufufu"]


showTime : Model -> Html Msg
showTime model =
  if model.state == Stopped then
      p [] []
  else
    let
      minutes = model.runningSeconds // 60
      seconds = rem model.runningSeconds 60
    in
      p []
      [ span [] [text "distufuhaf: "]
      , span [] [text (String.padLeft 2 '0' <| toString minutes)]
      , span [] [text ":"]
      , span [] [text (String.padLeft 2 '0' <| toString seconds)]]


showUserInfo : Model -> Html Msg
showUserInfo model =
    if model.state == Stopped then
      div []
        [ input [ placeholder "Name", onInput Name] []
        , input [ placeholder "Salary", onInput Salary] []
        ]
    else
      div [] []


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
        [ h1 [] [ text "Flowclock - Productivity Counter" ]
        , ( showUserInfo model)
        , ( showProductivity model)
        , ( showTime model)
        , p [] [text (toString model)]
        , p [] [text (toString model.runningSeconds)]
        , ( showButton model)
        , p [] [text (toString model.state)]
        ]
