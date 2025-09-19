Add THUNDER WARRIORS Members Helper
===================================

What this does
---------------
Adds the missing regular members to Team #1 (THUNDER WARRIORS, team_id=59) using the test
accounts listed in `REMUNTADA_COMPLETE_TEST_DATA.txt`.

Files added
-----------
- `add_thunder_warriors_members.py`: Python script that logs in/activates the leader and calls
  `/team/add-member` for each missing member, falling back to `/team/member-role` if needed.

Quick usage
-----------
1. Ensure Python 3 and `requests` are installed.

2. Run the script (dry-run first to preview actions):

```bash
python3 add_thunder_warriors_members.py --dry-run --verbose
```

3. If dry-run looks correct, run for real:

```bash
python3 add_thunder_warriors_members.py --verbose
```

Flags
-----
- `--base-url`: API base URL (default: `https://pre-montada.gostcode.com/api`)
- `--dry-run`: Do not send POST requests; only print intended actions
- `--verbose`: Print full request/response bodies

Notes & next steps
------------------
- The script assumes activation returns an access token in `access_token`, `token`, or
  `data.access_token` fields. If your API uses a different key, update `login_and_activate()`.
- If the API requires additional fields in `/team/add-member` or `/team/member-role`, update
  the payloads in the script.
- The script uses the leader mobile `0536925874` and team id `59` per `REMUNTADA_COMPLETE_TEST_DATA.txt`.

If you want, I can:
- Run the script against the test server (I won't run network calls without your permission).
- Modify it to read member lists from `REMUNTADA_COMPLETE_TEST_DATA.txt` automatically.
