# regex-testing
Testing various regex packages

Currently testing Data.Text.reverse and parallelized Text.Regex.TDFA.Text

Results (with `-O2 -threaded -rtsopts --with-rtsopts=-N4` on a Intel® Core™ i3-4100M Processor
(3M Cache, 2.50 GHz)):
```
benchmarking reverse/1
time                 691.7 ns   (685.0 ns .. 702.0 ns)
                     0.992 R²   (0.982 R² .. 0.998 R²)
mean                 729.7 ns   (701.3 ns .. 799.6 ns)
std dev              148.9 ns   (83.36 ns .. 251.4 ns)
variance introduced by outliers: 98% (severely inflated)

benchmarking reverse/1000
time                 631.0 μs   (625.4 μs .. 639.2 μs)
                     0.999 R²   (0.998 R² .. 1.000 R²)
mean                 631.8 μs   (628.5 μs .. 637.4 μs)
std dev              15.74 μs   (10.58 μs .. 22.47 μs)
variance introduced by outliers: 15% (moderately inflated)

benchmarking reverse/1000000
time                 617.2 ms   (536.2 ms .. 686.8 ms)
                     0.998 R²   (0.992 R² .. 1.000 R²)
mean                 612.1 ms   (600.8 ms .. 621.7 ms)
std dev              15.24 ms   (0.0 s .. 16.54 ms)
variance introduced by outliers: 19% (moderately inflated)

benchmarking regex-tdfa-text parallel/1
time                 11.91 μs   (11.68 μs .. 12.21 μs)
                     0.995 R²   (0.992 R² .. 0.998 R²)
mean                 11.85 μs   (11.62 μs .. 12.19 μs)
std dev              940.1 ns   (680.6 ns .. 1.249 μs)
variance introduced by outliers: 79% (severely inflated)

benchmarking regex-tdfa-text parallel/1000
time                 9.938 ms   (9.668 ms .. 10.24 ms)
                     0.995 R²   (0.991 R² .. 0.998 R²)
mean                 10.14 ms   (9.983 ms .. 10.36 ms)
std dev              536.3 μs   (431.4 μs .. 675.0 μs)
variance introduced by outliers: 25% (moderately inflated)

benchmarking regex-tdfa-text/1
time                 13.26 μs   (13.12 μs .. 13.45 μs)
                     0.998 R²   (0.998 R² .. 0.999 R²)
mean                 13.42 μs   (13.31 μs .. 13.54 μs)
std dev              373.5 ns   (326.7 ns .. 439.7 ns)
variance introduced by outliers: 31% (moderately inflated)

benchmarking regex-tdfa-text/1000
time                 12.26 ms   (11.54 ms .. 12.85 ms)
                     0.977 R²   (0.958 R² .. 0.989 R²)
mean                 10.77 ms   (10.37 ms .. 11.35 ms)
std dev              1.264 ms   (1.123 ms .. 1.415 ms)
variance introduced by outliers: 61% (severely inflated)
```
