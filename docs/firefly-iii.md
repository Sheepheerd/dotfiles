# Firefly III + SimpleFIN

A systemd timer on **solis** imports the last 7 days of SimpleFIN transactions
into Firefly III every morning around 6:00 AM. Firefly's duplicate detection
drops anything already imported, and your rules run on every new transaction.

Module: [`modules/nixos/server/firefly-iii.nix`](../modules/nixos/server/firefly-iii.nix)

| Piece | Where | Holds |
| --- | --- | --- |
| Timer + service | `firefly-iii-simplefin-import` | Runs daily at 6:00 AM (+ up to 30 min random delay), catches up after downtime |
| Credentials | `secrets/server/firefly-importer.age` | `FIREFLY_III_ACCESS_TOKEN`, `SIMPLEFIN_TOKEN` (env file) |
| Account mapping | `secrets/server/firefly-simplefin-config.age` | Import config JSON from the importer web UI |

`SIMPLEFIN_TOKEN` must be the **access URL**
(`https://user:pass@bridge.simplefin.org/simplefin`), not the one-time setup
token. The job fails with an error if it isn't.

Each run overrides the config's date range, token, and rules settings, so only
its account mapping matters. While the config secret is empty (as committed),
the job logs "No account mapping … skipping" and exits successfully.

## One-time setup

1. **Deploy.** On solis, from `~/.dotfiles`:

   ```sh
   sudo nixos-rebuild switch --flake .#solis
   ```

2. **Pick a start date.** The first of a month within the last ~90 days
   (SimpleFIN rarely returns more). Starting fresh: the first of the current
   month.
3. **Set opening balances.** In Firefly, set each account's opening balance to
   the bank balance on the day before the start date, dated that day.
4. **Run one manual import** at <https://bank-import.heerd.dev> with SimpleFIN.
   Choose a **date range** from your start date to today, not "all".
5. **Map accounts.** On the account step, pick your existing Firefly account in
   each dropdown instead of "create new".
6. **Download the config** on the last screen and put it in the agenix secret:

   ```sh
   cd ~/.dotfiles/secrets
   agenix -e server/firefly-simplefin-config.age < ~/Downloads/import_config.json
   ```

   Then commit and rebuild (step 1).
7. **Test the daily job**, then compare each balance against your bank:

   ```sh
   sudo systemctl start firefly-iii-simplefin-import
   journalctl -u firefly-iii-simplefin-import -e
   ```

If existing accounts already hold transactions you entered by hand, start the
range the day after your last manual entry. Otherwise you'll get duplicates that
don't match exactly, and duplicate detection won't catch them.

## Account types

| Real thing | In Firefly | Account role | Balance shows |
| --- | --- | --- | --- |
| Checking | Asset account | Default asset account | What's in the account |
| Savings | Asset account | Savings account | What's in the account |
| Debit card | No account: its purchases are checking transactions | — | — |
| Credit card | Asset account | Credit card (full payment, monthly payment day) | Negative: what you owe |

Use the Credit card role rather than a liability; liabilities are for loans and
mortgages. Card purchases are normal withdrawals and count toward budgets.

### Card payments and other transfers

Paying a card from checking shows up in both SimpleFIN accounts: a withdrawal
from checking ("CHASE CREDIT CRD AUTOPAY") and a deposit on the card
("AUTOMATIC PAYMENT - THANK YOU"). Left alone, the payment counts as spending
and as income. Fix it with two rules:

| Rule | Conditions (strict on) | Action |
| --- | --- | --- |
| Card payment (checking side) | Description contains the autopay text, source account is Checking | Convert to transfer, destination = the card account |
| Card payment (card side) | Description contains "AUTOMATIC PAYMENT", type is Deposit, destination is the card | Delete transaction |

Use the same pattern for checking → savings. Match text only payments use so
refunds (also deposits on the card) aren't deleted. Run both rules once on
existing transactions, then check card balances against the statement.

### Investments

