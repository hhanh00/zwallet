---
title: Why is the synchronization so slow?
weight: 10
---

Because of the SPAM, your synchronization time is 
100 times slower.

Zcash used to offer a fix fee for all shielded transactions
regardless of their sizes: 0.00001 ZEC. That's very cheap.
One day, someone started making transactions with 1000s of 
inputs/outputs for next to nothing. 

Thus, pretty much all the blocks got filled
with garbage (most likely, it's shielded - we do not know
what is inside).

Eventually, fees were raised but that took one year, during
which the SPAM went uncontrolled.

The SPAM lasted from block height 1 700 000 to 2 200 000 (roughly).

If you have to scan over that period, you will notice that the
speed goes down to 1% of what it used to, as blocks are 100 times
larger.

The good news is:

1. YWallet can still scan over this period, but it is *SLOW*. 
Every other wallet stopped working.
2. You can activate the spam filter. It will not try to process
the spam transactions but they still have to be downloaded. That's
GB of data.
3. The spam has ended. Fees are dynamic and the cost of large
transactions are higher, making spamming cost prohibitive. 

The bad news is:

1. As of Nov 23, only YWallet has been updated to compute the fees according 
to the new rules. The other wallets can 
make transactions that are considered spam by the network.
