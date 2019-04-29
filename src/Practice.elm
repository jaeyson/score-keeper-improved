module Practice exposing (..)
import Browser exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


-- Main
main =
  Browser.sandbox
    { init = init
    , update = update
    , view = view
    }



-- Model
type Mode
  = EditMode
  | ViewMode

type alias Content =
  { content : String }

type alias Model =
  { contents : List Content
  , input : String
  , mode : Mode
  }

init : Model
init =
  { contents = []
  , input = ""
  , mode = ViewMode
  }



-- Update

type Msg
  = Input String
  | Clear
  | Add
  | Edit String
  | Delete String

update : Msg -> Model -> Model
update msg model =
  case msg of
    Clear ->
      { model | input = ""
              , mode = ViewMode
      }

    Input value ->
      { model | input = value }

    Add ->
      case (String.isEmpty model.input) of
        True ->
          { model | input = ""
                  , mode = ViewMode
          }
        False ->
          add model

    Edit editValue ->
      { model | input = editValue
              , mode = EditMode
      }

    Delete deleteValue ->
      delete model deleteValue

add model =
  let
      newContent =
        Content model.input
      allContents =
        newContent :: model.contents

      isDuplicateContent =
        model.contents
        |> List.map .content
        |> List.member model.input
  in
      case isDuplicateContent of
        True ->
          { model | input = ""
                  , mode = ViewMode
          }
        False ->
          { model | contents = allContents
                  , input = ""
                  , mode = ViewMode
          }

delete model deleteModel =
  let
      result =
        model.contents
        |> List.filter (\p -> p.content /= deleteModel)
  in
    { model | contents = result
            , input = ""
            , mode = ViewMode
    }

{--
edit model =
  let
      result =
        model.contents
        |> List.map .content
        |> List.filter (\p -> p == model.input)
        |> List.head

  in
      case result of
        Just value ->
          { model | input = value
                  , mode = EditMode
          }
        Nothing ->
          model
--}



-- View

view : Model -> Html Msg
view model =
  div []
    [ contentList model
    , input [ type_ "text"
            , placeholder "enter content..."
            , onInput Input
            , value (if model.input == "" then
                        ""
                      else
                        model.input)
            ]
        []
    , button [ type_ "button", onClick Add ]
        [ text "Add" ]
    , button [ type_ "button", onClick Clear ]
        [ text "Clear" ]
    , debugSection model
    ]

contentList : Model -> Html Msg
contentList model =
  model.contents
  |> List.map lists
  |> ul []

lists : Content -> Html Msg
lists listContent =
  li []
    [ span [ onClick (Delete listContent.content) ]
        [ text "Delete - " ]
    , span [ onClick (Edit listContent.content) ]
        [ text "Edit - " ]
    , span [] [ text listContent.content ]
    ]

debugSection : Model -> Html Msg
debugSection model =
  div []
    [ h3 []
        [ span [] [ text "Input: " ]
        , span [] [ text (Debug.toString model.input) ]
        ]
    , h3 [] [ text "Content: " ]
    , h3 [] [ text (Debug.toString model.contents) ]
    , h3 []
        [ span [] [ text "Mode: " ]
        , span [] [ text (Debug.toString model.mode) ]
        ]

    ]


{--
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
              , { name = "John Doe"
                , id = 1
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

edit : Model -> List Player
edit model =
  model.players
  |> List.map (\editPlayer ->
    case ( editPlayer.name == model.name ) of
      True ->
        setPlayerName model.name editPlayer
      False ->
        editPlayer
  )

setPlayerName : String -> Player -> Player
setPlayerName newName playerRecord =
  { playerRecord | name  = newName }
--}






