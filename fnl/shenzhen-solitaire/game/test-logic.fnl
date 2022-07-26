(import-macros {: inspect! : must : suite : test : rerequire} :shenzhen-solitaire.lib.donut.test)

(local logic (require :shenzhen-solitaire.game.logic))

(fn playable-state []
  ;; seed 100 has some interesting properties
  ;; this is probably super implementation specific, tests are run
  ;; on lua-jit 2.1.0-beta3--3.4.0
  ;;
  ;; t 2 5 is green dragon
  ;; t 3 is flower coin 9 string 7
  ;; t 3 4 is string 8 coin 8
  ;; t 8 4 is myriad 3 string 2
  (logic.start-new-game 100))

(suite "starting a new game"
  [state (playable-state)]
  (test "returns a state"
    (must equal :table (type state)))
  (test "has shuffled the cards"
    (must equal 0 (length state.stock))
    (must match [5 5 5 5 5 5 5 5] (icollect [i _ (ipairs [1 2 3 4 5 6 7 8])]
                                    (length (. state.tableau i)))))
  (test "has some events"
    (must match [[:started-new-game]
                 [:shuffled-deck]
                 [:dealt-cards]] state.events)))

(suite "general move card constraints"
  [state (playable-state)]
  (test "wont move from the same slot and column to the same slot and column")
    ; [fs [#(logic.move-cards-ok? state [:tableau 1 5] [:tableau 1 5])
    ;      #(logic.move-cards-ok? state [:tableau 1 5] [:tableau 1 5])
    ;      #(logic.move-cards-ok? state [:tableau 1 4] [:tableau 1 5])
    ;      #(logic.move-cards-ok? state [:tableau 1 4] [:tableau 1 4])
    ;      #(logic.move-cards-ok? state [:cell 1 1] [:cell 1 1])]]
    ; (each [_ f (ipairs fs)]
    ;   (must match [:err "cant move from and to the same slot.col"] (f)))
    ; (must throw (logic.move-cards state [:tableau 1 5] [:tableau 1 5])))

  (test "wont accept bogus location data"
    (must throw (logic.move-cards state [:tableau 1 5] [:nothing 1 5]))
    (must throw (logic.move-cards state [:tableau 222 5] [:cell 1 1]))
    (must throw (logic.move-cards state [:cell 999 5] [:cell 1 1]))))

(suite "interacting with cells"
  [state (playable-state)]
  (test "puts a suited card in cell"
    [state (logic.move-cards state [:tableau 1 5] [:cell 1 1])]
    (must match [[:DRAGON-WHITE 0] [:MYRIAD 6] [:DRAGON-RED 0] [:MYRIAD 9] nil]
                (. state :tableau 1))
    (must match [[:STRING 6] nil]
          (. state.cell 1)))

  (test "puts a dragon in cell"
    [_ (tset state :tableau 1 [[:DRAGON-GREEN 0]])
     state (logic.move-cards state [:tableau 1 1] [:cell 1 1])]
    (must match [nil] (. state :tableau 1))
    (must match [[:DRAGON-GREEN 0] nil] (. state.cell 1)))

  (test "puts a flower in cell"
    ;; not illegal but unusual action
    [_ (tset state :tableau 1 [[:FLOWER 0]])
     state (logic.move-cards state [:tableau 1 1] [:cell 1 1])]
    (must match [nil] (. state :tableau 1))
    (must match [[:FLOWER 0] nil] (. state.cell 1)))

  (test "wont accept more than one card"
    (must match [:err "can only place one card on a cell"]
          (logic.move-cards-ok? state [:tableau 8 4] [:cell 1 1]))
    (must throw (logic.move-cards state [:tableau 8 4] [:cell 1 1])))

  (test "can move from cell to cell"
    [_ (tset state :cell 1 [[:STRING 8]])
     state (logic.move-cards state [:cell 1 1] [:cell 2 1])]
    (must match [nil] (. state.cell 1))
    (must match [[:STRING 8] nil] (. state.cell 2)))

  (test "cant move from empty cell"
    (must match [:err "from cell.1 card was invalid"]
                (logic.move-cards-ok? state [:cell 1 1] [:cell 2 1])))

  (test "cant move to occupied cell"
    [_ (tset state :cell 1 [[:STRING 8]])]
    [_ (tset state :cell 2 [[:STRING 1]])]
    (must match [:err "can only place into an empty cell"]
                (logic.move-cards-ok? state [:cell 1 1] [:cell 2 1]))))

(suite "collect-from-ok?"
  [state (playable-state)]
  (test "cant move dddd cell"
    [_ (tset state :cell 1 [[:DRAGON-RED 0 ] [:DRAGON-RED 0] [:DRAGON-RED 0] [:DRAGON-RED 0]])]
    (must match [:err "cant collect from locked cells"]
          (logic.collect-from-ok? state [:cell 1 1]))))

(suite "interacting with foundation"
  [state (playable-state)]
  (test "cant put card at 1 1 if there is a card at 1 1 or 1 2")
  (test "accepts value 1 card of any suit on empty foundation"
    (tset state :cell 1 [[:STRING 1]])
    (must match [:ok] (logic.move-cards-ok? state [:cell 1 1] [:foundation 1 1]))
    (tset state :cell 1 [[:COIN 1]])
    (must match [:ok] (logic.move-cards-ok? state [:cell 1 1] [:foundation 1 1]))
    (tset state :cell 1 [[:MYRIAD 1]])
    (must match [:ok] (logic.move-cards-ok? state [:cell 1 1] [:foundation 1 1])))
  (test "only accepts incrementing same suit cards on non empty foundation"
    [_ (tset state :foundation 1 [[:STRING 1]])
     _ (tset state :cell 1 [[:STRING 2]]) ;; TODO move nil to foundation
     new-state (logic.move-cards state [:cell 1 1] [:foundation 1 2])]
    (must match [:ok] (logic.move-cards-ok? state [:cell 1 1] [:foundation 1 2]))
    (must match [[:STRING 1] [:STRING 2]] (. new-state :foundation 1))
    (tset state :cell 1 [[:COIN 1]])
    (must match [:err "must place same suit and +1 value on existing foundation"]
                (logic.move-cards-ok? state [:cell 1 1] [:foundation 1 2]))
    (tset state :cell 1 [[:MYRIAD 1]])
    (must match [:err "must place same suit and +1 value on existing foundation"]
                (logic.move-cards-ok? state [:cell 1 1] [:foundation 1 2])))
  (test "wont move nothing to foundation"
    [_ (tset state :foundation 1 [[:STRING 1]])
     _ (tset state :cell 1 [])]
    (must match [:err "from cell.1 card was invalid"]
          (logic.move-cards-ok? state [:cell 1 1] [:foundation 1 2])))
  (test "wont accept special cards"
      (tset state :cell 1 [[:DRAGON-GREEN 0]])
      (must match [:err "may only place suited cards on foundation"]
            (logic.move-cards-ok? state [:cell 1 1] [:foundation 1 1]))
      (tset state :cell 1 [[:FLOWER 0]])
      (must match [:err "may only place suited cards on foundation"]
            (logic.move-cards-ok? state [:cell 1 1] [:foundation 1 1])))
  (test "only accepts one card"
    (tset state :tableau 1 [[:COIN 2] [:STRING 1]])
    (must match [:err "may only place one card at a time on a foundation"]
          (logic.move-cards-ok? state [:tableau 1 1] [:foundation 1 1])))
  (test "only accepts flower on flower foundation"
      (tset state :cell 1 [[:FLOWER 0]])
      (tset state :cell 2 [[:DRAGON-GREEN 0]])
      (tset state :cell 3 [[:STRING 1]])
      (must match [:ok]
            (logic.move-cards-ok? state [:cell 1 1] [:foundation 4 1]))
      (must match [:err "may only place flower card on flower foundation"]
            (logic.move-cards-ok? state [:cell 2 1] [:foundation 4 1]))
      (must match [:err "may only place flower card on flower foundation"]
            (logic.move-cards-ok? state [:cell 3 1] [:foundation 4 1]))))

(suite "interacting with tableau"
  [state (playable-state)]
  (test "can pick up one card from any column"
    [_ (tset state :tableau 1 [[:STRING 1] [:COIN 1]])
     _ (tset state :tableau 2 [[:STRING 2] [:DRAGON-GREEN 0]])
     _ (tset state :tableau 3 [[:FLOWER 0]])]
    (must match [:ok]
          (logic.move-cards-ok? state [:tableau 1 2] [:cell 1 1]))
    (must match [:ok]
          (logic.move-cards-ok? state [:tableau 2 2] [:cell 1 1]))
    (must match [:ok]
          (logic.move-cards-ok? state [:tableau 3 1] [:cell 1 1])))
  (test "can pick up a valid sequence"
    [_ (tset state :tableau 1 [[:DRAGON-GREEN 0] [:STRING 2] [:COIN 1]])
     _ (tset state :tableau 2 [[:STRING 4] [:COIN 3]])
     _ (tset state :tableau 3 [[:STRING 2] [:MYRIAD 1]])
     _ (tset state :tableau 8 [])]
    (must match [:ok]
          (logic.move-cards-ok? state [:tableau 1 2] [:tableau 8 1]))
    (must match [:ok]
          (logic.move-cards-ok? state [:tableau 3 1] [:tableau 2 3])))
  (test "cant pick up an invalid sequence"
    [_ (tset state :tableau 1 [[:STRING 2] [:DRAGON-GREEN 0] [:COIN 1]])
     _ (tset state :tableau 2 [[:STRING 2] [:MYRIAD 1] [:COIN 1]])
     _ (tset state :tableau 8 [])]
    (must match [:err "may only collect alternating suit descending sequences"]
          (logic.move-cards-ok? state [:tableau 1 2] [:tableau 8 1]))
    (must match [:err "may only collect alternating suit descending sequences"]
          (logic.move-cards-ok? state [:tableau 2 2] [:tableau 8 1]))
    (must match [:err "may only collect alternating suit descending sequences"]
          (logic.move-cards-ok? state [:tableau 2 1] [:tableau 8 1])))
  (test "cant put down an invalid sequence"
    [_ (tset state :tableau 1 [[:STRING 4] [:STRING 3]])
     _ (tset state :tableau 2 [[:STRING 2] [:MYRIAD 1]])]
    (must match [:err "must create alternating suit descending sequence"]
          (logic.move-cards-ok? state [:tableau 2 1] [:tableau 1 3])))
  (test "cant move from invalid card location"
    [_ (tset state :tableau 1 [[:STRING 1] [:COIN 1]])]
    (must match [:err "from tableau.1 card was invalid"]
          (logic.move-cards-ok? state [:tableau 1 3] [:cell 1 1])))
  (test "cant put specials down except in vacant columns"
    [_ (tset state :tableau 1 [[:DRAGON-GREEN 0]])
     _ (tset state :tableau 2 [[:STRING 2] [:MYRIAD 1] [:COIN 1]])
     _ (tset state :tableau 8 [])]
    (must match [:ok]
          (logic.move-cards-ok? state [:tableau 1 1] [:tableau 8 1]))
    (must match [:err "must create alternating suit descending sequence"]
          (logic.move-cards-ok? state [:tableau 1 1] [:tableau 2 4]))))

(suite "locking dragons"
  [state (playable-state)]
  (unpack (icollect [n k (pairs {:green :DRAGON-GREEN :red :DRAGON-RED :white :DRAGON-WHITE})]
      (test (string.format "will lock for %s dragon" n)
        [_ (tset state :tableau 1 [[k 0]])
         _ (tset state :tableau 2 [[k 0]])
         _ (tset state :tableau 3 [[k 0]])
         _ (tset state :tableau 4 [[k 0] [:MYRIAD 1]])
         _ (tset state :tableau 5 [])
         _ (tset state :tableau 6 [])
         _ (tset state :tableau 7 [])
         _ (tset state :tableau 8 [])]
        (must match [:err] (logic.lock-dragons-ok? state k))
        (tset state :tableau 4 [[k 0]])
        (must match [:ok] (logic.lock-dragons-ok? state k))
        (let [state (logic.lock-dragons state k)]
          (must match [[k 0] [k 0] [k 0] [k 0] nil] (. state :cell 1))))))
  (test "puts dragons in left most unoccupied cell"
    [_ (tset state :tableau 1 [[:DRAGON-RED 0]])
     _ (tset state :tableau 2 [[:DRAGON-RED 0]])
     _ (tset state :tableau 3 [[:DRAGON-RED 0]])
     _ (tset state :tableau 4 [[:DRAGON-RED 0]])
     _ (tset state :tableau 5 [])
     _ (tset state :tableau 6 [])
     _ (tset state :tableau 7 [])
     _ (tset state :tableau 8 [])
     _ (tset state :cell 1 [[:MYRIAD 1]])
     state (logic.lock-dragons state :DRAGON-RED)]
    (must match [[:MYRIAD 1] nil] (. state :cell 1))
    (must match [nil] (. state :tableau 1))
    (must match [nil] (. state :tableau 2))
    (must match [nil] (. state :tableau 3))
    (must match [nil] (. state :tableau 4)))
  (test "can lock if cells are occupied by dragon"
    [_ (tset state :tableau 1 [[:DRAGON-RED 0]])
     _ (tset state :tableau 2 [[:DRAGON-RED 0]])
     _ (tset state :tableau 3 [])
     _ (tset state :tableau 4 [])
     _ (tset state :tableau 5 [])
     _ (tset state :tableau 6 [])
     _ (tset state :tableau 7 [])
     _ (tset state :tableau 8 [])
     _ (tset state :cell 1 [[:DRAGON-RED 0]])
     _ (tset state :cell 2 [[:DRAGON-RED 0]])
     state (logic.lock-dragons state :DRAGON-RED)]
    (must match [[:DRAGON-RED 0] [:DRAGON-RED 0] [:DRAGON-RED 0] [:DRAGON-RED 0] nil] (. state :cell 1))
    (must match [nil] (. state :cell 2)))
  (test "cant lock if no cells are free"
    [_ (tset state :tableau 1 [[:DRAGON-RED 0]])
     _ (tset state :tableau 2 [[:DRAGON-RED 0]])
     _ (tset state :tableau 3 [[:DRAGON-RED 0]])
     _ (tset state :tableau 4 [[:DRAGON-RED 0]])
     _ (tset state :tableau 5 [])
     _ (tset state :tableau 6 [])
     _ (tset state :tableau 7 [])
     _ (tset state :tableau 8 [])
     _ (tset state :cell 1 [[:MYRIAD 1]])
     _ (tset state :cell 2 [[:MYRIAD 2]])
     _ (tset state :cell 3 [[:MYRIAD 3]])]
    (must match [:err "no free cell"] (logic.lock-dragons-ok? state :DRAGON-RED))))

(suite "auto-move"
  [state (playable-state)]
  (test "it finds an auto-move"
    ;; simple card to first foundation
    (for [i 1 8] (tset state :tableau i []))
    (tset state :tableau 1 [[:STRING 1]])
    (must match [:ok {:from [:tableau 1 1] :to [:foundation 1 1]}] (logic.auto-move-ok? state))
    ;; to second foundation, second card
    (for [i 1 8] (tset state :tableau i []))
    (tset state :tableau 2 [[:STRING 3] [:STRING 2]])
    (tset state :foundation 2 [[:STRING 1]])
    (must match [:ok {:from [:tableau 2 2] :to [:foundation 2 2]}] (logic.auto-move-ok? state))
    ;; flower
    (for [i 1 8] (tset state :tableau i []))
    (tset state :tableau 2 [[:STRING 3] [:FLOWER 0]])
    (tset state :cell 2 [[:STRING 1]])
    (must match [:ok {:from [:tableau 2 2] :to [:foundation 4 1]}] (logic.auto-move-ok? state)))
  (test "it finds no moves"
    ;; literally no move
    (for [i 1 8] (tset state :tableau i []))
    (tset state :tableau 2 [[:STRING 1] [:STRING 3]])
    (tset state :cell 2 [[:STRING 2]])
    (must match [:err "no auto-move found"] (logic.auto-move-ok? state))
    ;; looks like there is a move, but we have a card on the board that is of lower value
    (for [i 1 8] (tset state :tableau i []))
    (tset state :tableau 2 [[:MYRIAD 1] [:STRING 3]])
    (tset state :cell 2 [[:STRING 2]])
    (tset state :foundation 1 [[:STRING 1]])
    (must match [:err "no auto-move found"] (logic.auto-move-ok? state)))
  (test "it only returns one auto-move from the left most side, starting with cells"))

