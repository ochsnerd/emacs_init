;; .emacs

(custom-set-variables
 ;; uncomment to always end a file with a newline
 ;'(require-final-newline t)
 ;; uncomment to disable loading of "default.el" at startup
 '(inhibit-default-init t)
 ;; default to unified diffs
 '(diff-switches "-u"))


;; INSTALL PACKAGES

(require 'package)

(add-to-list 'package-archives
       '("melpa" . "http://melpa.org/packages/") t)

(package-initialize)
(when (not package-archive-contents)
  (package-refresh-contents))

(defvar myPackages
  '(better-defaults
    material-theme
    fill-column-indicator
    ;; Manually load dependencies for elpy; need to install 's' by hand from melpa
    highlight-indentation
    yasnippet
    company
    pyvenv
    find-file-in-project))

(mapc #'(lambda (package)
    (unless (package-installed-p package)
      (package-install package)))
      myPackages)


;; BASIC CUSTOMIZATION

(setq inhibit-startup-message t) ;; hide the startup message
(load-theme 'material t) ;; load material theme
(global-linum-mode t) ;; enable line numbers globally

;; Manually load backported elpy package
(add-to-list 'load-path "~/.emacs.d/lisp/elpy")
(load "elpy")
(elpy-enable)

;; Highlight lines over 80 long
(setq-default
 whitespace-line-column 80
 whitespace-style       '(face lines-tail))
(add-hook 'prog-mode-hook #'whitespace-mode)

;; Control inital window size
(add-to-list 'initial-frame-alist '(width . 85))
