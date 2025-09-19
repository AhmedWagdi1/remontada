#!/usr/bin/env python3
"""
add_thunder_warriors_members.py

Simple script to add missing members to Team #1 (THUNDER WARRIORS) using the test accounts
provided in REMUNTADA_COMPLETE_TEST_DATA.txt.

It logs in the leader (0536925874), activates the account (code=11111), then calls
`/team/add-member` for each member phone number. If add-member fails with a permission
or not-found error, it attempts `/team/member-role` as a fallback.

Usage: python3 add_thunder_warriors_members.py [--dry-run] [--base-url URL]

Note: This script is a lightweight helper for testing. It assumes the test API behaves
like the sample in REMUNTADA_COMPLETE_TEST_DATA.txt and returns JSON responses with
`status`/`message` and `data` fields.
"""

import argparse
import sys
import time
from typing import List

import requests


LEADER_MOBILE = "0536925874"
LEADER_VERIFY_CODE = "11111"
LEADER_UUID = "550e8400-e29b-41d4-a716-446655440000"
DEVICE_TOKEN = "dGhpc19pc19hX2RldmljZV90b2tlbl9leGFtcGxl"
DEVICE_TYPE = "ios"
TEAM_ID = 59

# Default regular members for TEAM #1 (fallback)
DEFAULT_THUNDER_WARRIORS_MEMBERS = [
    "0536925877",
    "0536925878",
    "0536925879",
    "0536925880",
    "0536925881",
    "0536925883",
    "0536925884",
    "0536925889",
    "0536925890",
    "0536925893",
]


def parse_members_from_testfile(path: str) -> List[str]:
    """Parse REMUNTADA_COMPLETE_TEST_DATA.txt to extract Team #1 regular member mobiles.

    Looks for the section labeled 'TEAM #1: THUNDER WARRIORS' and then the 'REGULAR MEMBERS'
    list; extracts phone-like tokens (05xxxxxxxx).
    """
    members = []
    try:
        with open(path, "r", encoding="utf-8") as f:
            text = f.read()
    except Exception:
        return []

    # Find the TEAM #1 section
    marker = "TEAM #1: THUNDER WARRIORS"
    idx = text.find(marker)
    if idx == -1:
        return []

    # Narrow to a reasonable slice after the marker
    slice_text = text[idx: idx + 1000]

    # Find the REGULAR MEMBERS block
    rm_marker = "REGULAR MEMBERS"
    rm_idx = slice_text.find(rm_marker)
    if rm_idx == -1:
        return []

    rm_slice = slice_text[rm_idx: rm_idx + 400]
    # Extract phone-like tokens (05 followed by 8+ digits)
    import re

    phones = re.findall(r"05\d{7,9}", rm_slice)
    # Deduplicate and return
    for p in phones:
        if p not in members:
            members.append(p)
    return members


def login_and_activate(base_url: str, mobile: str, verbose: bool = False) -> str:
    s = requests.Session()
    login_url = f"{base_url.rstrip('/')}/login"
    activate_url = f"{base_url.rstrip('/')}/activate"

    if verbose:
        print(f"[+] Sending login request for {mobile} -> {login_url}")
    r = s.post(login_url, json={"mobile": mobile})
    if verbose:
        print(f"    -> status: {r.status_code}, body: {r.text}")
    # In test env, activation code is constant
    if verbose:
        print(f"[+] Activating {mobile}")
    r = s.post(
        activate_url,
        json={
            "code": LEADER_VERIFY_CODE,
            "mobile": mobile,
            "uuid": LEADER_UUID,
            "device_token": DEVICE_TOKEN,
            "device_type": DEVICE_TYPE,
        },
    )
    if r.status_code not in (200, 201):
        raise RuntimeError(f"Activation failed: {r.status_code} {r.text}")
    data = r.json()
    # Try common keys for token
    token = None
    if isinstance(data, dict):
        token = data.get("access_token") or data.get("data", {}).get("access_token") or data.get("token")
    if not token:
        raise RuntimeError(f"Could not find access token in activation response: {data}")
    if verbose:
        print(f"[+] Obtained token: {token[:24]}...")
    return token


def add_member(base_url: str, token: str, member_mobile: str, verbose: bool = False) -> dict:
    url = f"{base_url.rstrip('/')}/team/add-member"
    headers = {"Authorization": f"Bearer {token}"}
    payload = {"team_id": TEAM_ID, "mobile": member_mobile}
    if verbose:
        print(f"[+] POST {url} payload={payload}")
    r = requests.post(url, json=payload, headers=headers)
    try:
        return {"status_code": r.status_code, "json": r.json(), "text": r.text}
    except Exception:
        return {"status_code": r.status_code, "json": None, "text": r.text}


