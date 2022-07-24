(let [{: build} (require :hotpot.api.make)]
  (build "./fnl"
         "(.+)/fnl/(.+)" (fn [head tail {: join-path}]
                           (join-path head :lua tail))))
