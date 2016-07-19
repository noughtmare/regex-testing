# regex-testing
Testing various regex packages

Currently testing Data.Text.reverse and parallelized Text.Regex.TDFA.Text

Results (with `-O2 -threaded -rtsopts --with-rtsopts=-N4` on a Intel® Core™ i3-4100M Processor
(3M Cache, 2.50 GHz)):
```
benchmarking reverse/1
time                 793.5 ns   (754.7 ns .. 838.2 ns)
                     0.985 R²   (0.981 R² .. 0.993 R²)
mean                 821.6 ns   (787.4 ns .. 845.1 ns)
std dev              89.91 ns   (74.37 ns .. 111.9 ns)
variance introduced by outliers: 91% (severely inflated)

benchmarking reverse/1000
time                 702.7 μs   (610.9 μs .. 832.4 μs)
                     0.894 R²   (0.830 R² .. 0.994 R²)
mean                 705.6 μs   (677.6 μs .. 754.1 μs)
std dev              125.4 μs   (89.22 μs .. 204.2 μs)
variance introduced by outliers: 90% (severely inflated)

benchmarking reverse/1000000
time                 638.6 ms   (410.2 ms .. 1.080 s)
                     0.948 R²   (0.908 R² .. 1.000 R²)
mean                 854.6 ms   (735.5 ms .. 947.8 ms)
std dev              144.2 ms   (0.0 s .. 161.4 ms)
variance introduced by outliers: 47% (moderately inflated)

benchmarking regex-tdfa-text/1
time                 198.1 ns   (187.1 ns .. 208.9 ns)
                     0.988 R²   (0.981 R² .. 0.998 R²)
mean                 205.5 ns   (200.8 ns .. 208.7 ns)
std dev              12.24 ns   (7.068 ns .. 18.51 ns)
variance introduced by outliers: 76% (severely inflated)

benchmarking regex-tdfa-text/1000
time                 170.0 μs   (161.2 μs .. 178.0 μs)
                     0.985 R²   (0.979 R² .. 0.992 R²)
mean                 155.5 μs   (148.4 μs .. 161.7 μs)
std dev              21.24 μs   (19.90 μs .. 22.99 μs)
variance introduced by outliers: 88% (severely inflated)

benchmarking regex-tdfa-text/1000000
time                 174.7 ms   (157.7 ms .. 207.0 ms)
                     0.975 R²   (0.929 R² .. 0.999 R²)
mean                 161.4 ms   (150.7 ms .. 174.3 ms)
std dev              15.60 ms   (9.144 ms .. 19.55 ms)
variance introduced by outliers: 27% (moderately inflated)
```
