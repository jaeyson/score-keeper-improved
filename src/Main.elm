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
    { init = "Hello World"
    , update = \_ m -> m
    , view = \m -> Html.text m
    }
