(import-macros {: use} :shenzhen-solitaire.lib.donut.use)

(use runtime :shenzhen-solitaire.ui.runtime
     {:format fmt} string)

(local hl-normal-background (let [{: background} (vim.api.nvim_get_hl_by_name :Normal true)
                                  hex (fmt "#%x" background)]
                              hex))
(local default-config {:card {:size {:width 7 :height 5}
                              :borders {:ne :╮ :nw :╭ :se :╯ :sw :╰ :n :─ :s :─ :e :│ :w :│}}
                              ;:borders {:ne :🭌 :nw :🭈 :se :🭘 :sw :🭢 :n :🮒 :s :🮃 :e :🮋 :w :🮋}}
                       :buttons {:pos {:row 1 :col 34}}
                       :tableau {:pos {:row 7 :col 1}
                                 :gap 3}
                       :cell {:pos {:row 1
                                    :col 1}
                              :gap 3}
                       :foundation {:pos {:row 1 :col 41}
                                    :gap 3}
                       :highlight {:empty {:fg :grey :bg hl-normal-background}
                                   :button {:fg :gray :bg hl-normal-background}
                                   :coin {:fg :#e8df78 :bg hl-normal-background}
                                   :string {:fg :#879ff6 :bg hl-normal-background}
                                   :myriad {:fg :#23b3ac :bg hl-normal-background}
                                   :flower {:fg :#934188 :bg hl-normal-background}
                                   :dragon-green {:fg :#52ad56 :bg hl-normal-background}
                                   :dragon-white {:fg :#cfcfcf :bg hl-normal-background}
                                   :dragon-red {:fg :#d34d4d :bg hl-normal-background}}
                       :info {:pos {:row 22 :col 3}}
                       :size {:width 80 :height 40}
                       :cursor {:show true} ;; show cursor, strongly recommended without a mouse
                       :difficulty {:show-valid-locations true ;; show possible interactive locations, useful without a mouse.
                                    :allow-undo false
                                    :auto-move-obvious true}
                       :keys {:left-mouse :<LeftMouse>
                              :right-mouse :<RightMouse>
                              :interact :y
                              :auto-move :a
                              :save-game :szw
                              :load-game :szl
                              :restart-game :szr
                              :undo-last-move :u
                              :next-location :<Tab>
                              :prev-location :<S-Tab>}})

(local M {})

(fn M.first-responder [thread event]
  (match (coroutine.resume thread :event event)
    (true [:ok _]) nil
    (true [:err e]) (error (.. e (debug.traceback thread)))
    (false e) (error (.. e (debug.traceback thread)))))

(fn M.start-new-game [buf-id ?config ?seed]
  (let [config (vim.tbl_deep_extend :force default-config (or ?config {}))
        game-thread (runtime.start-new-game buf-id M.first-responder config ?seed)]
    (assert (coroutine.resume game-thread :control :hello))))

(values M)
