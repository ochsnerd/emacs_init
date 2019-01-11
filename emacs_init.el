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
 '(inhibit-default-init t)
 '(safe-local-variable-values (quote ((org-todo-keyword-faces ("TODO" :foreground "#f9f7f7" :background "#8e1d1d" :weight bold) ("DOING" :foreground "#f9f7f7" :background "#09bfad" :weight bold) ("WAIT" :foreground "#f9f7f7" :background "#a35706" :weight bold) ("DONE" :foreground "#154702" :background "#1b770d")) (org-todo-keyword-faces ("TODO" :foreground "white" :background "red") ("DOING" . "orange") ("WAIT" . "yellow") ("DONE" . "green"))))))
 
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


;; PACKAGES -------------------------------------------------------------
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

;; Manually load backported elpy package
;; clone the repo to the path below, checkout the backport branch
(add-to-list 'load-path "~/.emacs.d/lisp/elpy")
(load "elpy")
(elpy-enable)

;; CUSTOMIZATION----------------------------------------------------------------
;; yasnippets
(setq yas-snippet-dirs
      '("~/emacs_init/snippets"                 ;; personal snippets
        ))
(yas-global-mode 1)

;; Make backups into .saves
(setq
  backup-by-copying t      ; don't clobber symlinks
  backup-directory-alist
    '(("." . "~/.saves/"))
  delete-old-versions t
  kept-new-versions 6
  kept-old-versions 2
  version-control t)       ; use versioned backups

;; Make autosaves into .saves
(setq auto-save-file-name-transforms
  '((".*" "~/.saves/" t)))

;; Don't create lockfiles
(setq create-lockfiles nil)

;; Visual changes -----------------------------------------------------------------------
;; Hide the startup message
(setq inhibit-startup-message t)

;; Load material theme
(load-theme 'material t)

;; Enable line numbers globally 
(global-linum-mode t)

;; Disable menu & tool bar
;; (menu-bar-mode -1)
(tool-bar-mode -1)

;; Highlight matching parentheses
(show-paren-mode)

;; Highlight all occurences of the word under the point
(add-hook 'prog-mode-hook #'highlight-symbol-mode)

;; Control inital window size
(add-to-list 'initial-frame-alist '(width . 85))

;; Delete selection on any input
(delete-selection-mode 1)

;; Mode specific changes----------------------------------------------------------------
;; python-mode -------------------------------------------------------------------------
;; Highlight lines over 79 chars long in python mode
(require 'whitespace)
(add-hook 'python-mode-hook
    (lambda ()
        (progn
            (setq whitespace-line-column 79)
            (setq whitespace-style '(face lines-tail))
            (whitespace-mode))))

;; f90-mode ----------------------------------------------------------------------------
(eval-after-load 'f90
  '(define-key f90-mode-map (kbd "M-A") 'f90-beginning-of-subprogram))
(eval-after-load 'f90
  '(define-key f90-mode-map (kbd "M-E") 'f90-end-of-subprogram))
(eval-after-load 'f90
  '(define-key f90-mode-map (kbd "M-a") 'f90-beginning-of-block))
(eval-after-load 'f90
  '(define-key f90-mode-map (kbd "M-e") 'f90-end-of-block))



;; Org-mode ----------------------------------------------------------------------------
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
