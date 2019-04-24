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
      { init = initModel
      , update = update
      , view = view
      }



-- model


type alias Model =
    { players : List Player
    , name : String
    , playerId : Maybe Int
    , plays : List Play
    }


type alias Player =
    { id : Int
    , name : String
    , points : Int
    }


type alias Play =
    { id : Int
    , playerId : Int
    , name : String
    , points : Int
    }


initModel : Model
initModel =
    { players = []
    , name = ""
    , playerId = Nothing
    , plays = []
    }



-- update


type Msg
    = Edit Player
    | Score Player Int
    | Input String
    | Save
    | Cancel
    | DeletePlay Play


update : Msg -> Model -> Model
update msg model =
    case msg of
        Input name ->
            { model | name = name }

        Cancel ->
            { model | name = ""
                    , playerId = Nothing
            }

        Save ->
            if (String.isEmpty model.name) then
                model
            else
                save model

        Score updatePlayer points ->
            score model updatePlayer points

        Edit updatePlayer ->
            { model | name = updatePlayer.name
                    , playerId = Just updatePlayer.id
            }

        DeletePlay updatePlay ->
            deletePlay model updatePlay



deletePlay : Model -> Play -> Model
deletePlay model delPlay =
    let
        newPlays =
            List.filter (\p -> p.id /= delPlay.id) model.plays

        newPlayers =
            List.map
                (\deletePlayer ->
                    if deletePlayer.id == delPlay.playerId then
                        { deletePlayer | points = deletePlayer.points - delPlay.points }
                    else
                        deletePlayer
                )
                model.players
    in
        { model | plays = newPlays
                , players = newPlayers
        }


score : Model -> Player -> Int -> Model
score model scorer points =
    let
        newPlayers =
            List.map
                (\scorePlayer ->
                    if scorePlayer.id == scorer.id then
                        { scorePlayer
                            | points = scorePlayer.points + points
                        }
                    else
                        scorePlayer
                )
                model.players

        scorePlay =
            Play (List.length model.plays) scorer.id scorer.name points
    in
        { model | players = newPlayers
                , plays = scorePlay :: model.plays
        }


save : Model -> Model
save model =
    case model.playerId of
        Just id ->
            edit model id

        Nothing ->
            add model


edit : Model -> Int -> Model
edit model id =
    let
        newPlayers =
            List.map
                (\editPlayer ->
                    if editPlayer.id == id then
                        { editPlayer | name = model.name }
                    else
                        editPlayer
                )
                model.players

        newPlays =
            List.map
                (\editPlay ->
                    if editPlay.playerId == id then
                        { editPlay | name = model.name }
                    else
                        editPlay
                )
                model.plays
    in
        { model
            | players = newPlayers
            , plays = newPlays
            , name = ""
            , playerId = Nothing
        }


add : Model -> Model
add model =
    let
        addPlayer =
            Player (List.length model.players) model.name 0

        newPlayers =
            addPlayer :: model.players
    in
        { model
            | players = newPlayers
            , name = ""
        }



-- view


view : Model -> Html Msg
view model =
    div [ class "scoreboard" ]
        [ h1 [] [ text "Score Keeper" ]
        , playerSection model
        , playerForm model
        , playSection model
        , p []
            [ text (Debug.toString model) ]
        ]


playSection : Model -> Html Msg
playSection model =
    div []
        [ playListHeader
        , playList model
        ]


playListHeader : Html Msg
playListHeader =
    header []
        [ div [] [ text "Plays" ]
        , div [] [ text "Points" ]
        ]


playList : Model -> Html Msg
playList model =
    model.plays
        |> List.map play
        |> ul []


play : Play -> Html Msg
play play_ =
    li []
        [ i
            [ class "remove"
            , onClick (DeletePlay play_)
            ]
            []
        , div [] [ text play_.name ]
        , div [] [ text (String.fromInt play_.points) ]
        ]


playerSection : Model -> Html Msg
playerSection model =
    div []
        [ playerListHeader
        , playerList model
        , pointTotal model
        ]


playerListHeader : Html Msg
playerListHeader =
    header []
        [ div [] [ text "Name" ]
        , div [] [ text "Points" ]
        ]


playerList : Model -> Html Msg
playerList model =
    -- ul []
    --     (List.map player model.players)
    model.players
        |> List.sortBy .name
        |> List.map player
        |> ul []


player : Player -> Html Msg
player player_ =
    li []
        [ i [ class "edit"
            , onClick (Edit player_)
            ]
            []
        , div []
            [ text player_.name ]
        , button
            [ type_ "button"
            , onClick (Score player_ 2)
            ]
            [ text "2pt" ]
        , button
            [ type_ "button"
            , onClick (Score player_ 3)
            ]
            [ text "3pt" ]
        , div []
            [ text (String.fromInt player_.points) ]
        ]


pointTotal : Model -> Html Msg
pointTotal model =
    let
        total =
            List.map .points model.plays
                |> List.sum
    in
        footer []
            [ div [] [ text "Total:" ]
            , div [] [ text (String.fromInt total) ]
            ]


playerForm : Model -> Html Msg
playerForm model =
    Html.form [ onSubmit Save ]
        [ input
            [ type_ "text"
            , placeholder "Add/Edit Player..."
            , onInput Input
            , value model.name
            ]
            []
        , button [ type_ "submit" ] [ text "Save" ]
        , button [ type_ "button", onClick Cancel ] [ text "Cancel" ]
        ]

