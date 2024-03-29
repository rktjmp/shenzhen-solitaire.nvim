(import-macros {: use} :shenzhen-solitaire.lib.donut.use)

(use runtime :shenzhen-solitaire.ui.runtime
     {:format fmt} string)


(local path-separator (string.match package.config "(.-)\n"))
(lambda join-path [head ...]
  (accumulate [t head _ part (ipairs [...])]
    (.. t path-separator part)))
(local gauntlet-path (join-path (vim.fn.stdpath :cache) :shenzhen-solitaire.gauntlet))
(fn read-gauntlet []
  (let [readable? (= 1 (vim.fn.filereadable gauntlet-path))
        seed (if readable? (dofile gauntlet-path) 1)]
    (values seed)))

(local M {})

(fn M.first-responder [thread event]
  (match (coroutine.resume thread :event event)
    (true [:ok _]) nil
    (true [:err e]) (error (.. e (debug.traceback thread)))
    (false e) (error (.. e (debug.traceback thread)))))

(fn M.start-next-game [buf-id ?config]
  (let [seed (read-gauntlet)
        config (or ?config {})]
    (tset config :gauntlet seed)
    (M.start-new-game buf-id config seed)))

(fn M.start-new-game [buf-id ?config ?seed]
  ;; set default inside call so we pickup on colorscheme changes between new games
  ;; not really worth an autocmd
  (local hl-normal-background (let [{: background} (vim.api.nvim_get_hl_by_name :Normal true)
                                    {: tohex} (require :bit)
                                    hex (fmt "#%s" (tohex background 6))]
                                hex))
  (local default-config
    {:card {:size {:width 7 :height 5}
            :borders {:ne :╮ :nw :╭ :se :╯ :sw :╰ :n :─ :s :─ :e :│ :w :│}}
     :buttons {:pos {:row 1 :col 34}}
     :tableau {:pos {:row 7 :col 1}
               :gap 3}
     :cell {:pos {:row 1
                  :col 1}
            :gap 3}
     :foundation {:pos {:row 1 :col 41}
                  :gap 3}
     :highlight {:empty {:fg :#495159 :bg hl-normal-background}
                 :button {:fg :#495159 :bg hl-normal-background}
                 :coin {:fg :#e8df78 :bg hl-normal-background}
                 :string {:fg :#879ff6 :bg hl-normal-background}
                 :myriad {:fg :#23b3ac :bg hl-normal-background}
                 :flower {:fg :#934188 :bg hl-normal-background}
                 :dragon-green {:fg :#52ad56 :bg hl-normal-background}
                 :dragon-white {:fg :#cfcfcf :bg hl-normal-background}
                 :dragon-red {:fg :#d34d4d :bg hl-normal-background}}
     :info {:pos {:row 22 :col 3}}
     :size {:width 80 :height 40}
     :cursor {:show false} ;; show cursor, strongly recommended without a mouse
     :difficulty {:show-valid-locations false ;; show possible interactive locations, useful without a mouse.
                  :allow-undo false
                  :auto-move-obvious true}
     :gauntlet false
     :keys {:left-mouse :<LeftMouse>
            :right-mouse :<RightMouse>
            :interact :y
            :auto-move :a
            :save-game :ww
            :load-game :ll
            :restart-game :rr
            :undo-last-move :u
            :next-location :<Tab>
            :prev-location :<S-Tab>}})
  (let [config (vim.tbl_deep_extend :force default-config (or ?config {}))
        thread (runtime.start-new-game buf-id M.first-responder config ?seed)]
    (match (coroutine.resume thread :control :hello)
      (true [:ok _]) nil
      (true [:err e]) (error (.. e "\n" (debug.traceback thread)))
      (false e) (error (.. e "\n" (debug.traceback thread))))))

(values M)
