(ql:quickload :qt)
(in-package :qt)
(named-readtables:in-readtable :qt)

(defclass status-bar-app () 
  ((name-edit :accessor name-edit) 
   (reverse-button :accessor reverse-button)
   (capital-button :accessor capital-button)
   (result-label :accessor result-label))
  (:metaclass qt-class)
  (:qt-superclass "QMainWindow")
  (:slots ("reverse-name()" reverse-name)
	  ("capitalize-name()" capitalize-name)))

(defmethod initialize-instance :after 
  ((instance status-bar-app) &key)
   (new instance) 
   (init-ui instance)) 

(defmethod init-ui ((instance status-bar-app)) 
  (#_setGeometry instance 400 400 300 200) 
  (#_setWindowTitle instance "Status Bar Demo")
  (#_showMessage (#_statusBar instance) "Hello")
  (setf (name-edit instance) (#_new QLineEdit "" instance) 
	(reverse-button instance) (#_new QPushButton "Reverse" instance)
	(capital-button instance) (#_new QPushButton "Capitalize" instance)
	(result-label instance) (#_new QLabel "" instance))
  (let ((box (#_new QVBoxLayout instance))
	(central-widget (#_new QWidget instance))) 
    (#_addWidget box (#_new QLabel "Type your name..." instance))
    (#_addWidget box (name-edit instance))
    (#_addWidget box (reverse-button instance))
    (#_addWidget box (capital-button instance))
    (#_addWidget box (result-label instance))
    (#_setLayout central-widget box)
    (#_setCentralWidget instance central-widget))
  (#_setMinimumWidth (result-label instance) 270)

  (#_setStatusTip (name-edit instance) "Type name here!")
  (#_setStatusTip (reverse-button instance) "Reverses your name")
  (#_setStatusTip (capital-button instance) "Capitalizes your name")

  (connect (reverse-button instance) "clicked()" instance "reverse-name()")
  (connect (capital-button instance) "clicked()" instance "capitalize-name()"))

(defmethod reverse-name ((instance status-bar-app)) 
  (let ((name (#_text (name-edit instance))))
    (#_setText (result-label instance) (if name 
				       (nreverse (princ-to-string name)) 
				       "ERROR"))))

(defmethod capitalize-name ((instance status-bar-app)) 
  (let ((name (#_text (name-edit instance))))
    (#_setText (result-label instance) (if name 
				       (string-capitalize 
					(princ-to-string name)) 
				       "ERROR"))))

(make-qapplication)
(with-main-window (window (make-instance 'status-bar-app)))