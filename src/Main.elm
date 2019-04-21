module Main exposing (..)
import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Markdown


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

init : Model
init =
  { players = []
  , name = ""
  , playerId = Nothing
  , plays = []
  }

-- Update

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
    _ ->
      model

-- View

view : Model -> Html Msg
view model =
  div [ class "scoreBoard" ]
  [ h1 []
      [ text "Score Keeper App" ]
  , playerForm model
  ]


playerForm : Model -> Html Msg
playerForm model =
  Html.form [ onSubmit Save ]
    [ input [ type_ "text"
            , placeholder "Add/Edit Player..."
            , onInput Input
            , value model.name]
        []
    , button [ type_ "submit" ]
        [ text "Save" ]
    , button [ type_ "button", onClick Cancel ]
        [ text "Cancel" ]
    ]

{--

Planning Basketball Scorekeeper App

Model

TODO: Model's Shape

```
Model =
  { players : List Player
  , playerName : String
  , playerId : MaybeInt
  , plays : List Play
  }
```

---

TODO: Player Shape

```
Player =
  { id : Int
  , name : String
  , points : Int}
```

---

TODO: Play Shape

```
Play =
  { id : Int
  , playerId : Int
  , name : String
  , points : Int
  }
```

---

TODO: Initial Model

---

Update
What can be done in our app?

* Edit
* Score
* Input
* Save
* Cancel
* DeletePlay

---

TODO: Create Message Union Type

---

TODO: Create update function(s)

---

View
What are the logical sections/groupings of our UI?

* main view (outermost function)
  * player section
    * player list header
      * player list
        * player
      * point total
    * player form
    * play section
      * play list header
      * play list
        * play

---

TODO: Create functions for each of the above
--}



