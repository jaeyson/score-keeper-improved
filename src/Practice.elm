module Practice exposing (..)
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
  , score : List ScoreHistory
  }

type alias Player =
  { id : Int
  , name : String
  , totalPointsScored : Int
  }

type alias ScoreHistory =
  { name : String
  , points : Int
  }

init : Model
init =
  { name = ""
  , players = []
  , id = Nothing
  , score = []
  }



-- Update

type Msg
  = Input String
  | ClearButton
  | SaveButton
  | EditPlayer String Int
  | DeletePlayer String
  | ScoreButton Int Int
  | ResetPlayerScore Int

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

    EditPlayer playerName playerId->
      { model | name = playerName
              , id =  Just playerId
      }

    DeletePlayer playerName ->
      delete model playerName

    ScoreButton points playerId ->
      score model points playerId

    ResetPlayerScore playerId ->
      resetPlayerScore model playerId

save model =
  case model.id of
    Just playerId ->
      edit model playerId
    Nothing ->
      add model
  {--
  let
      isDuplicateContent =
        model.contents
        |> List.map .content
        |> List.member model.input
  in
      case isDuplicateContent of
        True ->
          edit model

        False ->
          add model
  --}

add model =
  let
      newPlayer =
        Player (List.length model.players) model.name 0

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
delete model playerName =
  let
      result =
        model.players
        |> List.filter (\deletePlayer -> deletePlayer.name /= playerName)
  in
      { model | players = result
              , name = ""
              , id = Nothing
      }

score model points playerId =
  let
      result =
        model.players
        |> List.map (\scorePlayer ->
            case (scorePlayer.id == playerId) of
              True ->
                addPlayerScore scorePlayer points
              False ->
                scorePlayer
          )
  in
      { model | players = result
              , name = ""
              , id = Nothing
      }

-- Helper Function
addPlayerScore model points =
  { model | totalPointsScored = model.totalPointsScored + points
  }

resetPlayerScore model playerId =
  let
      result =
        model.players
        |> List.map (\scorePlayer ->
            case (scorePlayer.id == playerId) of
              True ->
                { scorePlayer | totalPointsScored = 0 }
              False ->
                scorePlayer
          )
  in
      { model | players = result
              , name = ""
              , id = Nothing
      }

  {--
  let
      result =
        model.players
        |> List.map (\scorePlayer ->
            if scorePlayer.id == scorePlayerId then
              { scorePlayer | totalPointsScored = scorePlayer.totalPointsScored + points }
            else
              scorePlayer
          )
  in
      { model | players = result
              , name = ""
              , id = Nothing
      }
  --}

-- View

view : Model -> Html Msg
view model =
  div []
    [ div [ class "row" ]
        [ div [ class "col" ]
            [ h3 [ class "header-player" ]
                [ span [] [ text "Name" ]
                , span [] [ text "Points" ]
                ]
            , playerSectionLeft model
            , playerInputLeft model
            ]
        , div [ class "col" ]
            [ h3 [ class "header-player" ]
                [ span [] [ text "Name" ]
                , span [] [ text "Points" ]
                ]
            , playerSectionRight model
            , playerInputRight model
            ]
        ]
    , div [ class "row" ]
        [ div [ class "col" ]
            [ debugSection model ]
        ]
    ]

playerSectionLeft : Model -> Html Msg
playerSectionLeft model =
  model.players
  |> List.map playerLeft
  |> ul []

playerSectionRight : Model -> Html Msg
playerSectionRight model =
  model.players
  |> List.map playerRight
  |> ul []

playerLeft : Player -> Html Msg
playerLeft playerModel =
  li []
    [ i [ class "fa fa-trash-alt"
        , onClick (DeletePlayer playerModel.name)
        ]
        []
    , i [ class "fa fa-edit"
        , onClick (EditPlayer playerModel.name playerModel.id)
        ]
        []
    , span [ class "player-name"
            , onClick (EditPlayer playerModel.name playerModel.id)
            ]
        [text (playerModel.name) ]
    , span [ class "points-group" ]
        [ button [ type_ "button"
                  , onClick (ScoreButton -1 playerModel.id)
                  ]
            [ text "-" ]
        , button [ type_ "button"
                  , onClick (ScoreButton 1 playerModel.id)
                  ]
            [ text "1" ]
        , button [ type_ "button"
                  , onClick (ScoreButton 2 playerModel.id)
                  ]
            [ text "2" ]
        , button [ type_ "button"
                  , onClick (ScoreButton 3 playerModel.id)
                  ]
            [ text "3" ]
        , button [ type_ "button"
                  , onClick (ResetPlayerScore playerModel.id)
                  ]
            [ text "R" ]
        ]
    , span [ class "player-score" ]
        [ text (String.fromInt playerModel.totalPointsScored) ]
    ]

playerRight : Player -> Html Msg
playerRight playerModel =
  li []
    [ i [ class "fa fa-trash-alt"
        , onClick (DeletePlayer playerModel.name)
        ]
        []
    , i [ class "fa fa-edit"
        , onClick (EditPlayer playerModel.name playerModel.id)
        ]
        []
    , span [ class "player-name"
            , onClick (EditPlayer playerModel.name playerModel.id)
            ]
        [text (playerModel.name) ]
    , span [ class "points-group" ]
        [ button [ type_ "button"
                  , onClick (ScoreButton -1 playerModel.id)
                  ]
            [ text "-" ]
        , button [ type_ "button"
                  , onClick (ScoreButton 1 playerModel.id)
                  ]
            [ text "1" ]
        , button [ type_ "button"
                  , onClick (ScoreButton 2 playerModel.id)
                  ]
            [ text "2" ]
        , button [ type_ "button"
                  , onClick (ScoreButton 3 playerModel.id)
                  ]
            [ text "3" ]
        , button [ type_ "button"
                  , onClick (ResetPlayerScore playerModel.id)
                  ]
            [ text "R" ]
        ]
    , span [ class "player-score" ]
        [ text (String.fromInt playerModel.totalPointsScored) ]
    ]

playerInputLeft : Model -> Html Msg
playerInputLeft model =
  Html.form [ onSubmit SaveButton ]
    [ input [ type_ "text"
            , onInput Input
            , placeholder "Enter Player..."
            , value model.name
            ]
        []
    , button [ type_ "submit" ]
        [ text "Save" ]
    , button [ type_ "button"
              , class "button-cancel"
              , onClick ClearButton ]
        [ text "Cancel" ]
    ]

playerInputRight : Model -> Html Msg
playerInputRight model =
  Html.form [ onSubmit SaveButton ]
    [ input [ type_ "text"
            , onInput Input
            , placeholder "Enter Player..."
            , value model.name
            ]
        []
    , button [ type_ "submit" ]
        [ text "Save" ]
    , button [ type_ "button"
              , class "button-cancel"
              , onClick ClearButton ]
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

