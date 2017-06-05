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

type State = Running | Stopped | Disrupted
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


buttonStyles : State -> Attribute msg
buttonStyles state =
  case state of
    Running ->
      style
        [ ("display", "block")
        , ("margin", "auto")
        , ("font-size", "50px")
        , ("color", "black")
        , ("background-color", "salmon")
        , ("border", "2px solid black")
        , ("border-radius", "50px")
        , ("margin-top", "10px")
        , ("margin-botton", "20px")
        ]
    Stopped ->
      style
        [ ("display", "block")
        , ("margin", "auto")
        , ("font-size", "50px")
        , ("color", "black")
        , ("background-color", "#C7E8AC")
        , ("border", "2px solid black")
        , ("border-radius", "50px")
        , ("margin-top", "10px")
        , ("margin-botton", "20px")
        ]
    Disrupted ->
      style
        [ ("display", "block")
        , ("margin", "auto")
        , ("font-size", "50px")
        , ("color", "black")
        , ("background-color", "#C7E8AC")
        , ("border", "2px solid black")
        , ("border-radius", "50px")
        , ("margin-top", "10px")
        , ("margin-botton", "20px")
        ]

showButton : Model -> Html Msg
showButton model =
    case model.state of
      Running ->
        button [onClick Stop, buttonStyles model.state] [text "Stop"]
      Stopped ->
        button [onClick Start, buttonStyles model.state] [text "Start"]
      Disrupted ->
        button [onClick Start, buttonStyles model.state] [text "Start"]

zoneStyles : State -> Attribute  msg
zoneStyles state=
  case state of
    Running ->
      style
        [ ("font-size", "24px")
        , ("background-color", "teal")
        , ("text-align", "center")
        , ("margin", "0 50px")
        ]
    Stopped ->
      style
        [ ("font-size", "24px")
        , ("background-color", "teal")
        , ("text-align", "center")
        , ("margin", "0 50px")
        ]
    Disrupted ->
      style
        [ ("font-size", "24px")
        , ("background-color", "red")
        , ("text-align", "center")
        , ("margin", "0 50px")
        ]
showProductivity : Model -> Html Msg
showProductivity model =
  if model.state == Stopped then
    p [] []
  else
    case model.concentration of
      JustStarted ->
        p [zoneStyles model.state] [ text "Zone 1: Just started"]
      GettingThere ->
        p [zoneStyles model.state] [ text "Zone 2: Getting there"]
      WorkingOnIt ->
        p [zoneStyles model.state] [ text "Zone 3: Working on it"]
      OnFire ->
        p [zoneStyles model.state] [ text "Zone 4: On fire"]
      Ommmmm ->
        p [zoneStyles model.state] [ text "Zone 5: Ommmmm"]


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
      [ p [] [ span [ style [("text-align", "center"),("display", "block")]] [text "Time worked without disruptance: "]]
      , p [class "timer", style [("font-size", "42px"), ("text-align", "center")]]
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
        div [class "user-info", style [("text-align", "center")]]
          [ input [ placeholder "Name", onInput Name] []
          , input [ placeholder "Salary", onInput Salary] []
          ]
      else
        div [style [("display", "block"), ("text-align", "center")]]
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


blameStyle : Attribute msg
blameStyle =
    style
      [ ("text-align", "center")
      , ("display", "block")
      , ("border", "2px solid black")
      , ("border-radius", "30px")
      , ("background-color", "red")
      , ("height", "36px")
      , ("line-height", "36px")
      , ("margin", "0px 100px 0px 100px")
      , ("font-size", "24px")
      ]


showBlame : State -> Html Msg
showBlame state =
    case state of
      Running ->
        p [style [("display", "none")]] []
      Stopped ->
        p [style [("display", "none")]] []
      Disrupted ->
        p [blameStyle] [text "Now you did it!"]


-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
  Time.every second Tick



-- VIEW

flowclockStyle : Concentration -> Attribute msg
flowclockStyle concentration =
  case concentration of
    JustStarted ->
      style
        [ ("display", "block")
        , ("width", "500px")
        , ("margin", "auto")
        , ("background-color", "lightgrey")
        , ("padding-bottom", "5px")
        ]
    GettingThere ->
      style
        [ ("display", "block")
        , ("width", "500px")
        , ("margin", "auto")
        , ("background-color", "lightgoldenrodyellow")
        , ("padding-bottom", "5px")
        ]
    WorkingOnIt ->
      style
        [ ("display", "block")
        , ("width", "500px")
        , ("margin", "auto")
        , ("background-color", "lightgreen")
        , ("padding-bottom", "5px")
        ]
    OnFire ->
      style
        [ ("display", "block")
        , ("width", "500px")
        , ("margin", "auto")
        , ("background-color", "limegreen")
        , ("padding-bottom", "5px")
        ]
    Ommmmm ->
      style
        [ ("display", "block")
        , ("width", "500px")
        , ("margin", "auto")
        , ("background-color", "darkgreen")
        , ("padding-bottom", "10px")
        ]

view : Model -> Html Msg
view model =
    let
      foo = turns (Time.inMinutes model.tick)
    in
      div [ class "flowclock", flowclockStyle model.concentration]
        [ h1 [style [("text-align", "center")]] [ text "Flowclock - Productivity Counter" ]
        , ( showUserInfo model)
        , ( showProductivity model)
        , ( showTime model)
        , ( showBlame model.state)
        , div [] [( showButton model)]
        ]
