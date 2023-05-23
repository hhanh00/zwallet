---
title: H/W Ledger
weight: 60
---

YWallet supports hardware wallets from the Ledger company.

{{% notice warning %}}
The Zcash Ledger App is under review and is NOT yet available
on Ledger Live.
{{% /notice %}}

At this moment if you want to use a Ledger, you need to sideload the app
on your NanoS and NanoS+ (other models are not supported).

Instructions are on the app website [Zcash Ledger](https://github.com/hhanh00/zcash-ledger).

## Requirements

Ledger support is only available on desktop: Linux, Mac and Windows.

## How to Import a Ledger Account

- Make sure your device is connected, unlocked and the Zcash app is running.
- In the New account page, choose "Restore an account" and click on the "Import from Ledger" button.

{{< img "2023-05-04_13-43-33.png" >}}

Once your account is imported, you do not to keep your device connected. The
account behaves exactly like an cold wallet account. You can backup the view keys
if you want.

{{% notice warning %}}
Due to Ledger OS Security Design, your Ledger shielded addresses are NOT
the same as a regular account for the same seed phrase.
{{% /notice %}}

The transparent address is the same.

## How to spend 

When you make an operation that requires withdrawal from the Ledger account, 
you must have your device connected, unlocked and the Zcash app running.

Prior to spending, you will always be presented with a [transaction summary
report]({{< relref "getting-started/send#transaction-summary" >}}).

## Approval

You are required to approve every output and the amount of fees.

<link href="/youtube.css" rel=stylesheet integrity>
<script src="/youtube.js"></script>

## Security Remarks

The code of the ledger app in open-source and available on [github](https://github.com/hhanh00/zcash-ledger).
At the time of writing, it has been submitted to Ledger for review but not yet processed.
Unfortunately, I do not have a timeline. It could take months. In the meantime, if you have a Nano S or
S+, you can build (or download a binary) and install it via USB cable. However, the Ledger will notify
that the "App is not genuine" because it lacks an official signature from Ledger. 

The Zcash Ledger app is also going through independent security review.

Finally, it should be noted that the app does not have access to
the seed phrase but only the secret key of transparent account (technically speaking `m/44'/133'`
derivation path). Therefore even if it has a backdoor (it does not), your other coins are out of
reach.

## Video Demo

{{< youtube "_o-1UzQRP-8" >}}
