;; connect to socket
;; send contents of the current buffer

(require 'pp)

(defun el-connect ()
  "send content of current buffer to socket"
  (interactive)
  (make-network-process
   :name "*elsocket-proc*"
   :buffer "*elsocket-buff*" ;; buffer to handle process output
   :host 'local
   :service "8889"
   :family 'ipv4
   :sentinel 'elsocket-sentinel
   :log 'elsocket--log
   :filter 'elsocket--filter)
  )

(defun el-send (proc body)
  "send soemthing"
  (process-send-string proc body))

(defun el-serve-buffer ()
  "connect to serve and send contents of this buffer"
  (interactive)
  (el-connect)
  (el-send "*elsocket-proc*" (buffer-string))
  )
;; (serve-buffer)

(defun elsocket-sentinel (proc msg)
  (el-log (list 'SENTINEL (process-name proc)  msg))
  )

(defun elsocket--log (server proc message)
  "Runs each time a new client connects."
  (el-log (list 'new 'connection 'from (car (process-contact proc)))))

(defun elsocket-send (proc body)
  "send soemthing"
  (process-send-string proc body))
;;  (with-temp-buffer
;;    (insert body)
;;    (process-send-region "*elsocket-proc*" (point-min) (point-max))))
;; (elsocket-send "*elsocket-proc*" "hello, world")

;; thanks simple-httpd
(defun el-log (item)
  "Pretty print a lisp object to the log."
  (with-current-buffer (get-buffer-create "*el-log*")
    (setf buffer-read-only nil)
    (let ((follow (= (point) (point-max))))
      (save-excursion
        (goto-char (point-max))
        (pp item (current-buffer)))
      (if follow (goto-char (point-max))))
    (setf truncate-lines t
          buffer-read-only t)
    (set-buffer-modified-p nil)))

;; Networking code
(defun elsocket--filter (proc string)
  "Runs each time client makes a request."
  (setf string (concat (process-get proc :previous-string) string))
  ;;  (el-log (list 'MSG string)))
  ;;(elsocket-send proc (concat "ECHOBACK:" string)) ;; echo
  (el-log (concat (process-name proc) "::" string)))

;;(elsocket-stop)
;;(elsocket-start)

;; (list-processes)
;; (process-send-string "*elsocket-proc*" "hello world")
;; (process-send-string "*elsocket-proc* <127.0.0.1:61513>" "HHHIII")
;; (process-type "*elsocket-proc*")
;; (delete-process "*elsocket-proc*")
;; (process-status "*elsocket-proc*")
;; (stop-process "*elsocket-proc*")
;;;; (process-contact "*elsocket-proc*")
;; (process-plist "*elsocket-proc*")
;; (process-get "*elsocket-proc*")
