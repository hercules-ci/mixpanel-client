{-# LANGUAGE ExistentialQuantification #-}
module MixPanel.Types.TrackData
  ( TrackData(..)
  , Properties
  , mkProperties
  , Token
  ) where

import Data.Aeson      (ToJSON, FromJSON, parseJSON, toJSON, withText, encode, object, (.=))
import Data.Text       (Text)
import qualified Data.ByteString.Base64.Lazy as B64
import Data.Time.Clock.POSIX (POSIXTime)
import GHC.Generics (Generic)
import Servant.API
import Data.String.Conv (toS)

import MixPanel.Types.Core (Token)


data TrackData = TrackData
  { event :: Text
  , properties :: Properties
  } deriving (Generic, ToJSON)


instance ToHttpApiData TrackData where
  toUrlPiece = toS . B64.encode . encode

data Properties = forall a. ToJSON a => Properties
  { token :: Token
  , distinctId :: Maybe Text
  , time :: Maybe POSIXTime
  , ip :: Maybe Text
  , extraProperties :: a
  }

instance ToJSON Properties where
  toJSON Properties{..} = object
    [ "token" .= token
    , "distinct_id" .= distinctId
    ] -- TODO: extraproperties

mkProperties :: ToJSON a => Token -> a -> Properties
mkProperties token extra = Properties
  { token = token
  , distinctId = Nothing
  , time = Nothing
  , ip = Nothing
  , extraProperties = extra
  }