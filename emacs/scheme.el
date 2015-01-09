(add-hook 'scheme-mode-hook
					(lambda ()
						(setq-default indent-tabs-mode nil)))

(put 'define* 'scheme-indent-function 1)
(put 'lambda* 'scheme-indent-function 1)
(put 'call-with-port 'scheme-indent-function 1)
