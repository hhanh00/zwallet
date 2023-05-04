---
title: H/W Ledger
weight: 60
---

YWallet supports hardware wallet from the Ledger company.

{{% notice warning %}}
The Zcash Ledger App is under review and is NOT yet available
on Ledger Live.
{{% /notice %}}

At this moment if you want to use a Ledger, you need to sideload the app
on your NanoS+ (other models are not supported).

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

## How to spend 

When you make an operation that requires withdrawal from the Ledger account, 
you must have your device connected, unlocked and the Zcash app running.

Prior to spending, you will always be presented with a [transaction summary
report]({{< relref "getting-started/send#transaction-summary" >}}).

## Approval

You are required to approve every output and the amount of fees.

<link href="/youtube.css" rel=stylesheet integrity>
<script src="/youtube.js"></script>

## Video Demo

{{< youtube "_o-1UzQRP-8" >}}
