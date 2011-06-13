;;; Instructions:
;;;
;;; This configuration can be used to export the babel.org document
;;; evaluating embedded code blocks and generating figures.  To use
;;; this file to export the paper
;;;
;;; 1. Install the latest version of emacs "Emacs 24" from
;;;    http://savannah.gnu.org/projects/emacs
;;;
;;; 2. From the command line, cd into this directory and then launch
;;;    Emacs using the following command
;;;      emacs -Q -l init.el babel.org
;;;
;;; 3. The resulting Emacs window should be visiting the babel.org
;;;    Org-mode file.  From here it is possible to navigate the
;;;    document within Org-mode inspecting and interactively
;;;    evaluating code examples.  Export the document to LaTeX with
;;;    the M-x org-export-as-latex command.


;;; Require ESS to allow evaluation of R code blocks
(let ((ess-path "~/.emacs.d/src/ess/lisp/")) ;; <- adjust for your system
  (add-to-list 'load-path ess-path)
  (require 'ess-site))

;;; Configure Babel to support all languages included in the manuscript
;;; Note: executables for haskell, perl, python, ruby, sh and sqlite
;;;       must be installed on your system and locatable on your
;;;       system $PATH
(org-babel-do-load-languages
 'org-babel-load-languages
 '((emacs-lisp . t)
   (haskell    . t)
   (org        . t)
   (perl       . t)
   (python     . t)
   (ruby       . t)
   (sh         . t)
   (sqlite     . t)))

(setq org-confirm-babel-evaluate nil)
