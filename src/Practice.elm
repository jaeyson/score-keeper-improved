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

type alias Content =
  { content : String
  , id : Int
  }

type alias Model =
  { contents : List Content
  , input : String
  , id : Maybe Int
  }

init : Model
init =
  { contents = []
  , input = ""
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
      { model | input = ""
              , id = Nothing
      }

    Input value ->
      { model | input = value
      }

    SaveButton ->
      case (String.isEmpty model.input) of
        True ->
          { model | input = ""
          }
        False ->
          save model

    EditButton editValue editId ->
      { model | input = editValue
              , id = Just editId
      }

    DeleteButton deleteValue ->
      delete model deleteValue

save model =
  case model.id of
    Just value ->
      edit model value
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
      newContent =
        Content model.input (List.length model.contents)

      allContents =
        newContent :: model.contents
  in
      { model | contents = allContents
              , id = Nothing
              , input = ""
      }

edit model value =
      let
          result =
            model.contents
            |> List.map (\content ->
                if content.id == value then
                  { content | content = model.input
                  }
                else
                  content
              )
      in
          { model | contents = result
                  , id = Nothing
                  , input = ""
          }

delete model deleteModel =
  let
      result =
        model.contents
        |> List.filter (\p -> p.content /= deleteModel)
  in
      { model | contents = result
              , input = ""
              , id = Nothing
      }



-- View

view : Model -> Html Msg
view model =
  div []
    [ contentList model
    , input [ type_ "text"
            , placeholder "enter content..."
            , onInput Input
            , value ( case (model.input == "") of
                        True ->
                          ""
                        False ->
                          model.input
                    )
            ]
        []
    , button [ type_ "button", onClick SaveButton ]
        [ text "Add" ]
    , button [ type_ "button", onClick ClearButton ]
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
    [ span [ onClick (DeleteButton listContent.content) ]
        [ text "Delete - " ]
    , span [ onClick (EditButton listContent.content listContent.id) ]
        [ text "Edit - " ]
    , span []
        [ text listContent.content ]
    ]

debugSection : Model -> Html Msg
debugSection model =
  div []
    [ h3 []
        [ span [] [ text "Input: " ]
        , span [] [ text (Debug.toString model.input) ]
        ]
    , h3 []
        [ span [] [ text "ID: " ]
        , span [] [ text (Debug.toString model.id) ]
        ]
    , h3 [] [ text "Content: " ]
    , h3 [] [ text (Debug.toString model.contents) ]
    ]

