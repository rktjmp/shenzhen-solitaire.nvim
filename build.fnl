(let [{: build} (require :hotpot.api.make)]
  (build "./plugin"
         "(.+)" (fn [path] path)))

  ; (build "./fnl"
  ;        "(.+)/fnl/(.+)" (fn [head tail {: join-path}]
  ;                          (if (and (not (string.match tail "_internal"))
  ;                                   (not (string.match tail "test")))
  ;                             (join-path head :lua tail))))
  
  
