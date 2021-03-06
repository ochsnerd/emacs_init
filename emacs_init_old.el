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
 '(package-selected-packages
   (quote
    (flymd spaceline helm evil-magit magit yasnippet s pyvenv py-autopep8 powerline-evil popup material-theme linum-relative highlight-symbol highlight-indentation find-file-in-project fill-column-indicator egg csv-mode company better-defaults async)))
 '(safe-local-variable-values
   (quote
    ((org-todo-keyword-faces
      ("TODO" :foreground "#f9f7f7" :background "#8e1d1d" :weight bold)
      ("DOING" :foreground "#f9f7f7" :background "#09bfad" :weight bold)
      ("WAIT" :foreground "#f9f7f7" :background "#a35706" :weight bold)
      ("DONE" :foreground "#154702" :background "#1b770d"))
     (org-todo-keyword-faces
      ("TODO" :foreground "white" :background "red")
      ("DOING" . "orange")
      ("WAIT" . "yellow")
      ("DONE" . "green"))))))
 
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
    evil
    evil-collection
    csv-mode
    powerline
    spaceline
    linum-relative
    yasnippet
    helm
    magit
    evil-magit
    elpy
    flymd
    ))

(mapc #'(lambda (package)
    (unless (package-installed-p package)
      (package-install package)))
      myPackages)

;; Manually load backported elpy package
;; clone the repo to the path below, checkout the backport branch
;;(add-to-list 'load-path "~/.emacs.d/lisp/elpy")
;;(load "elpy")


;; CUSTOMIZATION----------------------------------------------------------------
;; yasnippets
(setq yas-snippet-dirs
      '("~/emacs_init/snippets"                 ;; personal snippets
        ))
(yas-global-mode 1)

;; use ibuffer instead of list-buffers
(defalias 'list-buffers 'ibuffer)

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

;; Copy to point, not mouse click
(setq mouse-yank-at-point t)

;; Kill the daemon humanely
;; define function to shutdown emacs server instance
(defun server-shutdown ()
  "Save buffers, Quit, and Shutdown (kill) server"
  (interactive)
  (save-some-buffers)
  (kill-emacs)
  )

