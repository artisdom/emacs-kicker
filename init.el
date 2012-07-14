;; emacs kicker --- kick start emacs setup
;; Copyright (C) 2010 Dimitri Fontaine
;;
;; Author: Dimitri Fontaine <dim@tapoueh.org>
;; URL: https://github.com/dimitri/emacs-kicker
;; Created: 2011-04-15
;; Keywords: emacs setup el-get kick-start starter-kit
;; Licence: WTFPL, grab your copy here: http://sam.zoy.org/wtfpl/
;;
;; This file is NOT part of GNU Emacs.

(require 'cl)				; common lisp goodies, loop
(require 'eldoc)

(add-to-list 'load-path "~/.emacs.d/el-get/el-get")

(unless (require 'el-get nil t)
  (url-retrieve
   "https://github.com/dimitri/el-get/raw/master/el-get-install.el"
   (lambda (s)
     (end-of-buffer)
     (eval-print-last-sexp))))

;; now either el-get is `require'd already, or have been `load'ed by the
;; el-get installer.

;; set local recipes
(setq
 el-get-sources
 '((:name buffer-move			; have to add your own keys
	  :after (lambda ()
		   (global-set-key (kbd "<C-S-up>")     'buf-move-up)
		   (global-set-key (kbd "<C-S-down>")   'buf-move-down)
		   (global-set-key (kbd "<C-S-left>")   'buf-move-left)
		   (global-set-key (kbd "<C-S-right>")  'buf-move-right)))

   (:name smex				; a better (ido like) M-x
	  :after (lambda ()
		   (setq smex-save-file "~/.emacs.d/.smex-items")
		   (global-set-key (kbd "M-x") 'smex)
		   (global-set-key (kbd "M-X") 'smex-major-mode-commands)))

   (:name magit				; git meet emacs, and a binding
	  :after (lambda ()
		   (global-set-key (kbd "C-x C-z") 'magit-status)))

   (:name goto-last-change		; move pointer back to last change
	  :after (lambda ()
		   ;; when using AZERTY keyboard, consider C-x C-_
		   (global-set-key (kbd "C-x C-/") 'goto-last-change)))
   (:name paredit
	  :after (lambda ()
		   (eldoc-add-command
		    'paredit-backward-delete
		    'paredit-close-round)
		   (add-hook 'slime-repl-mode-hook (lambda () (paredit-mode +1)))))
   ))

;; now set our own packages
(setq
 my:el-get-packages
 '(el-get				; el-get is self-hosting
   escreen            			; screen for emacs, C-\ C-h
   php-mode-improved			; if you're into php...
   switch-window			; takes over C-x o
   auto-complete			; complete as you type with overlays
   zencoding-mode			; http://www.emacswiki.org/emacs/ZenCoding
   color-theme		                ; nice looking emacs
   color-theme-tango	                ; check out color-theme-solarized
;   color-theme-almost-monokai
;   color-theme-chocolate-rain
;   color-theme-desert
   color-theme-ir-black
;   color-theme-mac-classic
;   color-theme-railscasts
;   color-theme-sanityinc
   color-theme-solarized
;   color-theme-subdued
;   color-theme-tango-2
;   color-theme-tomorrow
;   color-theme-twilight
;   color-theme-zen-and-art
;   color-theme-zenburn
   notify
   ac-slime
   android-mode
   auctex
   auto-complete-clang
   auto-complete-emacs-lisp
   auto-complete-yasnippet
;   autopair
   blorg
;   bookmark+
   browse-kill-ring
   clang-completion-mode
   command-frequency
   diff-git
   dired+
   drag-stuff
   dtrt-indent
   edit-server
   elscreen
   emacs-w3m
   emacschrome
   emms
   epkg
   google-c-style
   grep+
   highlight-parentheses
   magithub
   mailq
   org-mode
   package
   ruby-mode
   smart-tab
;   slime
   tablature-mode
   tail
   xcscope
   xcscope+
;   cedet
   ecb
   auto-complete-ruby
   flymake-ruby
   inf-ruby
   rails-el
   rdebug
   ruby-block
   ruby-electric
   ruby-compilation
   ruby-end
))

;;
;; Some recipes require extra tools to be installed
;;
;; Note: el-get-install requires git, so we know we have at least that.
;;
;;(when (el-get-executable-find "cvs")
;;  (add-to-list 'my:el-get-packages 'emacs-goodies-el)) ; the debian addons for emacs
(add-to-list 'my:el-get-packages 'emacs-goodies-el)

(when (el-get-executable-find "svn")
  (loop for p in '(psvn    		; M-x svn-status
		   yasnippet		; powerful snippet mode
		   )
	do (add-to-list 'my:el-get-packages p)))

(setq my:el-get-packages
      (append
       my:el-get-packages
       (loop for src in el-get-sources collect (el-get-source-name src))))

;; install new packages and init already installed packages
(el-get 'sync my:el-get-packages)

;; on to the visual settings
(setq inhibit-splash-screen t)		; no splash screen, thanks
(line-number-mode 1)			; have line numbers and
(column-number-mode 1)			; column numbers in the mode line

(tool-bar-mode -1)			; no tool bar with icons
(scroll-bar-mode -1)			; no scroll bars
;(unless (string-match "apple-darwin" system-configuration)
  ;; on mac, there's always a menu bar drown, don't have it empty
;  (menu-bar-mode -1))

;; choose your own fonts, in a system dependant way
(if (string-match "apple-darwin" system-configuration)
    (set-face-font 'default "Monaco-13")
  (set-face-font 'default "Monospace-11"))

(global-hl-line-mode)			; highlight current line
(global-linum-mode 1)			; add line numbers on the left

;; avoid compiz manager rendering bugs
(add-to-list 'default-frame-alist '(alpha . 100))

;; copy/paste with C-c and C-v and C-x, check out C-RET too
(cua-mode)

;; under mac, have Command as Meta and keep Option for localized input
(when (string-match "apple-darwin" system-configuration)
  (setq mac-allow-anti-aliasing t)
  (setq mac-command-modifier 'meta)
  (setq mac-option-modifier 'none))

;; Use the clipboard, pretty please, so that copy/paste "works"
(setq x-select-enable-clipboard t)

;; Navigate windows with M-<arrows>
(windmove-default-keybindings 'meta)
(setq windmove-wrap-around t)

; winner-mode provides C-<left> to get back to previous window layout
(winner-mode 1)

;; whenever an external process changes a file underneath emacs, and there
;; was no unsaved changes in the corresponding buffer, just revert its
;; content to reflect what's on-disk.
(global-auto-revert-mode 1)

;; M-x shell is a nice shell interface to use, let's make it colorful.  If
;; you need a terminal emulator rather than just a shell, consider M-x term
;; instead.
(autoload 'ansi-color-for-comint-mode-on "ansi-color" nil t)
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)

;; If you do use M-x term, you will notice there's line mode that acts like
;; emacs buffers, and there's the default char mode that will send your
;; input char-by-char, so that curses application see each of your key
;; strokes.
;;
;; The default way to toggle between them is C-c C-j and C-c C-k, let's
;; better use just one key to do the same.
(require 'term)
(define-key term-raw-map  (kbd "C-'") 'term-line-mode)
(define-key term-mode-map (kbd "C-'") 'term-char-mode)

;; Have C-y act as usual in term-mode, to avoid C-' C-y C-'
;; Well the real default would be C-c C-j C-y C-c C-k.
(define-key term-raw-map  (kbd "C-y") 'term-paste)

;; use ido for minibuffer completion
(require 'ido)
(ido-mode t)
(setq ido-save-directory-list-file "~/.emacs.d/.ido.last")
(setq ido-enable-flex-matching t)
(setq ido-use-filename-at-point 'guess)
(setq ido-show-dot-for-dired t)

;; default key to switch buffer is C-x b, but that's not easy enough
;;
;; when you do that, to kill emacs either close its frame from the window
;; manager or do M-x kill-emacs.  Don't need a nice shortcut for a once a
;; week (or day) action.
;(global-set-key (kbd "C-x C-b") 'ido-switch-buffer)
;(global-set-key (kbd "C-x C-c") 'ido-switch-buffer)
(global-set-key (kbd "C-x B") 'ibuffer)

;; C-x C-j opens dired with the cursor right on the file you're editing
(require 'dired-x)

;; full screen
(defun fullscreen ()
  (interactive)
  (set-frame-parameter nil 'fullscreen
		       (if (frame-parameter nil 'fullscreen) nil 'fullboth)))
(global-set-key [f11] 'fullscreen)

; xcscope configuration
(setq cscope-do-not-update-database t)
(setq cscope-display-cscope-buffer nil)
(define-key global-map "\M-]s" 'cscope-find-this-symbol)
(define-key global-map "\M-]d" 'cscope-find-global-definition)

(define-key global-map "\M-]g" 'cscope-find-global-definition)
(define-key global-map "\M-]G" 'cscope-find-global-definition-no-prompting)
(define-key global-map "\M-]c" 'cscope-find-functions-calling-this-function)
(define-key global-map "\M-]C" 'cscope-find-called-functions)
(define-key global-map "\M-]t" 'cscope-find-this-text-string)
(define-key global-map "\M-]e" 'cscope-find-egrep-pattern)
(define-key global-map "\M-]f" 'cscope-find-this-file)
(define-key global-map "\M-]i" 'cscope-find-files-including-file)

(define-key global-map "\M-]b" 'cscope-display-buffer)
(define-key global-map "\M-]B" 'cscope-display-buffer-toggle)
(define-key global-map "\M-]n" 'cscope-next-symbol)
(define-key global-map "\M-]N" 'cscope-next-file)
(define-key global-map "\M-]p" 'cscope-prev-symbol)
(define-key global-map "\M-]P" 'cscope-prev-file)
(define-key global-map "\M-]u" 'cscope-pop-mark)

(define-key global-map "\M-]a" 'cscope-set-initial-directory)
(define-key global-map "\M-]A" 'cscope-unset-initial-directory)

(define-key global-map "\M-]L" 'cscope-create-list-of-files-to-index)
(define-key global-map "\M-]I" 'cscope-index-files)
(define-key global-map "\M-]E" 'cscope-edit-list-of-files-to-index)
(define-key global-map "\M-]W" 'cscope-tell-user-about-directory)
(define-key global-map "\M-]S" 'cscope-tell-user-about-directory)
(define-key global-map "\M-]T" 'cscope-tell-user-about-directory)
(define-key global-map "\M-]D" 'cscope-dired-directory)

(define-key global-map [(control f9)]  'cscope-display-buffer)
(define-key global-map [(control f10)] 'cscope-display-buffer-toggle)
(define-key global-map [(control f11)]  'cscope-prev-symbol)
(define-key global-map [(control f12)] 'cscope-next-symbol)
(define-key global-map [(control .)]
  'cscope-find-global-definition-no-prompting)
(define-key global-map [(control ,)]  'cscope-pop-mark)
(define-key global-map "\M-." 'cscope-find-functions-calling-this-function)

; Chrome extension - 'Edit with Emacs'
(require 'edit-server)
(edit-server-start)

(dtrt-indent-mode 1)

;; w3m
(require 'w3m-load)
(require 'mime-w3m)
(setq w3m-home-page "http://www.google.com")
(setq w3m-default-display-inline-images t)

;; org mode
;; The following lines are always needed. Choose your own keys.
(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))
(add-hook 'org-mode-hook 'turn-on-font-lock) ; not needed when global-font-lock-mode is on
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)

;; scroll one line at a time (less "jumpy" than defaults)
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) ;; one line at a time
(setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling
(setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse
(setq scroll-step 1) ;; keyboard scroll one line at a time

(server-start)

(require 'color-theme-ir-black)
(eval-after-load "color-theme"
  '(progn
     (color-theme-initialize)
     (color-theme-ir-black)))
;color-theme-tango

(require 'yasnippet) ;; not yasnippet-bundle
(yas/initialize)
(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(cua-mode t nil (cua-base))
 '(ecb-layout-window-sizes (quote (("left8" (ecb-directories-buffer-name 0.15476190476190477 . 0.2857142857142857) (ecb-sources-buffer-name 0.15476190476190477 . 0.23809523809523808) (ecb-methods-buffer-name 0.15476190476190477 . 0.2857142857142857) (ecb-history-buffer-name 0.15476190476190477 . 0.16666666666666666)))))
 '(ecb-methods-menu-sorter (quote identity))
 '(ecb-options-version "2.40")
 '(ecb-show-tags (quote ((default (include collapsed nil) (parent collapsed nil) (type flattened nil) (variable collapsed access) (function flattened nil) (label hidden nil) (t collapsed nil)) (c++-mode (include collapsed nil) (parent collapsed nil) (type flattened nil) (variable collapsed access) (function flattened access) (function collapsed access) (label hidden nil) (t collapsed nil)) (c-mode (include collapsed nil) (parent collapsed nil) (type flattened nil) (variable collapsed nil) (function flattened nil) (function flattened nil) (label hidden nil) (t collapsed nil)) (bovine-grammar-mode (keyword collapsed name) (token collapsed name) (nonterminal flattened name) (rule flattened name) (t collapsed nil)) (wisent-grammar-mode (keyword collapsed name) (token collapsed name) (nonterminal flattened name) (rule flattened name) (t collapsed nil)) (texinfo-mode (section flattened nil) (def collapsed name) (t collapsed nil)))))
 '(ecb-tip-of-the-day nil)
 '(tool-bar-mode nil))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "#000000" :foreground "#F6F3E8" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 113 :width normal :foundry "unknown" :family "Droid Sans Mono")))))

;; Coding Style
(setq c-default-style "linux"
      c-basic-offset 8)

(load (expand-file-name "~/quicklisp/slime-helper.el"))
;; Replace "sbcl" with the path to your implementation
(setq inferior-lisp-program "sbcl")

;(load (expand-file-name "~/source/lisp/quicklisp/slime-helper.el"))
;; Replace "sbcl" with the path to your implementation
;(setq inferior-lisp-program "clisp")

(add-hook 'emacs-lisp-mode-hook 'turn-on-eldoc-mode)
(add-hook 'lisp-interaction-mode-hook 'turn-on-eldoc-mode)
(add-hook 'ielm-mode-hook 'turn-on-eldoc-mode)

(setq browse-url-browser-function 'browse-url-generic browse-url-generic-program "chromium-browser")
;(setq browse-url-browser-function 'w3m-browse-url)

(require 'session)
(add-hook 'after-init-hook 'session-initialize)
(load "desktop")
(desktop-load-default)
(desktop-read)
