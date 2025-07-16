;; SportVault Championship Smart Contract
;; Unique prediction markets for competitive matchups and reward distribution.

;; Error Constants
(define-constant ERR-INVALID-MATCHUP-TIME (err u100))
(define-constant ERR-MATCHUP-INACTIVE (err u101))
(define-constant ERR-MATCHUP-CLOSED (err u102))
(define-constant ERR-INVALID-STAKE (err u103))
(define-constant ERR-MATCHUP-NOT-FOUND (err u104))
(define-constant ERR-NOT-ENOUGH-TOKENS (err u105))
(define-constant ERR-MATCHUP-ACTIVE (err u106))
(define-constant ERR-STAKE-NOT-FOUND (err u107))
(define-constant ERR-MATCHUP-NOT-RESOLVED (err u108))
(define-constant ERR-STAKE-LOST (err u109))
(define-constant ERR-MATCHUP-EXPIRED (err u110))
(define-constant ERR-MATCHUP-ALREADY-SETTLED (err u111))
(define-constant ERR-NOT-AUTHORIZED (err u112))
(define-constant ERR-WAGER-TOO-LOW (err u113))
(define-constant ERR-WAGER-TOO-HIGH (err u114))
(define-constant ERR-INVALID-PAYLOAD (err u115))

;; Time Constants
(define-constant MAX-BLOCKS-UNTIL-MATCHUP u52560)
(define-constant MIN-BLOCKS-UNTIL-MATCHUP u144)
(define-constant MAX-BLOCKS-TO-RESOLVE u105120)
(define-constant MIN-TITLE-LENGTH u10)

;; Core Platform Variables
(define-data-var sv-platform-name (string-ascii 50) "SportVault Championship")
(define-data-var sv-next-matchup-id uint u1)
(define-data-var sv-league-admin principal tx-sender)

;; Matchup Configurations
(define-data-var sv-resolution-delay uint u10000)
(define-data-var sv-min-wager uint u10)
(define-data-var sv-max-wager uint u1000000)

;; Matchup Storage
(define-map sv-matchups
  { id: uint }
  {
    title: (string-ascii 256),
    outcome: (optional bool),
    lock-at: uint,
    resolve-at: uint,
    created-by: principal
  }
)

;; Stake Storage
(define-map sv-stakes
  { matchup-id: uint, participant: principal }
  {
    wager: uint,
    team-choice: bool
  }
)

;; Private Validators
(define-private (sv-valid-matchup-id (matchup-id uint))
  (< matchup-id (var-get sv-next-matchup-id))
)

(define-private (sv-valid-title-length (title (string-ascii 256)))
  (and (>= (len title) MIN-TITLE-LENGTH) (<= (len title) u256))
)

(define-private (sv-valid-lock-time (lock-at uint))
  (let ((diff (- lock-at u0)))
    (and (>= diff MIN-BLOCKS-UNTIL-MATCHUP) (<= diff MAX-BLOCKS-UNTIL-MATCHUP))
  )
)

(define-private (sv-valid-resolve-time (lock-at uint) (resolve-at uint))
  (let ((delay (- resolve-at lock-at)))
    (and (> resolve-at lock-at) (<= delay MAX-BLOCKS-TO-RESOLVE))
  )
)

(define-private (sv-valid-wager (amount uint))
  (and (>= amount (var-get sv-min-wager)) (<= amount (var-get sv-max-wager)))
)

;; Public Function: Create a new Matchup
(define-public (sv-create-matchup (title (string-ascii 256)) (lock-at uint))
  (let
    (
      (matchup-id (var-get sv-next-matchup-id))
      (resolve-at (+ lock-at (var-get sv-resolution-delay)))
    )
    (asserts! (sv-valid-title-length title) ERR-INVALID-PAYLOAD)
    (asserts! (sv-valid-lock-time lock-at) ERR-INVALID-MATCHUP-TIME)
    (asserts! (sv-valid-resolve-time lock-at resolve-at) ERR-INVALID-MATCHUP-TIME)

    (begin
      (map-set sv-matchups
        { id: matchup-id }
        {
          title: title,
          outcome: none,
          lock-at: lock-at,
          resolve-at: resolve-at,
          created-by: tx-sender
        }
      )
      (var-set sv-next-matchup-id (+ matchup-id u1))
      (ok matchup-id)
    )
  )
)
