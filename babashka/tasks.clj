#!/usr/bin/env -S bb -x tasks/main
(ns tasks
  (:require [babashka.cli :as cli]))

(defn main
  {:org.babashka/cli
   {:args->opts [:this-file :url]
    :spec
    {:help {:alias :h
            :desc "Print help."}
     :from   {:ref          "<format>"
              :desc         "The input format. <format> can be edn, json or transit."
              :coerce       :keyword
              :alias        :i
              :default-desc "edn"
              :default      :edn}
     :paths  {:desc         "Paths of files to transform."
              :coerce       []
              :default      ["src" "test"]
              :default-desc "src test"}}}}
  [{:keys [this-file url help] :as m}]
  (cond
    (or help (not url))
    (let [msg (str "Usage: " this-file " [options] [url]\n"
                   "\n"
                   "Options:\n"
                   "%s")]
      (->> #'main meta :org.babashka/cli cli/format-opts (format msg) println))
    :else (prn m)))