Holdings and performance live in Wealthfolio
([`wealthfolio.nix`](../modules/nixos/server/wealthfolio.nix),
<https://stocks.heerd.dev>); Firefly only tracks cash moving in and out.

- In Firefly, create one asset account per brokerage or retirement account,
  role **Savings account**.
- Don't map brokerage accounts in the SimpleFIN import. Trades, dividends and
  sweeps are Wealthfolio's job.
- Rule for contributions: description contains the broker's ACH text, source
  is Checking → Convert to transfer, destination = the brokerage account.
  Transfers never count against a budget.
- Optional: Reconcile the brokerage account monthly to Wealthfolio's value so
  Firefly's net worth includes gains. Otherwise it shows what you've put in.
- In Wealthfolio, import the broker's activity CSV every month or after trades.

## Rules: categories and budgets

Rules live in Firefly III under **Automation → Rules** at
<https://bank.heerd.dev>. The import runs them on every new transaction.

1. Create your categories and budgets first (e.g. category *Groceries*, budget
   *Food*).
2. Create a rule group, e.g. "Auto-categorize". Groups run in order. Tick "stop
   processing" on a rule so later rules don't override it.
3. Add a rule per budget or merchant:
   - **Trigger:** when a transaction is created (also "updated" to re-apply on
     edits).
   - **Strict mode:** off = any condition matches, on = all must match.
   - **Conditions:** `Description contains "KROGER"`,
     `Transaction type is Withdrawal`, amount ranges.
   - **Actions:** `Set category`, `Set budget`, and optionally
     `Set destination account` to an existing merchant account like "Kroger".
4. Use **Run rule** to apply a new rule to transactions already imported.

Example:

| Rule | Conditions (strict off) | Actions |
| --- | --- | --- |
| Food | Description contains KROGER, ALDI, WHOLEFDS | Category Groceries, budget Food |

Tips:

- Bank descriptions are messy ("KROGER #1234 COLUMBUS OH"), so match a short
  distinctive piece with `contains`.
- The fastest way to build rules is **Create rule from transaction** on an
  uncategorized one.
- Search `has_no_category:true` every week or two and add rules for new
  merchants.
- Budgets only count withdrawals, not deposits or transfers between your own
  accounts.

### Merchant accounts

The importer matches merchants (expense/revenue accounts) by name and creates a
new one when nothing matches, so you'll get near-duplicates like
"KROGER #1234". Fix them with a `Set destination account` action in the rule,
or merge them: on the duplicate account's page, move its transactions into the
real account, then delete the empty one.

## When things change

Changing SimpleFIN accounts means updating the mapping, not redoing the whole
setup. Opening balances, rules, and `firefly-importer.age` stay as they are.

| Change | What to do |
| --- | --- |
| Added a bank or card in SimpleFIN | Remap (below). Until you do, the new account is silently skipped. |
| Re-linked a bank in SimpleFIN | Remap. Re-linking can give accounts new SimpleFIN IDs, which look like new accounts. |
| Removed an account | Delete its line from `accounts` (`agenix -e server/firefly-simplefin-config.age`). |
| Point an account somewhere else | Edit its number in `accounts`. The Firefly ID is in the account's URL (`/accounts/show/5` → `5`). |
| Revoked or regenerated SimpleFIN access | Put the new access URL in `SIMPLEFIN_TOKEN` (`agenix -e server/firefly-importer.age`), rebuild. |

The `accounts` section maps SimpleFIN account IDs to Firefly account IDs:

```json
"accounts": { "ACT-abc123...": 5 }
```

### Remap

1. Export the current config:

   ```sh
   cd ~/.dotfiles/secrets
   agenix -d server/firefly-simplefin-config.age > ~/import_config.json
   ```

2. At <https://bank-import.heerd.dev>, start a SimpleFIN import and **upload
   that file as the configuration**. Your existing mapping comes pre-filled.
3. Map only the new account, set the date range to where that account's history
   should begin, and finish.
4. Download the new config and save it into the secret (setup step 6), commit,
   rebuild.
5. Set the new account's opening balance in Firefly.
6. Delete `~/import_config.json` and the download; they contain the SimpleFIN
   access URL.

## Troubleshooting

- `journalctl -u firefly-iii-simplefin-import -e` shows each run.
- `systemctl list-timers firefly-iii-simplefin-import` shows the next run.
- A day with nothing new, or only already-imported transactions, counts as
  success (the importer exits 73 or reports [a115] duplicates). A
  SimpleFIN or Firefly error fails the unit.
- "Unit not found": the module isn't deployed yet; rebuild.
- SimpleFIN `404 Not Found` with `%0A` in the URL: the token had a trailing
  newline. The job strips whitespace now; check `SIMPLEFIN_TOKEN` is one line.

### Balances don't match the bank

Firefly computes a balance as opening balance + every transaction it holds. It
never copies the bank's balance. Usual causes:

- **No opening balance.** The import only covers your date range, so everything
  before it is missing. Set the opening balance as of the day before the range
  (Accounts → edit).
- **Wrong opening balance date.** It must be before the first imported
  transaction.
- **Duplicates.** Transactions entered by hand or imported twice. Look for pairs
  with the same date and amount.
- **Pending transactions.** The bank's balance can include pending charges that
  SimpleFIN hasn't posted yet. These settle within a few days.
- **Credit cards.** A card mapped to a normal asset account shows a negative
  balance. Set its account role to "Credit card" (or make it a liability) so it
  reads as the amount owed.

To fix an account in one step, use **Reconcile** on the account page. Enter the
bank's balance for a date and Firefly adds a correcting transaction.
