;; -----------------------------------------------------
;; Emacs custom configuration
;;
;; Detail : This configuration file written for Emacs 27.1
;;          some functions and macros may not be work for earlier version.

;; Author : Borahan Ilgar
;; Date   : 31/11/2021
;; -----------------------------------------------------------

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(company-c-headers-path-system
   (custom-set-faces
    '(mode-line
      ((t
	(:background "blue" :foreground "whitedark slate gray"))))))
 '(custom-safe-themes
   '("cf856c10886059898685bfdba0c2b0e1416562475e8f47d29a60aa10c264d42e" default))
 '(mode-line
   ((t
     (:background "blue" :foreground "whitedark slate gray"))))
 '(package-selected-packages
   '(yasnippet-snippets which-key vs-light-theme vs-dark-theme use-package rainbow-delimiters neotree modern-cpp-font-lock lsp-ivy ivy-rich helpful ggtags flycheck exec-path-from-shell evil-nerd-commenter doom-modeline counsel-projectile command-log-mode)))

(setq inhibit-startup-message t)

(scroll-bar-mode -1)        ; Disable visible scrollbar
(tool-bar-mode -1)          ; Disable the toolbar
(tooltip-mode -1)           ; Disable tooltips
(set-fringe-mode 10)        ; Give some breathing room

(menu-bar-mode -1)            ; Disable the menu bar

;; Set up the visible bell
(setq visible-bell t)

(set-face-attribute 'default nil :font "Cascadia Code" :height 90)

;; Make ESC quit prompts
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

;; TODO: set compile configuration for MSVC/CMake/Makefile 
(global-set-key (kbd "M-m") 'compile)

;; switch between header & source file
(global-set-key (kbd "M-o") 'ff-find-other-file)

(load-theme 'vs-dark)
;; Highlight current line
(global-hl-line-mode 1)
(set-face-attribute 'hl-line nil :inherit nil :background "gray6")

;; Fucking hate backup files.
(setq make-backup-files nil)
(setq create-lockfiles nil)

;; Add line number
(column-number-mode)
(global-display-line-numbers-mode t)

;; Disable line numbers for some modes
(dolist (mode '(org-mode-hook
		term-mode-hook
		eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

;; Initialize package sources
(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; Initialize use-package on non-Linux platforms
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

;; WTF is C-x u anyway
(global-set-key (kbd "C-z") 'undo-only)

;; File search & open 
(defun browse-file-directory ()
  "Open the current file's directory however the OS would."
  (interactive)
  (if default-directory
      (browse-url-of-file (expand-file-name default-directory))
    (error "No `default-directory' to open")))
(global-set-key (kbd "C-o") 'browse-file-directory)

;; explain emacs key-bindings 
(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 0.2))

;; ivy-config
(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
         :map ivy-minibuffer-map
         ("TAB" . ivy-alt-done)	
         ("C-l" . ivy-alt-done)
         ("C-j" . ivy-next-line)
         ("C-k" . ivy-previous-line)
         :map ivy-switch-buffer-map
         ("C-k" . ivy-previous-line)
         ("C-l" . ivy-done)
         ("C-d" . ivy-switch-buffer-kill)
         :map ivy-reverse-i-search-map
         ("C-k" . ivy-previous-line)
         ("C-d" . ivy-reverse-i-search-kill))
  :config
  (ivy-mode 1))

(use-package ivy-rich
  :init
  (ivy-rich-mode 1))

(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  :custom ((projectile-completion-system 'ivy))
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  ;; NOTE: Set this to the folder where you keep your Git repos!
  (when (file-directory-p "C:\\Work\\Source")
    (setq projectile-project-search-path '("C:\\Work\\Source")))
  (setq projectile-switch-project-action #'projectile-dired))

(use-package counsel-projectile
  :config (counsel-projectile-mode))

(use-package counsel
  :bind (("C-M-j" . 'counsel-switch-buffer)
         :map minibuffer-local-map
         ("C-r" . 'counsel-minibuffer-history))
  :config
  (counsel-mode 1))

(use-package helpful
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))


(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))

(use-package modern-cpp-font-lock
  :ensure t)

(setq-default flycheck-disabled-checkers '(emacs-lisp-checkdoc))

(use-package evil-nerd-commenter
  :bind ("C-/" . evilnc-comment-or-uncomment-lines))

;; (use-package company-box
;;   :hook (company-mode . company-box-mode))

(use-package yasnippet
  :ensure t
  :init
  (yas-global-mode 1))

;; GGTags
(require 'ggtags)
(add-hook 'c-mode-common-hook
          (lambda ()
            (when (derived-mode-p 'c-mode 'c++-mode 'java-mode 'asm-mode)
              (ggtags-mode 1))))

(define-key ggtags-mode-map (kbd "C-c g s") 'ggtags-find-other-symbol)
(define-key ggtags-mode-map (kbd "C-c g h") 'ggtags-view-tag-history)
(define-key ggtags-mode-map (kbd "C-c g r") 'ggtags-find-reference)
(define-key ggtags-mode-map (kbd "C-c g f") 'ggtags-find-file)
(define-key ggtags-mode-map (kbd "C-c g c") 'ggtags-create-tags)
(define-key ggtags-mode-map (kbd "C-c g u") 'ggtags-update-tags)
(define-key ggtags-mode-map (kbd "M-,") 'pop-tag-mark)

(setq-local imenu-create-index-function #'ggtags-build-imenu-index)

;; Execute ggtag path
(add-to-list 'exec-path "C:\\Users\\borah\\Downloads\\glo665wb\\bin")
(setenv "PATH" (mapconcat #'identity exec-path path-separator))

;; Neo Tree for showing list of directory in emacs
(add-to-list 'load-path "~/.emacs.d/neotree")
(require 'neotree)
(defun neotree-project-dir ()
  "Open NeoTree using the git root."
  (interactive)
  (let ((project-dir (projectile-project-root))
        (file-name (buffer-file-name)))
    (neotree-toggle)
    (if project-dir
        (if (neo-global--window-exists-p)
            (progn
              (neotree-dir project-dir)
              (neotree-find file-name)))
      (message "Could not find git project root."))))
(global-set-key [f8] 'neotree-project-dir)

;; Company-mode header completion
;; TODO: needs clang & company-irony to complete true intellisense
(require 'cc-mode)

;; (require 'company)
;; (add-hook 'after-init-hook 'global-company-mode)
;; (setq company-backends (delete 'company-semantic company-backends))
;; (define-key c-mode-map  [(tab)] 'company-complete)
;; (define-key c++-mode-map  [(tab)] 'company-complete)

;; (add-to-list 'company-backends 'company-c-headers)
;; (custom-set-faces
;;  ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(mode-line ((t (:background "blue" :foreground "whitedark slate gray")))))
