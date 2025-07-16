# SportVault Championship Smart Contract

A decentralized prediction market platform for competitive matchups with automated reward distribution on the Stacks blockchain.

## Overview

SportVault Championship is a smart contract that enables users to create prediction markets for competitive events, place wagers on outcomes, and automatically distribute rewards based on results. The platform provides a trustless environment for sports betting and prediction markets.

## Features

- **Matchup Creation**: Create prediction markets for competitive events
- **Stake Management**: Place wagers on team outcomes
- **Automated Resolution**: Time-based resolution system
- **Reward Distribution**: Automatic payout to winning participants
- **Configurable Parameters**: Adjustable wager limits and resolution delays

## Constants

### Error Constants
| Error | Code | Description |
|-------|------|-------------|
| `ERR-INVALID-MATCHUP-TIME` | u100 | Invalid timing for matchup creation |
| `ERR-MATCHUP-INACTIVE` | u101 | Matchup is not active |
| `ERR-MATCHUP-CLOSED` | u102 | Matchup betting is closed |
| `ERR-INVALID-STAKE` | u103 | Invalid stake amount |
| `ERR-MATCHUP-NOT-FOUND` | u104 | Matchup ID does not exist |
| `ERR-NOT-ENOUGH-TOKENS` | u105 | Insufficient token balance |
| `ERR-MATCHUP-ACTIVE` | u106 | Matchup is still active |
| `ERR-STAKE-NOT-FOUND` | u107 | Stake record not found |
| `ERR-MATCHUP-NOT-RESOLVED` | u108 | Matchup outcome not resolved |
| `ERR-STAKE-LOST` | u109 | Stake was on losing side |
| `ERR-MATCHUP-EXPIRED` | u110 | Matchup has expired |
| `ERR-MATCHUP-ALREADY-SETTLED` | u111 | Matchup already settled |
| `ERR-NOT-AUTHORIZED` | u112 | Not authorized to perform action |
| `ERR-WAGER-TOO-LOW` | u113 | Wager below minimum |
| `ERR-WAGER-TOO-HIGH` | u114 | Wager above maximum |
| `ERR-INVALID-PAYLOAD` | u115 | Invalid input parameters |

### Time Constants
- `MAX-BLOCKS-UNTIL-MATCHUP`: 52,560 blocks (~1 year maximum)
- `MIN-BLOCKS-UNTIL-MATCHUP`: 144 blocks (~1 day minimum)
- `MAX-BLOCKS-TO-RESOLVE`: 105,120 blocks (~2 years maximum)
- `MIN-TITLE-LENGTH`: 10 characters minimum for matchup titles

## Data Structures

### Matchup
```clarity
{
  title: (string-ascii 256),      // Matchup description
  outcome: (optional bool),       // Result: true/false/none
  lock-at: uint,                 // Block height when betting closes
  resolve-at: uint,              // Block height when resolution occurs
  created-by: principal          // Creator's address
}
```

### Stake
```clarity
{
  wager: uint,                   // Amount wagered
  team-choice: bool              // Team selection (true/false)
}
```

## Core Functions

### `sv-create-matchup`
Creates a new prediction market matchup.

**Parameters:**
- `title` (string-ascii 256): Description of the matchup
- `lock-at` (uint): Block height when betting closes

**Returns:**
- `(ok uint)`: Matchup ID on success
- `(err uint)`: Error code on failure

**Example:**
```clarity
(sv-create-matchup "Team A vs Team B Championship" u1000000)
```

## Configuration Variables

### Platform Settings
- `sv-platform-name`: "SportVault Championship"
- `sv-next-matchup-id`: Auto-incrementing matchup counter
- `sv-league-admin`: Admin principal (initially contract deployer)

### Matchup Settings
- `sv-resolution-delay`: Default time between lock and resolution (10,000 blocks)
- `sv-min-wager`: Minimum wager amount (10 tokens)
- `sv-max-wager`: Maximum wager amount (1,000,000 tokens)

## Usage Flow

1. **Create Matchup**: Admin or authorized user creates a new matchup
2. **Place Stakes**: Users place wagers on their predicted outcomes
3. **Betting Closes**: No more stakes accepted after lock-at block
4. **Resolution**: Outcome is determined and recorded
5. **Rewards**: Winners can claim their proportional rewards

## Validation Rules

### Matchup Creation
- Title must be 10-256 characters
- Lock time must be 144-52,560 blocks in the future
- Resolution time must be after lock time and within 105,120 blocks

### Wager Placement
- Amount must be between configured min/max values
- Matchup must be active and not locked
- User must have sufficient token balance

## Security Features

- Time-based validation prevents manipulation
- Principal-based authorization
- Stake tracking prevents double-spending
- Automatic resolution prevents indefinite markets

## Development Status

This contract appears to be a foundational implementation with the following components:
- ✅ Error handling constants
- ✅ Time validation constants
- ✅ Data structures for matchups and stakes
- ✅ Basic matchup creation functionality
- ✅ Validation functions
- ⚠️ Stake placement functions (partial implementation shown)
- ⚠️ Resolution mechanisms (not shown in provided code)
- ⚠️ Reward distribution (not shown in provided code)

## Installation & Deployment

1. Deploy the contract to Stacks blockchain
2. Configure admin settings if needed
3. Set appropriate wager limits
4. Begin creating matchups

## Contributing

When extending this contract, consider:
- Adding comprehensive stake placement functions
- Implementing resolution mechanisms
- Adding reward distribution logic
- Including emergency pause functionality
- Adding governance mechanisms

