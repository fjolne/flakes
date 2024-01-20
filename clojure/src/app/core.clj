(ns app.core
  "FIXME: Clojure project template")

(defn exec
  "Invoke me with clojure -X app.core/exec"
  [opts]
  (println "exec with" opts))

(defn -main
  "Invoke me with clojure -M -m app.core"
  [& args]
  (println "-main with" args))
