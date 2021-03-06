(in-package :cs325-user)

(defparameter *coins*
  (25 10 5 1))

(defun make-change (change &optional (coins '(25 10 5 1)))
  (let ((left change))
        (values-list
         (mapcar (lambda (coin)
                   (multiple-value-bind (f r) (floor left coin)
                     (setq left r) f))
                 coins))))

(defun make-change (change &optional (coins '(25 10 5 1)))
  (values-list
   (mapcar (lambda (coin)
             (multiple-value-bind (f r) (floor change coin)
               (setq change r) f))
           coins)))

;;;;;;;;;;;;;;;;;;;;;
(make-best-change 12 '(10 5))

(defun make-best-change (change &optional (coins '(25 10 5 1)))
  (values-list (caddr (dfs-best-change change coins))))

(defun dfs-best-change (change &optional (coins '(25 10 5 1)))
  (if (null coins)
      (list 0 0 nil)
    (let ((left (- change (car coins))))
      (cond
       ((= 0 left) (list 1 (car coins) (cons 1 (make-list (1- (length coins)) :initial-element 0))))
       ((> 0 left) (prep-change-0 (dfs-best-change change (cdr coins))))
       (t (let ((r-change-1 (dfs-best-change left coins))
                (r-change-2 (dfs-best-change change (cdr coins))))
            (prep-change (1+ (car r-change-1)) (+ (car coins) (cadr r-change-1)) (caddr r-change-1)
                         (car r-change-2) (cadr r-change-2) (caddr r-change-2))))))))

;;; c-1, c-2 stands for count-of-coins-1 value-of-coins-1
(defun prep-change (c-1 v-1 raw-change-1 c-2 v-2 raw-change-2) 
  (cond
   ((> v-1 v-2) (prep-change-1 c-1 v-1 raw-change-1))
   ((< v-1 v-2) (prep-change-2 c-2 v-2 raw-change-2))
   ((< c-1 c-2) (prep-change-1 c-1 v-1 raw-change-1))
   ((> c-1 c-2) (prep-change-2 c-2 v-2 raw-change-2))
   (t (prep-change-1 c-1 v-1 raw-change-1))))

(defun prep-change-0 (r-change-0)
  (list (car r-change-0) (cadr r-change-0) (cons 0 (caddr r-change-0))))

(defun prep-change-1 (c-1 v-1 raw-change-1)
  (setf (car raw-change-1) (1+ (car raw-change-1)))
  (list c-1 v-1 raw-change-1))

(defun prep-change-2 (c-2 v-2 raw-change-2)
  (list c-2 v-2 (cons 0 raw-change-2)))
;;;;;;;;;;;;;;;;;;;;;
(defun solve (f min max epsilon)
  (let ((max-ans (funcall f max))
        (min-ans (funcall f min)))
    (cond
     ((= 0 max-ans) max)
     ((= 0 min-ans) min)
     (t (b-search f min max epsilon min-ans max-ans)))))

(defun b-search (f min max epsilon min-ans max-ans)
  (if (< (abs (- max min)) epsilon)
      min
    (let* ((m (/ (+ min max) 2.0))
           (m-ans (funcall f m)))
      (cond
       ((= 0 m-ans) m)
       ((> 0 (* max-ans m-ans)) (solve f m max epsilon))
       ((> 0 (* min-ans m-ans)) (solve f min m epsilon))
       (t nil)))))
      

(defun solve (f min max epsilon)
  (if (< (abs (- max min)) epsilon)
      min
    (let* ((m (/ (+ min max) 2.0))
           (max-ans (funcall f max))
           (min-ans (funcall f min))
           (m-ans (funcall f m)))
      (evaluate f min m max max-ans min-ans m-ans epsilon))))

(defun evaluate (f min m max max-ans min-ans m-ans epsilon)
  (cond
   ((= 0 m-ans) m)
   ((= 0 max-ans) max)
   ((= 0 min-ans) min)
   ((< 0 (* max-ans min-ans)) nil)
   ((> 0 (* max-ans m-ans)) (solve f m max epsilon))
   ((> 0 (* min-ans m-ans)) (solve f min m epsilon))
   (t nil)))

; The function passed in should only need to be called at most once per element. It might be an expensive calculation.
; Simplify the helper, which is run the most, by making SOLVE smarter. It should look at the function values and always call the helper with the number that gives the negative result first. Then helper needs only a simple check to see how to do the recursive call and doesn't need so many parameters.
;;;;;;;;;;;;;;;;;;;;;
(defun horner (x &rest coeff)
  (reduce (lambda (a b) (+ (* a x) b)) coeff))

