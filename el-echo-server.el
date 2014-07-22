;; elisp socket server

;; cl-lib - some common lisp functions
;; https://www.gnu.org/software/emacs/manual/html_node/cl/index.html#Top
;; main cl lib
(require 'pp)

(defgroup elsocket nil
  "Elliot's http server"
  :group 'comm)

(defcustom elsocket-start-hook nil
  "Hook to run when the server has started."
  :group 'elsocket
  :type 'hook)

(defcustom elsocket-stop-hook nil
  "Hook to run when the server has stopped."
  :group 'elsocket
  :type 'hook)

;;(defcustom elsocket-message nil
;;  "Message returned by server"
;;  :group 'elsocket
;;  :type string)

(defun elsocket-browse-port ()
  "open browser to listening port"
  (interactive)
  (browse-url "http://localhost:8888"))
;; (elsocket-browse-port)

(defun elsocket-stop ()
  "stop listening on socket"
  (interactive)
  (when (process-status "*elsocket-proc*")
    (delete-process "*elsocket-proc*")
    (elsocket-log `(stop ,(current-time-string)))
    (run-hooks 'elsocket-stop-hook)))

(defun elsocket-start ()
  "start listening on socket"
  (interactive)
  (elsocket-stop)
  (make-network-process
   :name "*elsocket-proc*"
   :buffer "*elsocket-proc*" ;; buffer to handle process output
   :host 'local
   :service "8888"
   :family 'ipv4
   :sentinel 'elsocket-sentinel
   :server t
   :log 'elsocket--log
   :filter 'elsocket--filter)
  (run-hooks 'elsocket-start-hook))

(defun elsocket-sentinel (proc msg)
  (elsocket-log (list 'SENTINEL (process-name proc)  msg))
  )

(defun elsocket--log (server proc message)
  "Runs each time a new client connects."
  (elsocket-log (list 'new 'connection 'from (car (process-contact proc)))))

(defun elsocket-send (proc body)
  "send soemthing"
  (process-send-string proc body))
;;  (with-temp-buffer
;;    (insert body)
;;    (process-send-region "*elsocket-proc*" (point-min) (point-max))))
;; (elsocket-send "hello, world")

;; thanks simple-httpd
(defun elsocket-log (item)
  "Pretty print a lisp object to the log."
  (with-current-buffer (get-buffer-create "*elsocket-log*")
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
  ;;  (elsocket-log (list 'MSG string)))
  (elsocket-send proc (concat "ECHOBACK:" string)) ;; echo
  (elsocket-log (concat (process-name proc) "::" string)))

;;(elsocket-stop)
(elsocket-start)

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
