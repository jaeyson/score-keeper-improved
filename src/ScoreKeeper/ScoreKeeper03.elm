module ScoreKeeper exposing (..)

type alias Model =
  { name : String
  , players : List Player
  }

type alias Player =
  { id : Int
  , name : String
  }

init =
  { name = "John Smith"
  , players = [ { id = 1, name = "John Smith" }
              , { id = 0, name = "John Doe" }
              ]
  }

setPlayerName : String -> Player -> Player
setPlayerName newName playerRecord =
  { playerRecord | name = newName }


result model =
  model
  |> setPlayerName "Clint Eastwood"

