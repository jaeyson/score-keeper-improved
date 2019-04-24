module Practice exposing (..)


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
  , players = [ { name = "John Smith"
                , id = 0
                }
              ]
  }

add : String -> Model -> Model
add newName model =
  let
      newPlayer =
        Player (List.length model.players) newName

      allPlayers =
        newPlayer :: model.players

      isNameDuplicate =
        init.players
        |> List.map .name
        |> List.member newName
  in
      case isNameDuplicate of
        True ->
          model
        False ->
          { model | players = allPlayers
                  , name = ""
          }



