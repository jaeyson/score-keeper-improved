module Main exposing (..)
import Browser exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Debug exposing (..)


-- Main

main =
  Browser.sandbox
    { init = init
    , update = update
    , view = view
    }



-- Model

type alias Model =
  { name : String
  , players : List Player
  , id : Maybe Int
  }

type alias Player =
  { id : Int
  , name : String
  }

init : Model
init =
  { name = ""
  , players = []
  , id = Nothing
  }



-- Update

type Msg
  = Input String
  | ClearButton
  | SaveButton
  | EditButton String Int
  | DeleteButton String

update : Msg -> Model -> Model
update msg model =
  case msg of

    ClearButton ->
      { model | name = ""
              , id = Nothing
      }

    Input name ->
      { model | name = name
      }

    SaveButton ->
      case (String.isEmpty model.name) of
        True ->
          { model | name = ""
          }

        False ->
          save model

    EditButton playerName playerId->
      { model | name = playerName
              , id =  Just playerId
      }

    DeleteButton deletePlayerName ->
      delete model deletePlayerName

save model =
  case model.id of
    Just playerId ->
      edit model playerId
    Nothing ->
      add model

add model =
  let
      newPlayer =
        Player (List.length model.players) model.name

      allPlayers =
        newPlayer :: model.players
  in
      { model | players = allPlayers
              , name = ""
              , id = Nothing
      }

-- edit model playerId
edit model value =
  let
      result =
        model.players
        |> List.map (\content ->
            case (content.id == value) of
              True ->
                setPlayerName content model.name
              False ->
                content
          )
  in
      { model | players = result
              , name = ""
              , id = Nothing
      }

-- Helper Function
setPlayerName model newName =
  { model | name  = newName
  }

delete : Model -> String -> Model
delete model deletePlayerName =
  let
      result =
        model.players
        |> List.filter (\deleteplayer -> deleteplayer.name /= deletePlayerName)
  in
      { model | players = result
              , name = ""
              , id = Nothing
      }


-- View

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
    [ i [ class "far fa-trash-alt"
        , onClick (DeleteButton playerModel.name)
        ]
        []
    , i [ class "far fa-edit"
        , onClick (EditButton playerModel.name playerModel.id)
        ]
        []
    , span [ class "player-name"
            , onClick (EditButton playerModel.name playerModel.id)
            ]
        [text (playerModel.name) ]
    , span []
        [ text "score here" ]
    ]

playerInput : Model -> Html Msg
playerInput model =
  Html.form [ onSubmit SaveButton ]
    [ input [ type_ "text"
            , onInput Input
            , placeholder "Enter Player..."
            , value model.name
            ]
        []
    , button [ type_ "submit" ]
        [ text "Save" ]
    , button [ type_ "button" , onClick ClearButton ]
        [ text "Cancel" ]
    ]

debugSection : Model -> Html Msg
debugSection model =
  div []
    [ h3 []
        [ text "Name: "
        , text (Debug.toString model.name)
        ]
    , h3 []
        [ text "Players: "
        , text (Debug.toString model.players)
        ]
    , h3 []
        [ text "Id: "
        , text (Debug.toString model.id)
        ]
    ]

