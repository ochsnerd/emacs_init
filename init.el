(require 'package)

(add-to-list 'package-archives
       '("melpa" . "http://melpa.org/packages/") t)

(package-initialize)

(add-to-list 'load-path "~/emacs_init/manual_packages")

(use-package evil
  :ensure t
  :init
    (setq evil-move-cursor-back t
          evil-move-beyond-eol t
          evil-want-fine-undo t)
  :config
    (evil-mode)
    (define-key evil-insert-state-map (kbd "C-a") 'beginning-of-line)
    (define-key evil-insert-state-map (kbd "C-e") 'end-of-line)
    (define-key evil-normal-state-map (kbd "C-h") 'evil-window-left)
    (define-key evil-normal-state-map (kbd "C-j") 'evil-window-down)
    (define-key evil-normal-state-map (kbd "C-k") 'evil-window-up)
    (define-key evil-normal-state-map (kbd "C-l") 'evil-window-right)

    (evil-ex-define-cmd "ls" 'helm-mini)

    (defalias #'forward-evil-word #'forward-evil-symbol)

;; What's wrong here? difference between define-key vs bind-key
;;  :bind
;;    (:map evil-normal-state-map
;;      ("C-a" . beginning-of-line))
)

;; (use-package evil-collection)

(use-package yasnippet
  :init
    (setq yas-snippet-dirs '("~/emacs_init/snippets"))
  :config
    (yas-global-mode 1))

(use-package better-defaults)

(use-package material-theme)

(use-package fill-column-indicator)

(use-package highlight-symbol)

(use-package powerline)

(use-package spaceline
  :config
    (spaceline-spacemacs-theme))

(use-package linum-relative
  :init
    (setq linum-relative-current-symbol "")	     
  :config
    (linum-mode)
    (linum-relative-global-mode))

(use-package helm
  :config
    (require 'helm-config)
    (helm-mode 1)
    (global-set-key (kbd "M-x") #'helm-M-x)
    (global-set-key (kbd "C-x r b") #'helm-filtered-bookmarks)
    (global-set-key (kbd "C-x C-f") #'helm-find-files))

(use-package magit)
(use-package evil-magit
  :config
    (global-set-key (kbd "C-x g") 'magit-status))

;; Python
(use-package elpy
  :ensure t
  :init
  (elpy-enable)
  (setq elpy-rpc-virtualenv-path 'current)
  ;; so this is not very portable
  (setq venv-location "~/anaconda3/envs")
  )

;; C++
(add-hook 'c++-mode-hook
          (lambda () (local-set-key (kbd "C-c c") 'compile)))

;; Orgmode
(use-package org
  :config
  (add-to-list 'org-latex-packages-alist '("" "minted"))
  (setq org-latex-listings 'minted)
  (setq org-latex-prefer-user-labels t)
)

(use-package ox-bibtex
  :init
  (setq org-latex-pdf-process
        '("pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"
          "bibtex %b"
          "pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"
          "pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"))
)

;; Visual changes
(set-frame-font "hack 11" nil t)

(setq inhibit-startup-message t)

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

;; Highlight all occurences of the word under the point
(add-hook 'prog-mode-hook #'highlight-symbol-mode)

;; Global changes
;; Make backups into .saves
(setq
  backup-by-copying t                                     ; don't clobber symlinks
  backup-directory-alist '(("." . "~/.saves/"))
  delete-old-versions t
  kept-new-versions 6
  kept-old-versions 2
  version-control t                                       ; use versioned backups
  auto-save-file-name-transforms '((".*" "~/.saves/" t))  ; Make autosaves into .saves
  create-lockfiles nil                                    ; Don't create lockfiles
  mouse-yank-at-point t                                   ; Copy to point, not mouse click
  confirm-kill-emacs 'y-or-n-p                            ; Always ask before closing
)

;; Delete selection on any input
(delete-selection-mode 1)

;; Keybindings for mac
(when (string-equal system-type "darwin")
  ;; This seems ugly, but works,  soo...
  (global-set-key (kbd "§") (lambda () (interactive) (insert "[")))
  (global-set-key (kbd "‘") (lambda () (interactive) (insert "]")))
  (global-set-key (kbd "æ") (lambda () (interactive) (insert "{")))
  (global-set-key (kbd "¶") (lambda () (interactive) (insert "}")))

  (global-set-key (kbd "M-<backspace>") 'delete-forward-char)

  (setq mac-option-key-is-meta nil)
  (setq mac-command-key-is-meta t)
  (setq mac-command-modifier 'meta)
  (setq mac-option-modifier nil)
)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (virtualenvwrapper better-defaults evil-magit fill-column-indicator highlight-symbol linum-relative magit material-theme powerline-evil spaceline evil use-package)))
 '(safe-local-variable-values
   (quote
    ((org-todo-keyword-faces
      ("TODO" :foreground "#f9f7f7" :background "#8e1d1d" :weight bold)
      ("DOING" :foreground "#f9f7f7" :background "#09bfad" :weight bold)
      ("WAIT" :foreground "#f9f7f7" :background "#a35706" :weight bold)
      ("DONE" :foreground "#154702" :background "#1b770d"))))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((((class color) (min-colors 89)) (:foreground "#ffffff" :background "#263238")))))
