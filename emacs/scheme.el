(add-hook 'scheme-mode-hook
					(lambda ()
						(setq-default indent-tabs-mode nil)))

(add-to-list 'auto-mode-alist '("\\.sld\\'" . scheme-mode))

(put 'call-with-port 'scheme-indent-function 1)

(put 'define* 'scheme-indent-function 1)
(font-lock-add-keywords 'scheme-mode '(("define*" . font-lock-keyword-face)))

(put 'lambda* 'scheme-indent-function 1)
(font-lock-add-keywords 'scheme-mode '(("lambda*" . font-lock-keyword-face)))

(put 'when 'scheme-indent-function 1)
(font-lock-add-keywords 'scheme-mode '(("when" . font-lock-keyword-face)))

(put 'unless 'scheme-indent-function 1)
(font-lock-add-keywords 'scheme-mode '(("unless" . font-lock-keyword-face)))
