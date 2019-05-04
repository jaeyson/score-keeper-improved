module Forms exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Debug exposing (..)



-- MAIN

main =
  Browser.sandbox
    { init = init
    , update = update
    , view = view
    }



-- MODEL

type alias Model =
  { content : String
  , input : String
  }

init : Model
init =
  { content = ""
  , input = ""
  }



-- Update

type Msg
  = Clear
  | Add
  | Option String

update : Msg -> Model -> Model
update msg model =
  case msg of

    Clear ->
      init

    Add ->
      { model | content = model.input
      }

    Option value ->
      { model | input = value
      }



-- View

view : Model -> Html Msg
view model =
  div []
    [ h1 [] [ text ("Content: " ++ model.content) ]
    , label [ for "content" ]
        [ text "Choose: " ]
    , select [ id "content" ]
        [ option [ value "" ]
            [ text "--Please choose an option--" ]
        , option [ value "dog"
                  ]
            [ text "Dog" ]
        , option [ value "cat" ]
            [ text "Cat" ]
        , option [ value "hamster" ]
            [ text "Hamster" ]
        ]
    , button [ type_ "button"
              , onClick Add
              ]
        [ text "Add" ]
    , button [ type_ "button"
              , onClick Clear
              ]
        [ text "Clear" ]
    , div []
        [ h3 [] [ text ("content: " ++ model.content) ]
        , h3 [] [ text ("input: " ++ model.input) ]
        ]
    ]


