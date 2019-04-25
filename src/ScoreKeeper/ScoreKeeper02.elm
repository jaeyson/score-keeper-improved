module Main exposing (..)
import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Markdown
import Debug exposing (log)


-- Main
main =
  Browser.sandbox
    { init = init
    , update = update
    , view = view
    }



-- Model

type alias ScoreHistory =
  { id : Int
  , name : String
  , pointsScored : Int
  , uniqueId : Int
  }

type alias Player =
  { name : String
  , id : Int
  , totalPointsScored : Int
  }

type alias Model =
  { players : List Player
  , name : String
  , scoreHistory : List ScoreHistory
  , playerId : Maybe Int
  }

init : Model
init =
  { players = []
  , name = ""
  , scoreHistory = []
  , playerId = Nothing
  }



-- Update

type Msg
  = Save
  | Cancel
  | Input String

update : Msg -> Model -> Model
update msg model =
  case msg of
    Cancel ->
      { model | name = "" }
    Input name->
      { model | name = name }
    Save ->
      case (String.isEmpty model.name) of
        True ->
          model -- Leave this for now...
        False ->
          save model

save : Model -> Model
save model =
  case model.playerId of
    Just id ->
      model -- Leave this for now...
    Nothing ->
      add model

add : Model -> Model
add model =
  let
      addPlayer =
        Player model.name (List.length model.players) 0
      newPlayers =
        addPlayer :: model.players
  in
      { model | players = newPlayers
              , name = ""
      }

-- View

view : Model -> Html Msg
view model =
  div [ class "row" ]
    [ div [ class "col" ]
        [ h1 [] [ text "Score Keeper" ]
        , header []
            [ div [] [ text "Name" ]
            , div [] [ text "Points" ]
            ]
        , playerSection model
        , playerForm model
        ]
    , div [ class "col" ] [ debugSection model ]
    ]

playerSection : Model -> Html Msg
playerSection model =
  model.players
    |> List.map player
    |> ul []

player : Player -> Html Msg
player playerModel =
  li []
    [ i [ class "far"
        , class "fa-trash-alt"
        ]
        []
    , i [ class "far"
        , class "fa-edit"
        ]
        []
    , span [ class "player-name" ]
        [ text playerModel.name ]
    , span []
        [ text (String.fromInt playerModel.totalPointsScored) ]
    ]

playerForm : Model -> Html Msg
playerForm model =
  Html.form [ onSubmit Save ]
    [ input [ type_ "text"
            , placeholder "Enter player name..."
            , onInput Input
            , value model.name
            ]
        []
    , button [ type_ "submit" ] [ text "Save" ]
    , button [ type_ "submit", onClick Cancel ] [ text "Cancel" ]
    ]

debugSection : Model -> Html Msg
debugSection model =
  div []
    [ h3 [] [ text "Model" ]
    , div [] [ text (Debug.toString model) ]
    , h3 [] [ text "Name" ]
    , div [] [ text (Debug.toString model.name) ]
    , h3 [] [ text "Players" ]
    , div [] [ text (Debug.toString model.players) ]
    , h3 [] [ text "Player Id" ]
    , div [] [ text (Debug.toString model.playerId) ]
    , h3 [] [ text "Score History" ]
    , div [] [ text (Debug.toString model.scoreHistory) ]
    ]