;; Always ask before closing
(setq confirm-kill-emacs 'y-or-n-p)

;; Fill line
(defun fill-to-end (char)
  (interactive "cFill Character:")
  (save-excursion
    (end-of-line)
    (while (< (current-column) 79)
      (insert-char char))))

;; Visual changes -----------------------------------------------------------------------
;; Powerline
(require 'powerline)
(require 'spaceline-config)
(spaceline-spacemacs-theme)

;; Font
;; (add-to-list 'default-frame-alist '(font . "Bitstream Vera Sans Mono Roman-11" ))

;; Hide the startup message
(setq inhibit-startup-message t)

;; Load material theme in a way that it works with the daemon
(if (daemonp)
    (add-hook 'after-make-frame-functions
        (lambda (frame)
            (select-frame frame)
            (load-theme 'material t)))
    (load-theme 'material t))

;; Enable line numbers globally
(linum-mode)
(linum-relative-global-mode)
(setq linum-relative-current-symbol "")

;; Disable menu & tool bar
(menu-bar-mode -1)
(tool-bar-mode -1)

;; Disable scroll bar
(scroll-bar-mode -1)

;; Highlight matching parentheses
(show-paren-mode)

;; Highlight all occurences of the word under the point
(add-hook 'prog-mode-hook #'highlight-symbol-mode)

;; Control inital window size
(add-to-list 'initial-frame-alist '(width . 85))

;; Delete selection on any input
(delete-selection-mode 1)

;; Mode specific changes----------------------------------------------------------------
;; evil-mode----------------------------------------------------------------------------
(setq evil-want-integration t)  ;; for evil-collection
(setq evil-want-keybinding nil) ;; ^
(require 'evil)
(evil-mode 1)

(setq evil-move-cursor-back t
      evil-move-beyond-eol t
      evil-want-fine-undo t)

(define-key evil-insert-state-map (kbd "C-a") 'beginning-of-line)
(define-key evil-insert-state-map (kbd "C-e") 'end-of-line)
(define-key evil-normal-state-map (kbd "C-h") 'evil-window-left)
(define-key evil-normal-state-map (kbd "C-j") 'evil-window-down)
(define-key evil-normal-state-map (kbd "C-k") 'evil-window-up)
(define-key evil-normal-state-map (kbd "C-l") 'evil-window-right)

;; Treat _ as part of a word
;; https://emacs.stackexchange.com/a/20717
(with-eval-after-load 'evil
    (defalias #'forward-evil-word #'forward-evil-symbol))
    
(when (require 'evil-collection nil t)
  (evil-collection-init))
(setq evil-collection-setup-minibuffer t)

;; use ibuffer for :ls
(evil-ex-define-cmd "ls" 'ibuffer)

;; evil-specific powerline
;; (require 'powerline-evil)
;; (powerline-evil-vim-color-theme)

;; magit -------------------------------------------------------------------------------
(require 'magit)
(require 'evil-magit)
(global-set-key (kbd "C-x g") 'magit-status)

;; helm --------------------------------------------------------------------------------
(require 'helm-config)
(global-set-key (kbd "M-x") #'helm-M-x)
(global-set-key (kbd "C-x r b") #'helm-filtered-bookmarks)
(global-set-key (kbd "C-x C-f") #'helm-find-files)

(helm-mode 1)

;; python-mode -------------------------------------------------------------------------
(elpy-enable)

;; Highlight lines over 79 chars long in python mode
(require 'whitespace)
(add-hook 'python-mode-hook
    (lambda ()
        (progn
            (setq whitespace-line-column 79)
            (setq whitespace-style '(face lines-tail))
            (whitespace-mode))))
            
;; flymd (render markup in browser)-----------------------------------------------------
(require 'flymd)
(setq flymd-close-buffer-delete-temp-files t)

;; f90-mode ----------------------------------------------------------------------------
(eval-after-load 'f90
  '(define-key f90-mode-map (kbd "M-A") 'f90-beginning-of-subprogram))
(eval-after-load 'f90
  '(define-key f90-mode-map (kbd "M-E") 'f90-end-of-subprogram))
(eval-after-load 'f90
  '(define-key f90-mode-map (kbd "M-a") 'f90-beginning-of-block))
(eval-after-load 'f90
  '(define-key f90-mode-map (kbd "M-e") 'f90-end-of-block))

;; Fill line with whitespace and line contiuation at column 80
(defun insert-line-continuation ()
  (interactive)
  (save-excursion
    (end-of-line)
    (while (< (current-column) 79)
      (insert-char ? ))
    (insert-char ?&)))

(eval-after-load 'f90
  '(define-key f90-mode-map (kbd "M-c") 'insert-line-continuation))

(add-hook 'f90-mode-hook
  (function (lambda ()
    (setq indent-tabs-mode nil
          tab-width 2))))

(setq f90-do-indent 2
      f90-if-indent 2
      f90-type-indent 2
      f90-program-indent 2)

;; Org-mode ----------------------------------------------------------------------------
;; Babel
(org-babel-do-load-languages
 'org-babel-load-languages
 '(
   (python . t)
   ))

(setq org-src-fontify-natively t)

;; DONE if all children are DONE
(defun org-summary-todo (n-done n-not-done)
  "Switch entry to DONE when all subentries are done, to TODO otherwise."
  (let (org-log-done org-log-states)   ; turn off logging
    (org-todo (if (= n-not-done 0) "DONE" "TODO"))))

(add-hook 'org-after-todo-statistics-hook 'org-summary-todo)

;; Keybinds for different platforms ----------------------------------------------------
(when (string-equal (system-name) "SHADOW-2J5B09AG")
  (define-key key-translation-map [(control meta ?p)] [?\[])
  (define-key key-translation-map [(control meta ?ü)] [?\]])
  (define-key key-translation-map [(control meta ?ö)] [?\{])
  (define-key key-translation-map [(control meta ?ä)] [?\}])
  (define-key key-translation-map [(control meta ?3)] [?\#])
  (define-key key-translation-map [(control meta ?<)] [?\\])

  (global-set-key (kbd "M-<backspace>") 'delete-forward-char)
  )
