;; .emacs

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(delete-selection-mode nil)
 '(diff-switches "-u")
 '(highlight-symbol-idle-delay 0.3)
 '(highlight-symbol-on-navigation-p t)
 '(inhibit-default-init t))
 
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


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
    highlight-symbol
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
;; clone the repo to the path below, checkout the backport branch
(add-to-list 'load-path "~/.emacs.d/lisp/elpy")
(load "elpy")
(elpy-enable)

;; Highlight lines over 80 chars long in python mode
(require 'whitespace)
(add-hook 'python-mode-hook
    (lambda ()
        (progn
            (setq whitespace-line-column 80)
            (setq whitespace-style '(face lines-tail))
            (whitespace-mode))))

;; Control inital window size
(add-to-list 'initial-frame-alist '(width . 85))

;; Highlight all occurences of the word under the point
(add-hook 'prog-mode-hook #'highlight-symbol-mode)

;; yasnippets
(setq yas-snippet-dirs
      '("~/emacs_init/snippets"                 ;; personal snippets
        ))

;; Disable menu & tool bar
;; (menu-bar-mode -1)
(tool-bar-mode -1)
(yas-global-mode 1) ;; or M-x yas-reload-all if you've started YASnippet already.

;; Highlight matching parentheses
(show-paren-mode)

;; Make backups into .saves
(setq
  backup-by-copying t      ; don't clobber symlinks
  backup-directory-alist
   '(("." . "~/.saves/"))    ; don't litter my fs tree
  delete-old-versions t
  kept-new-versions 6
  kept-old-versions 2
  version-control t)       ; use versioned backups

;; No toolbar
(tool-bar-mode -1)

;; org-mode
;; Babel
(org-babel-do-load-languages
 'org-babel-load-languages
 '(
   (python . t)
   (sh . t)
   ))

;; DONE if all children are DONE
(defun org-summary-todo (n-done n-not-done)
  "Switch entry to DONE when all subentries are done, to TODO otherwise."
  (let (org-log-done org-log-states)   ; turn off logging
    (org-todo (if (= n-not-done 0) "DONE" "TODO"))))

(add-hook 'org-after-todo-statistics-hook 'org-summary-todo)
