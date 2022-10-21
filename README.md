# YWallet

> The fastest, most advanced, shielded wallet for Zcash

## Main Features

- Warp Sync: **PROCESSES ~10 000 BLOCKS PER SECOND** (1) 
- **Transparent** and **Shielded** Address support (2)
- Scalable Design: Supports **hundreds of thousands of transactions and received notes**
- **Low Requirements**: Android 7.0+, 2 GB of RAM

## Other Features

- *Multi-account*
- *Watch only account* from **viewing key**
- Import seed phrase (**ZIP 32 compliant**) or secret key (**Zcashd standard**)
- One touch transparent account shielding
- **Automatic shielding** above configurable threshold
- Transparent Shielding in Payments 
- Snap (i.e. **diversified**) addresses 
- Show equivalent in **Fiat currencies** (USD, EUR, JPY, RMB, etc.)
- Display and select notes (**Coin Control**)
- Specify spending amount in Fiat or ZEC
- Prepare **UNSIGNED transactions** for cold storage spending
- **Broadcast raw transactions**
- **Multiple recipient** payments
- *Transaction History*
- **Memo**
- *Auto Split Notes*
- Account *Balance History*
- Largest Past *Payees Chart*
- **Wallet P/L Charts and Reports**
- *Contact Address Book*
- **Color and Dark/Light Themes**
- Customizable anchor offset
- **QR code scanner support**
- **Localization** in English, Spanish, French, Chinese, (more to come)
- *Fluent and Responsive UI*

# Privacy Features

- No data upload
- **All information recoverable from seed phrase or secret key**
- Customizable `lightwalletd` server URL

(1): Tested on OnePlus 7T - Snapdragon 855+
(2): Primary Shielded - Transparent Balance cannot be directly spent

# Top 10 Features

## 10. Themes and custom server
The app comes with several themes both in dark and light mode. And it lets you customize your own theme.
If you run your own instance of lightwalletd, you can connect to it specifically.

## 9. Multi Pay
I have used this feature only a few times but when I did, it was a huge time saver.
If you need to pay several people, you can make a single transaction with several recipients. Without multi-pay, you’d have to wait for confirmations once you run out of spare notes.

## 8. Launcher Integration
The wallet has launcher shortcuts for sending and receiving when you press on the app icon. On iOS, if you scan a payment URI, it will offer to open the wallet and jump to the “send” page.

## 7. Contacts
I created contacts for my most commonly used addresses. They are saved on the blockchain in a private memo and therefore will never be lost.
## 6. Control of Send and Received Notes
The app shows you the individual notes that you received and you can choose to exclude some of them from spending. Moreover, when you make a payment you can split a large note into smaller ones in order to give more notes to your recipient.
## 5. Your balance is shown in detail
The “send” page has a breakdown of your balance. It shows the amount that hasn’t received enough confirmations yet, the balance you excluded from spending, the amount in your transparent address, etc. If you choose to, you can spend under confirmed notes or your transparent balance but it won’t be done by default since it may hurt your privacy.
There is no “why can’t I use my money” surprise.
## 4. Price Chart and Wallet P/L
I often want to quickly check the market price of ZEC vs fiat. The home page shows the current market price and the valuation of the account in fiat. If I want to look at the history, I swipe to the Price Chart. The app offers ~70 different reference currencies both in fiat and crypto.
## 3. Multi Account
The wallet can hold several accounts with different seeds, secret keys, or viewing keys. This allows me to have an account per type of fund. For instance, one of the accounts is watch-only and has all the functionalities of a regular account except direct spending.
## 2. Cold Wallet
Speaking of watch-only accounts, it is possible to spend from them using the companion tool. After confirming the transfer, the wallet creates an unsigned transaction file. I transfer it by USB OTG and sign it on my offline laptop. Finally, I bring it back to YWallet for broadcasting.
## 1. Sync speed
Finally, the wallet is currently the fastest by far and scales well to large accounts with thousands of notes and transactions. Also, it starts quickly and synchronizes in seconds. I don’t have to think about keeping it in sync.
