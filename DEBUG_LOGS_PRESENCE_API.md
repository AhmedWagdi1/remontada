# Debug Logs for Player Presence Confirmation

## Overview
Comprehensive debug logs have been added to track the entire flow when confirming a player's presence in a match.

## API Endpoint
```
POST /presence/{match_id}

Body:
{
    "subscriber_id": <player_id>,
    "payment_method": <cash|coupon|signal>
}
```

## Debug Log Flow

### 1. UI Layer (players_screen_supervisor.dart)
**Location**: Button click handler for "تأكيد اللاعب"

**Logs**:
- 🔵 `[UI] تأكيد اللاعب button clicked`
- 🔵 `[UI] Player ID: {id}, Name: {name}`
- 🔵 `[UI] Match ID: {matchId}`
- 🔵 `[UI] Payment method selected: {method}`
- 🔵 `[UI] Calling MatchDetailsCubit.apcense with params`
- 🔵 Parameters breakdown (id, paymentMethod, matchid)

**Location**: Bottom sheet confirmation
- 🟢 `[BottomSheet] Confirm button clicked in bottom sheet`
- 🟢 `[BottomSheet] Selected payment method: {method}`
- 🟢 `[BottomSheet] Subscriber ID: {id}`
- ⚠️ `[BottomSheet] WARNING: Payment method is empty!` (if empty)

### 2. Cubit Layer (matchdetails_cubit.dart)
**Method**: `apcense()`

**Logs**:
- 🟡 `[Cubit] apcense method called`
- 🟡 `[Cubit] Parameters received`
- 🟡 Parameter details (subscriber_id, paymentMethod, matchid)
- ❌ `[Cubit] ERROR: subscriber_id is null or empty!` (if applicable)
- ❌ `[Cubit] ERROR: matchid is null or empty!` (if applicable)
- ⚠️ `[Cubit] WARNING: paymentMethod is null or empty!` (if applicable)
- 🟡 `[Cubit] Calling repository apsence method...`
- ✅ `[Cubit] Success: apsence returned successfully` (on success)
- 🟡 `[Cubit] Emitting RefreshState to reload subscribers` (on success)
- ❌ `[Cubit] ERROR: apsence returned null (failed)` (on failure)
- ❌ `[Cubit] EXCEPTION in apcense: {error}` (with stackTrace)

### 3. Repository Layer (match_details_repo.dart)
**Method**: `apsence()`

**Logs**:
- 🔴 `[Repository] apsence method called`
- 🔴 `[Repository] Request details`
  - URL: POST /presence/{matchId}
  - Match ID
  - Body (full payload)
- ❌ `[Repository] ERROR: subscriber_id is null or empty!` (if applicable)
- ❌ `[Repository] ERROR: matchid is null or empty!` (if applicable)
- ⚠️ `[Repository] WARNING: payment_method is null or empty` (if applicable)
- 🔴 `[Repository] Sending POST request...`
- 🔴 `[Repository] Response received`
  - isError status
  - HTTP statusCode
  - Response data
- ✅ `[Repository] Success: Request completed successfully` (on success)
  - Response message
- ❌ `[Repository] ERROR: Request failed` (on failure)
  - Error message details
- ❌ `[Repository] EXCEPTION in apsence: {error}` (with stackTrace)

## Log Symbols Legend
- 🔵 **Blue Circle**: UI Layer events
- 🟢 **Green Circle**: Bottom Sheet events
- 🟡 **Yellow Circle**: Cubit Layer events
- 🔴 **Red Circle**: Repository/API Layer events
- ✅ **Check Mark**: Success messages
- ❌ **Red X**: Error messages
- ⚠️ **Warning**: Warning messages

## How to View Logs

### In VS Code:
1. Run the app with `fvm flutter run`
2. Watch the Debug Console for logs
3. Search for keywords: `PlayersScreenSupervisor`, `MatchDetailsCubit`, `MatchDetailsRepo`

### In Terminal:
```bash
fvm flutter run | grep -E "PlayersScreenSupervisor|MatchDetailsCubit|MatchDetailsRepo"
```

### Using Flutter DevTools:
1. Open Flutter DevTools
2. Go to Logging tab
3. Filter by the logger names mentioned above

## Common Issues to Look For

1. **Null/Empty Parameters**: Look for ERROR logs indicating missing data
2. **API Failures**: Check Repository layer for response errors
3. **Payment Method Issues**: Check for warnings about empty payment methods
4. **State Refresh**: Ensure RefreshState is emitted after success

## Example Log Sequence (Success)
```
🔵 [UI] تأكيد اللاعب button clicked
🔵 [UI] Player ID: 123, Name: Ahmed
🔵 [UI] Match ID: 456
🟢 [BottomSheet] Confirm button clicked in bottom sheet
🟢 [BottomSheet] Selected payment method: cash
🔵 [UI] Payment method selected: cash
🔵 [UI] Calling MatchDetailsCubit.apcense with params
🟡 [Cubit] apcense method called
🟡 [Cubit] Parameters received: subscriber_id: 123, paymentMethod: cash, matchid: 456
🟡 [Cubit] Calling repository apsence method...
🔴 [Repository] apsence method called
🔴 [Repository] Request details: POST /presence/456
🔴 [Repository] Body: {payment_method: cash, subscriber_id: 123}
🔴 [Repository] Sending POST request...
🔴 [Repository] Response received - statusCode: 200
✅ [Repository] Success: Request completed successfully
✅ [Cubit] Success: apsence returned successfully
🟡 [Cubit] Emitting RefreshState to reload subscribers
```

## Files Modified
1. `lib/features/matchdetails/presentaion/screens/players_screen_supervisor.dart`
2. `lib/features/matchdetails/cubit/matchdetails_cubit.dart`
3. `lib/features/matchdetails/domain/repositories/match_details_repo.dart`