def member_role(base_url: str, token: str, member_mobile: str, role: str = "member", verbose: bool = False) -> dict:
    url = f"{base_url.rstrip('/')}/team/member-role"
    headers = {"Authorization": f"Bearer {token}"}
    payload = {"team_id": TEAM_ID, "mobile": member_mobile, "role": role}
    if verbose:
        print(f"[+] POST {url} payload={payload}")
    r = requests.post(url, json=payload, headers=headers)
    try:
        return {"status_code": r.status_code, "json": r.json(), "text": r.text}
    except Exception:
        return {"status_code": r.status_code, "json": None, "text": r.text}


def main(argv: List[str]):
    parser = argparse.ArgumentParser()
    parser.add_argument("--base-url", default="https://pre-montada.gostcode.com/api", help="API base URL")
    parser.add_argument("--dry-run", action="store_true", help="Don't perform any POSTs; just print actions")
    parser.add_argument("--verbose", action="store_true", help="Verbose output")
    parser.add_argument("--show-team", action="store_true", help="Show team members via GET /team/show/{id} and exit")
    parser.add_argument("--show-team-auth", action="store_true", help="Show team members via authenticated GET /team/show/{id} (logs in leader)")
    parser.add_argument("--team-id", type=int, default=TEAM_ID, help="Team id to query for --show-team or --show-team-auth")
    args = parser.parse_args(argv)

    base_url = args.base_url
    dry_run = args.dry_run
    verbose = args.verbose

    print("== Add THUNDER WARRIORS Members Helper ==")
    print(f"Target team: {TEAM_ID}")
    print(f"Leader mobile: {LEADER_MOBILE}")

    try:
        # If user asked to only show team members, call the endpoint and exit
        if args.show_team:
            show_url = f"{base_url.rstrip('/')}/team/show/{args.team_id}"
            if verbose:
                print(f"[+] GET {show_url}")
            r = requests.get(show_url)
            try:
                print(r.json())
            except Exception:
                print(r.status_code, r.text)
            return

        if args.show_team_auth:
            # login leader to obtain token
            token = login_and_activate(base_url, LEADER_MOBILE, verbose=verbose)
            show_url = f"{base_url.rstrip('/')}/team/show/{args.team_id}"
            headers = {"Authorization": f"Bearer {token}"}
            if verbose:
                print(f"[+] GET {show_url} with Authorization")
            r = requests.get(show_url, headers=headers)
            try:
                print(r.json())
            except Exception:
                print(r.status_code, r.text)
            return
        token = None
        if not dry_run:
            token = login_and_activate(base_url, LEADER_MOBILE, verbose=verbose)
        else:
            print("[DRY-RUN] Would login and activate leader to obtain token")

        # Determine members list: try parsing the test data file, otherwise use defaults
        members = parse_members_from_testfile("REMUNTADA_COMPLETE_TEST_DATA.txt") or DEFAULT_THUNDER_WARRIORS_MEMBERS
        source = "REMUNTADA_COMPLETE_TEST_DATA.txt" if members and members != DEFAULT_THUNDER_WARRIORS_MEMBERS else "default list"
        print(f"Members source: {source} (count={len(members)})")

        results = []
        for m in members:
            print(f"\n--- Processing member {m} ---")
            if dry_run:
                print(f"[DRY-RUN] Would call /team/add-member for {m}")
                results.append((m, "dry-run", None))
                continue

            # First try /team/add-member
            resp = add_member(base_url, token, m, verbose=verbose)
            sc = resp.get("status_code")
            j = resp.get("json")
            if sc in (200, 201) or (isinstance(j, dict) and j.get("status") in (True, "success", "ok")):
                print(f"[OK] Added {m} via add-member (status {sc})")
                results.append((m, "added", resp))
                time.sleep(0.2)
                continue

            # If failed due to permission or other, try member-role
            print(f"[WARN] add-member failed for {m} (status {sc}) - trying member-role")
            resp2 = member_role(base_url, token, m, role="member", verbose=verbose)
            sc2 = resp2.get("status_code")
            j2 = resp2.get("json")
            if sc2 in (200, 201) or (isinstance(j2, dict) and j2.get("status") in (True, "success", "ok")):
                print(f"[OK] Assigned role for {m} via member-role (status {sc2})")
                results.append((m, "role-assigned", resp2))
            else:
                print(f"[FAIL] Could not add {m}. add-member status={sc}, member-role status={sc2}")
                if verbose:
                    print("    add-member response:", resp)
                    print("    member-role response:", resp2)
                results.append((m, "failed", {"add": resp, "role": resp2}))

        # Summary
        print("\n== Summary ==")
        for m, status, info in results:
            print(f"{m}: {status}")

    except Exception as e:
        print("Error:", e)
        sys.exit(1)


if __name__ == "__main__":
    main(sys.argv[1:])
