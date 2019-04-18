module Main exposing (..)
import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)



-- Main


main =
  Browser.sandbox { init = init
                  , view = view
                  , update = update
                  }



