import Html

{--
type alias User =
  { name : String
  , bio : String

hasBio : User -> String
hasBio user =
  case (String.length user.bio > 15) of
    True -> "True"
    False -> "False"

type MaybeAge
  = Age Int
  | InvalidInput

toAge : String -> MaybeAge \
toAge userInput = \
  case (String.toInt userInput) of \
    Just int -> \
      Age int \
    Nothing -> \
      InvalidInput \

toAge : String -> String
toAge userInput =
  case (String.toInt userInput) of
    Just int ->
      "Age " ++ String.fromInt int
    Nothing ->
      "InvalidInput"

type MaybePost \
  = Post { title : String, content : String  } \
  | NoTitle \
  | NoContent \
  | Nothing \

toPost : String -> String -> MaybePost \
toPost title content = \
  case (String.trim title, String.trim content) of \
    ("", "") -> \
      Nothing \
    ("", _) -> \
      NoTitle \
    (_, "") -> \
      NoContent \
    (_, _) -> \
      Post { title = title, content = content } \
--}


main =
  -- (toAge >> Html.text) "24"
  -- (hasBio >> Html.text) {name="Tom", bio="nothing"}

