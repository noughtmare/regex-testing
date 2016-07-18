{-# LANGUAGE OverloadedStrings #-}
module Main where

import Data.Maybe
import Text.Regex.TDFA
import Text.Regex.TDFA.ByteString.Lazy
import Data.ByteString.Lazy.Char8 as B
import Data.Thyme
import Data.Thyme.Clock.POSIX
import Data.AdditiveGroup ((^-^))
import Text.Regex.Base.RegexLike
import Criterion.Main
import Control.DeepSeq

input :: Int -> ByteString
input n = force $ B.unlines $ Prelude.replicate n "Hello world foo=123 whereas bar=456 Goodbye"

regex :: Regex
regex = regex' `seq` regex'
  where
    regex' = fromRight $ compile defaultCompOpt defaultExecOpt "foo=[0-9]+"
    fromRight (Right a) = a

main = defaultMain [ bgroup "reverse" [ bench "1" $ nf B.reverse (input 1)
                                      , bench "1000" $ nf B.reverse (input 1000)
                                      , bench "1000000" $ nf B.reverse (input 1000000)
                                      ]
                   , bgroup "regex"   [ bench "1" $ nf (uncurry matchAll) (regex, input 1)
                                      , bench "1000" $ nf (uncurry matchAll) (regex, input 1000)
                                      , bench "1000000" $ nf (uncurry matchAll) (regex, input 1000000)
                                      ]
                   ]
