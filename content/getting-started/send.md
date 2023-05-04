---
layout: default
title: Send coins
parent: Getting Started
nav_order: 4
weight: 40
---

{{< img 2022-09-29_20-48-36.png >}}

1. Start from the account page by clicking on the "Send" button in the bottom right corner

{{< img 2022-09-29_20-50-14.png >}}

1. Address to send coins to
2. Tap to open the QR code scanner
3. Either enter the amount in mZEC or 
4. Enter the amount in Fiat currency. The other field updates automatically
5. Tap to spend the entire balance

## Memo

6. Check to include your address in the memo. The recipient can directly reply to you if he is using Ywallet too.
7. Memo Subject
8. Memo Body

{{% notice info %}}
Memo subject, body and reply-to are supported between
YWallet sender/receiver. If not, they will appear
in the text of the memo.
{{% /notice %}}

## Advanced Settings

9. These settings are detailed in the section 
[Advanced Usage/Send Options]({{<relref "advanced-send">}}).

## Detailed balances

{{< img 2022-09-29_20-50-15.png >}}

1. Total balance available = transparent + shielded
2. Shielded [NOTES]({{<relref notes>}}) that don't have enough confirmations for sending 
3. Shielded notes that were excluded from sending ([COIN CONTROL]({{<relref coin-control>}}))
4. Transparent balance. These coins must be shielded before sending. Tap the
shield button to initiate the transfer to your shielded address
5. Remaining balance spendable (taking the network fee into consideration)

## Transaction Summary

{{< img 2023-05-04_13-56-19.png >}}

This page gives you a summary of the actual transaction that the wallet 
is about to perform.

When your recipient is a UA that includes multiple receivers, YWallet
will choose one or many receivers in order to optimize your **privacy**.
It may result in a split of an output into several parts.

For example, suppose that you currently have 2 ZEC in a Sapling note and
1 ZEC in an Orchard note. If you want to pay 2.5 ZEC to UA that has both
Sapling and Orchard receivers, YWallet will make a transaction that
pays 2 ZEC and 0.5 ZEC to the Sapling and Orchard receivers respectively.

Your recipient will receive the exact same amount and there will be a single
transaction. For the most part, the process is seamless. However, the
transaction summary page will show the two receivers.

The idea is similar to splitting a bill between two credit cards.

## Remarks

- The spendable balance excludes the network fee of 0.01 mY/ZEC. 
- Notes may not be spendable if they were received recently.
In this case, wait for more confirmations or change the setting
"Number of Confirmations Needed before Spending". 
- Lowering the value increases the risk of having the transaction reverted.
- By default, the balance in the transparent address cannot be spent. 
Refer to [Use Transparent Balance]({{<relref advanced-send>}}) to enable 
spending from it.
