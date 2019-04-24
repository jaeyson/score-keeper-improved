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


type alias Model =
  { players : List Player
  , name : String
  , playerId : Maybe Int
  }

type alias Player =
  { id : Int
  , name : String
  }

init : Model
init =
  { players = []
  , name = ""
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
    Save ->
      case (String.isEmpty model.name) of
        True ->
          model
        False ->
          save model
    Cancel ->
      { model | name = "" }
    Input name ->
      { model | name = name }

save : Model -> Model
save model =
  case model.playerId of
    Just id ->
      model
    Nothing ->
      add model

add : Model -> Model
add model =
  let
      addPlayer =
        Player (List.length model.players) model.name
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
        , playerSection model
        , playerForm model
        ]
    , div [ class "col" ] [ debugSection model ]
    ]

----------------------------------------------------------
--            playerSection
----------------------------------------------------------
playerSection : Model -> Html Msg
playerSection model =
  div []
    [ playerListHeader
    , playerList model
    ]


playerListHeader : Html Msg
playerListHeader =
  header []
    [ div [] [ text "Name" ]
    ]

playerList : Model -> Html Msg
playerList model =
  model.players
    |> List.map player
    |> ul []

player : Player -> Html Msg
player playerModel =
  li []
    [ div []
        [ text playerModel.name ]
    ]
----------------------------------------------------------
--            End of playerSection
----------------------------------------------------------



----------------------------------------------------------
--            playerForm
----------------------------------------------------------
playerForm : Model -> Html Msg
playerForm model =
  Html.form [ onSubmit Save ]
    [ input [ type_ "text"
            , placeholder "Add Player..."
            , onInput Input
            , value model.name
            ]
        []
    , button [ type_ "submit" ] [ text "Save" ]
    , button [ type_ "button"
              , onClick Cancel
              ]
        [ text "Cancel" ]
    ]
----------------------------------------------------------
--            End of playerForm
----------------------------------------------------------



----------------------------------------------------------
--                    Debug
----------------------------------------------------------
debugSection : Model ->  Html Msg
debugSection model =
  section []
    [ div []
        [ h2 [] [ text "Player" ]
        , p [] [ text (Debug.toString model.players) ]
        , h2 [] [ text "Name" ]
        , p [] [ text (Debug.toString model.name) ]
        ]
    ]

{--
-- Main
main =
  Browser.sandbox
    { init = "Hello World"
    , update = \_ m -> m
    , view = \m -> Html.text m
    }
--}
