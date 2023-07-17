(provide 'find-symbol)

(defun find-symbol (glob symbol)
  "Recursively search files in GLOB for SYMBOL"
  (interactive "sGlob of files to search recursively \nsPattern to match in search ")
  (let* ((buf (get-buffer-create "search"))
	 (cmnd (format "gci -R \"%s\" | sls \"%s\"" glob symbol))
	 (sep (format "\n\n-- %s ----------------------\n" cmnd)))
    (progn (save-excursion (progn (set-buffer buf)
				  (goto-char (point-max))
				  (insert sep)))
	   (make-process :name "search"
			 :buffer buf
			 :sentinel (lambda (proc event)
				     (with-current-buffer (process-buffer proc)
				       (message (buffer-string))))
			 :command `("pwsh" "-Command" ,cmnd)))))
