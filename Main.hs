{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE BangPatterns #-}
{-# LANGUAGE ViewPatterns #-}
{-# LANGUAGE RecordWildCards #-}
module Main where

--import Data.Maybe
--import qualified Text.Regex.TDFA.ByteString as TDFA
--import qualified Text.Regex.TDFA.Common as TDFA (CompOption(..))
--import qualified Text.Regex.PCRE.ByteString as PCRE
import qualified Text.Regex.TDFA.Text as TDFAT
import qualified Text.Regex.TDFA.Common as TDFA
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

import Text.Regex.TDFA.IntArrTrieSet (TrieSet (..))

-- ICU
--import qualified Data.Text.ICU as ICU
--import qualified Data.Text.IO as T
--import Data.Text.Foreign
--import System.IO.Unsafe
--import Data.Array

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

fromRight :: Either a b -> b
fromRight (Right a) = a

matchAllParallelBench :: TDFAT.Regex -> Text -> [MatchArray]
matchAllParallelBench r t = concat (map (matchAll r) (T.lines t) `using` parList rdeepseq)

main :: IO ()
main = textBench (inputText 1) (inputText 1000) (inputText 1000000) regexTDFAT

textBench :: Text -> Text -> Text -> TDFAT.Regex -> IO ()
textBench (force -> !it1) (force -> !it1000) (force -> !it1000000) (force -> !rTDFAT) = defaultMain
  [ bgroup "reverse"
    [ bench "1"       $ nf T.reverse it1
    , bench "1000"    $ nf T.reverse it1000
    , bench "1000000" $ nf T.reverse it1000000
    ]
  , bgroup "regex-tdfa-text parallel"
    [ bench "1"       $ nf (uncurry matchAllParallelBench) (rTDFAT, it1) 
    , bench "1000"    $ nf (uncurry matchAllParallelBench) (rTDFAT, it1000) 
    --, bench "1000000" $ nf (uncurry matchAllParallelBench) (rTDFAT, it1000000) 
    ]
  , bgroup "regex-tdfa-text"
    [ bench "1"       $ nf (uncurry matchAll) (rTDFAT, it1)
    , bench "1000"    $ nf (uncurry matchAll) (rTDFAT, it1000)
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

instance NFData TDFA.Regex where
  rnf TDFA.Regex{..} = 
    (rnf regex_dfa) `seq`
    (rnf regex_init) `seq`
    (rnf regex_b_index) `seq`
    (rnf regex_b_tags) `seq`
    (rnf regex_trie) `seq`
    (rnf regex_tags) `seq`
    (rnf regex_groups) `seq`
    (rnf regex_isFrontAnchored) `seq`
    (rnf regex_compOptions) `seq`
    (rnf regex_execOptions) `seq`
    ()

instance NFData TDFA.DFA where 
  rnf (TDFA.DFA a b) = rnf a `seq` rnf b `seq` ()

instance NFData TDFA.DT where
  rnf TDFA.Simple'{..} = 
    rnf TDFA.dt_win `seq` 
    rnf TDFA.dt_trans `seq` 
    rnf TDFA.dt_other `seq` ()
  rnf TDFA.Testing'{..} = 
    rnf TDFA.dt_test `seq` 
    rnf TDFA.dt_dopas `seq` 
    rnf TDFA.dt_a `seq` 
    rnf TDFA.dt_b `seq` ()

instance NFData v => NFData (TrieSet v) where
  rnf (TrieSet v n) = rnf v `seq` rnf n `seq` ()

instance NFData TDFA.OP where
  rnf TDFA.Maximize = ()
  rnf TDFA.Minimize = ()
  rnf TDFA.Orbit = ()
  rnf TDFA.Ignore = ()

instance NFData TDFA.GroupInfo where
  rnf (TDFA.GroupInfo !_ !_ !_ !_ !_) = ()

instance NFData TDFA.ExecOption where
  rnf (TDFA.ExecOption !_) = ()

instance NFData TDFA.CompOption where
  rnf (TDFA.CompOption !_ !_ !_ !_ !_) = ()