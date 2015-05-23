module Number (tests) where

import Imports

import Crypto.Number.Basic
import Crypto.Number.Generate
import Data.Bits

tests = testGroup "number"
    [ testProperty "num-bits" $ \(Positive i) ->
        and [ (numBits (2^i-1) == i)
            , (numBits (2^i) == i+1)
            , (numBits (2^i + (2^i-1)) == i+1)
            ]
    , testProperty "num-bits2" $ \(Positive i) ->
        not (i `testBit` numBits i) && (i `testBit` (numBits i - 1))
    , testProperty "generate-param" $ \testDRG (Positive bits)  ->
        let r = withTestDRG testDRG $ generateParams bits (Just SetHighest) False
         in r >= 0 && numBits r == bits && testBit r (bits-1)
    , testProperty "generate-param2" $ \testDRG (Positive m1bits) ->
        let bits = m1bits + 1 -- make sure minimum is 2
            r = withTestDRG testDRG $ generateParams bits (Just SetTwoHighest) False
         in r >= 0 && numBits r == bits && testBit r (bits-1) && testBit r (bits-2)
    , testProperty "generate-param-odd" $ \testDRG (Positive bits) ->
        let r = withTestDRG testDRG $ generateParams bits Nothing True
         in r >= 0 && odd r
    , testProperty "generate-range" $ \testDRG (Positive range) ->
        let r = withTestDRG testDRG $ generateMax range
         in 0 <= r && r < range
    ]
