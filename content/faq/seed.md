---
title: Why YWallet does not find my funds?
weight: 10
---

I have the right seed phrase but YWallet does not show the
right balance. Where are the rest of my funds?

Funds are located at addresses that derived
from the seed phrase, but it is not a one to one mapping.
In fact, from a given seed phrase, you have as many
addresses as you want. You need to also know the derivation
path.

{{%notice note %}}
seed phrase + derivation path gives you a secret key and therefore an address.
{{%/notice %}}

There is a "standard" derivation that all shielded wallets use.
**But then some wallets decided to use additional derivation paths!**

- Whenever you create a new shielded address, Zecwallet Lite
uses a new derivation path. This is because it does not support diversified addresses.
- Nighthawk, Edge and other ECC SDK 2.0 wallets use a separate
derivation path for the change. It helps them distinguish incoming funds
from change.

In this case, only the original wallet knows what derivation paths
they used and therefore only it knows where to look for the funds.

{{%notice warning %}}
Every derivation path impacts the synchronization time.
{{%/notice %}}
2 addresses means 2 times the number of trial decryptions.
3 addresses means 3 times, etc...

## Well, couldn't YWallet also scan for all other "known" locations?

First of all, scanning an address is costly. Public blockchains
do not have this problem because the scan is made once and for all
by the remote server. Private blockchains MUST scan locally if they
want to preserve the privacy of user.
Secondly, YWallet is not in the business of emulating other wallets'
behavior, especially when it has a massive performance impact.

## Why wasn't that a problem before?

Before and after the SPAM (Jul 2022-Sep 2023), there were very
few transactions per block. The SPAM increased that number 100 fold.
What used to be acceptable became unusable. However, the problem 
was always there, and could very likely come back actually.

## I still want my funds

You can manually create an account for each shielded address
that has funds, and rescan them all at once. YWallet supports
importing from secret key.

## What about YWallet?

YWallet only uses the primary derivation path. Your funds
will always be found by other wallets. However, the inverse
is not necessarily true.

