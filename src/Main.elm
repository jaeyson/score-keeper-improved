module Main exposing (..)
{--}
import Browser exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Debug exposing (..)
{--}


-- Main

{--}
main =
  Browser.sandbox
    { init = init
    , update = update
    , view = view
    }
{--}



-- Model

type alias Model =
  { name : String
  , players : List Player
  }

type alias Player =
  { id : Int
  , name : String
  }

init : Model
init =
  { name = ""
  , players = []
  }

{--
init : Model
init =
  { name = "John Smith"
  , players = [ { id = 1, name = "John Smith" }
              , { id = 0, name = "John Doe" }
              ]
  }
--}



-- Update

{--}
type Msg
  = Save
  | Clear
  | Input String

update : Msg -> Model -> Model
update msg model =
  case msg of
    Clear ->
      { model | name = "" }
    Input name ->
      { model | name = name }
    Save ->
      case (String.isEmpty model.name) of
        True ->
          model
        False ->
          save model
--}

save : Model -> Model
save model =
  let
      newPlayer =
        Player (List.length model.players) model.name
      allPlayers =
        newPlayer :: model.players
  in
      { model | players = allPlayers
              , name = ""
      }

edit : Int -> String -> List Player
edit playerId newName =
  List.map (\editPlayer ->
    case ( editPlayer.id == playerId ) of
      True ->
        setPlayerName newName editPlayer
      False ->
        editPlayer
    ) init.players

setPlayerName : String -> Player -> Player
setPlayerName newName playerRecord =
  { playerRecord | name  = newName }



-- View

{--}
view : Model -> Html Msg
view model =
  div [ class "row" ]
    [ div [ class "col" ]
        [ h3 [] [ text "Name" ]
        , playerSection model
        , playerInput model
        ]
    , div [ class "col" ]
        [ debugSection model ]
    ]

playerSection : Model -> Html Msg
playerSection model =
  model.players
  |> List.map player
  |> ul []

player : Player -> Html Msg
player playerModel =
  li []
    [ i [ class "far fa-trash-alt" ] []
    , i [ class "far fa-edit" ] []
    , span [ class "player-name" ] [text (playerModel.name) ]
    , span [] [ text "score here" ]
    ]

playerInput : Model -> Html Msg
playerInput model =
  Html.form [ onSubmit Save ]
    [ input [ type_ "text"
            , onInput Input
            , placeholder "Enter Player..."
            , value model.name
            ]
        []
    , button [ type_ "submit" ]
        [ text "Save" ]
    , button [ type_ "button" , onClick Clear ]
        [ text "Cancel" ]
    ]

debugSection : Model -> Html Msg
debugSection model =
  div []
    [ h3 [] [ text "Name" ]
    , h3 [] [ text (Debug.toString model.name) ]
    , h3 [] [ text "Players" ]
    , h3 [] [ text (Debug.toString model.players) ]
    ]
{--}

