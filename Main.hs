{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE BangPatterns #-}
{-# LANGUAGE ViewPatterns #-}
module Main where

--import Data.Maybe
--import qualified Text.Regex.TDFA.ByteString as TDFA
--import qualified Text.Regex.TDFA.Common as TDFA (CompOption(..))
--import qualified Text.Regex.PCRE.ByteString as PCRE
import qualified Text.Regex.TDFA.Text as TDFAT
--import qualified Data.ByteString.Char8 as B
--import Data.ByteString.Char8 (ByteString)
--import Data.Thyme
--import Data.Thyme.Clock.POSIX
--import Data.AdditiveGroup ((^-^))
import Text.Regex.Base.RegexLike
import Criterion.Main
import Control.DeepSeq
import Control.Parallel.Strategies
import qualified Data.Text as T
import Data.Text (Text)

-- ICU
--import qualified Data.Text.ICU as ICU
--import qualified Data.Text.IO as T
--import Data.Text.Foreign
--import Data.Array
--import System.IO.Unsafe

--input :: Int -> ByteString
--input n = B.unlines $ Prelude.replicate n "Hello world foo=123 whereas bar=456 Goodbye"

inputText :: Int -> Text
inputText n = T.unlines $ Prelude.replicate n "Hello world foo=123 whereas bar=456 Goodbye"

--regexString :: ByteString
--regexString = "foo=([0-9]+)"

regexText :: Text
regexText = "foo=([0-9]+)"

--regexTDFA :: TDFA.Regex
--regexTDFA = fromRight $ TDFA.compile defaultCompOpt defaultExecOpt regexString

regexTDFAT :: TDFAT.Regex
regexTDFAT = fromRight $ TDFAT.compile defaultCompOpt defaultExecOpt regexText

--regexPCRE :: IO PCRE.Regex
--regexPCRE = fromRight <$> PCRE.compile defaultCompOpt defaultExecOpt regexString

--regexICU :: ICU.Regex
--regexICU = ICU.regex [ICU.Multiline] regexText

fromRight (Right a) = a

main = textBench (inputText 1) (inputText 1000) (inputText 1000000) regexTDFAT

textBench :: Text -> Text -> Text -> TDFAT.Regex -> IO ()
textBench (force -> !it1) (force -> !it1000) (force -> !it1000000) !rTDFAT = defaultMain
  [ bgroup "reverse"
    [ bench "1"      $ nf T.reverse (it1)
    , bench "1000"   $ nf T.reverse (it1000)
    , bench "1000000" $ nf T.reverse (it1000000)
    ]
  , bgroup "regex-tdfa-text"
    [ bench "1"      $ nf force ((map (matchAll rTDFAT) (T.lines $ it1) `using` parList rdeepseq))
    , bench "1000"   $ nf force ((map (matchAll rTDFAT) (T.lines $ it1000) `using` parList rdeepseq)) 
    , bench "1000000" $ nf force ((map (matchAll rTDFAT) (T.lines $ it1000000) `using` parList rdeepseq))
    ]
  ]



--  , bgroup "regex-tdfa"
--    [ bench "1"      $ nf (uncurry matchAll) (regexTDFA, input 1)
--    , bench "1000"   $ nf (uncurry matchAll) (regexTDFA, input 1000)
--    , bench "100000" $ nf (uncurry matchAll) (regexTDFA, input 1000000)
--    ]
--  , bgroup "regex-pcre"
--    [ bench "1"      $ nfIO (flip matchAll (input 1)       <$> regexPCRE)
--    , bench "1000"   $ nfIO (flip matchAll (input 1000)    <$> regexPCRE)
--    , bench "100000" $ nfIO (flip matchAll (input 1000000) <$> regexPCRE)
--    ]
--  , bgroup "text-icu"
--    [ bench "1"      $ nf (show . uncurry ICU.find) (regexICU, (inputText 1))
--    , bench "100"    $ nf (show . uncurry ICU.find) (regexICU, (inputText 1000))
--    , bench "100000" $ nf (show . uncurry ICU.find) (regexICU, (inputText 100000))
--    ]