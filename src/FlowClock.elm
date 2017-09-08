import Html exposing (Html, p, text, button, div, h1, span, input, Attribute)
import Time exposing (Time, second, millisecond)
import Html.Events exposing (onClick, onInput)
import Html.Attributes exposing (..)


main : Program Never Model Msg
main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }



-- MODEL

type Logged = Yes | No
type State = Running | Stopped | Disrupted
type Concentration = JustStarted | GettingThere | WorkingOnIt | OnFire | Ommmmm

type alias User = {name : String, hourlySalary : Int}

type alias Model = {tick : Time, runningSeconds : Int, state : State, concentration : Concentration, user : User, logged: Logged}


init : (Model, Cmd Msg)
init =
  ({tick = 0, runningSeconds = 0, state = Stopped, concentration = JustStarted, user = {name = "", hourlySalary = 0}, logged = No}, Cmd.none)



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
        newModel = {model | state = Disrupted}
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
        Disrupted ->
          (newModel, Cmd.none)


showButton : Model -> Html Msg
showButton model =
    case model.state of
      Running ->
        button [onClick Stop, class "btn-common btn-running"] [text "Stop"]
      Stopped ->
        button [onClick Start, class "btn-common btn-stopped"] [text "Start"]
      Disrupted ->
        button [onClick Start, class "btn-common btn-disrupted"] [text "Start"]

zoneClass : State -> String
zoneClass state=
  case state of
    Running ->
      "productivity-block"
    Stopped ->
      "productivity-block"
    Disrupted ->
      "productivity-block productivity-disrupted"
showProductivity : Model -> Html Msg
showProductivity model =
  if model.state == Stopped then
    p [] []
  else
    case model.concentration of
      JustStarted ->
        p [class <| zoneClass model.state] [ text "Zone 1: Just started"]
      GettingThere ->
        p [class <| zoneClass model.state] [ text "Zone 2: Getting there"]
      WorkingOnIt ->
        p [class <| zoneClass model.state] [ text "Zone 3: Working on it"]
      OnFire ->
        p [class <| zoneClass model.state] [ text "Zone 4: On fire"]
      Ommmmm ->
        p [class <| zoneClass model.state] [ text "Zone 5: Ommmmm"]


showTime : Model -> Html Msg
showTime model =
  if model.state == Stopped then
      p [] []
  else
    let
      minutes = model.runningSeconds // 60
      seconds = rem model.runningSeconds 60
    in
      div []
      [ p [] [ span [ class "timer-label" ] [text "Time worked without disruptance: "]]
      , p [class "timer" ]
        [ span [] [text (String.padLeft 2 '0' <| toString minutes)]
        , span [] [text ":"]
        , span [] [text (String.padLeft 2 '0' <| toString seconds)]
        ]
      ]


showUserInfo : Model -> Html Msg
showUserInfo model =
    let
        userGetter = \x -> x.user
    in
      if model.state == Stopped then
        div [class "user-info-initial" ]
          [ input [ placeholder "Name", onInput Name] []
          , input [ placeholder "Salary", onInput Salary] []
          ]
      else
        div [class "user-info-running" ]
          [ div []
              [ p []
                [ span [] [text "Name: "]
                , span [] [text (.name <| userGetter model)]
                , span [] [text " "]
                , span [] [text "Salary: "]
                , span [] [text (toString <| .hourlySalary <| userGetter model)]
                ]
              ]
          ]


showBlame : State -> Html Msg
showBlame state =
    case state of
      Running ->
        p [class "blame-hidden"] []
      Stopped ->
        p [class "blame-hidden"] []
      Disrupted ->
        p [class "blame-visible"] [text "Now you did it!"]


-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
  Time.every second Tick


-- VIEW

flowclockClass : Concentration -> String
flowclockClass concentration =
  case concentration of
    JustStarted ->
      "flowclock-common just-started"
    GettingThere ->
      "flowclock-common getting-there"
    WorkingOnIt ->
      "flowclock-common working-on-it"
    OnFire ->
      "flowclock-common on-fire"
    Ommmmm ->
      "flowclock-common ommmmm"

foobar: Model -> Html Msg
foobar model =
  case model.logged of
    No ->
      div [] [text "Kirjaudu sisään"]
    Yes ->
      div [ class <| flowclockClass model.concentration]
        [ h1 [style [("text-align", "center")]] [ text "Flowclock - Productivity Counter" ]
        , ( showUserInfo model)
        , ( showProductivity model)
        , ( showTime model)
        , ( showBlame model.state)
        , div [] [( showButton model)]
        ]

view : Model -> Html Msg
view model =
    let
      foo = turns (Time.inMinutes model.tick)
    in
      foobar model
