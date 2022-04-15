;;; package --- Sumary
;;; Commentary:

(require 'ox)
(require 'org)

;;; Code:

(defun org-resume-export-as-html (&optional async subtreep visible-only)
  "Export Doc thing"
  (interactive)
  (org-export-to-buffer 'resume "*Org HTML Export*"
    async subtreep visible-only nil nil (lambda () (text-mode))))

(defun org-resume-template (contents info)
	contents)

(defun org-resume-section (section contents info)
	"Hello there friend. SECTION CONTENTS INFO Some docs here."
	;; (format "<section>\n\n\n%s\n\n\n\n</section>\n" contents)
	contents
)
;; (defun org-resume-section (section contents info)
;;   "Transcode SECTION element into Markdown format.
;; CONTENTS is the section contents.  INFO is a plist used as
;; a communication channel."
;; 	(let ((parent (org-export-get-parent-headline section)))
;;     ;; Before first headline: no container, just return CONTENTS.
;;     (if (not parent) contents
;;       ;; Get div's class and id references.
;;       (let* ((class-num (+ (org-export-get-relative-level parent info)
;; 													 (1- (plist-get info :html-toplevel-hlevel))))
;; 						 (section-number
;; 							(and (org-export-numbered-headline-p parent info)
;; 									 (mapconcat
;; 										#'number-to-string
;; 										(org-export-get-headline-number parent info) "-"))))
;;         ;; Build return value.
;; 				(format "<div class=\"outline-text-%d\" id=\"text-%s\">\n%s</div>\n"
;; 								class-num
;; 								(or (org-element-property :CUSTOM_ID parent)
;; 										section-number
;; 										(org-export-get-reference parent info))
;; 								(or contents ""))))))

(defun org-resume-headline-base (headline contents info)
	"Base thing o yeah HEADLINE CONTENTS INFO."
	(let* ((level (+ (org-export-get-relative-level headline info)
                   (1- (plist-get info :html-toplevel-hlevel))))
				 (text (org-export-data (org-element-property :title headline) info))
				 (resume-headline-type (org-element-property :SECTION-TYPE headline)))
		(cond ((string= resume-headline-type "resume") (org-resume-headline-resume headline contents info))
					((string= resume-headline-type "work") (org-resume-headline-work headline contents info))
					((string= resume-headline-type "skills") "")
					((string= resume-headline-type "projects") "")
					((string= resume-headline-type "education") "")
					(t "default"))))

(defun org-resume-headline-resume (headline contents info)
	(let* ((level (+ (org-export-get-relative-level headline info)
                   (1- (plist-get info :html-toplevel-hlevel))))
				 (location (if (org-element-property :LOCATION headline)
											 (format "<p>%s</p>" (org-element-property :LOCATION headline)) ""))
				 (phone (if (org-element-property :PHONE headline)
										(format "<li>%s</li>\n" (org-element-property :PHONE headline)) ""))
				 (email (if (org-element-property :EMAIL headline)
										(format "<li>%s</li>\n" (org-element-property :EMAIL headline)) ""))
				 (github (if (org-element-property :GITHUB headline)
										 (format "<li>%s</li>\n" (org-element-property :GITHUB headline)) ""))
				 (text (org-export-data (org-element-property :title headline) info)))
		(format "<section>%s</section>\n"
						(format "<h1>%s</h1>\n%s\n<ul>\n%s%s%s</ul>\n%s\n"
                    text
										location
										phone
										email
										github
										contents))))

(defun org-resume-headline-default (headline contents info)
	(let* (parent (org-export-get-parent headline))
		(parent-headline-type (org-element-property :SECTION-TYPE parent)))
		(location (if (org-element-property :LOCATION headline)
									(format "<p>%s</p>" (org-element-property :LOCATION headline)) ""))
		(phone (if (org-element-property :PHONE headline)
							 (format "<li>%s</li>\n" (org-element-property :PHONE headline)) ""))
		(email (if (org-element-property :EMAIL headline)
							 (format "<li>%s</li>\n" (org-element-property :EMAIL headline)) ""))
		(github (if (org-element-property :GITHUB headline)
								(format "<li>%s</li>\n" (org-element-property :GITHUB headline)) ""))
		(text (org-export-data (org-element-property :title headline) info))

		)

(defun org-resume-headline-work (headline contents info)
	(let* ((level (+ (org-export-get-relative-level headline info)
                   (1- (plist-get info :html-toplevel-hlevel))))
				 (text (org-export-data (org-element-property :title headline) info))
				 (resume-headline-type (org-element-property :SECTION-TYPE headline)))
		(format "<section><h2>%s</h2>\n%s\n</section>" text contents))
	)

(defun org-resume-headline-skills (headline contents info)
	(let* ((level (+ (org-export-get-relative-level headline info)
                   (1- (plist-get info :html-toplevel-hlevel))))
				 (text (org-export-data (org-element-property :title headline) info))
				 (resume-headline-type (org-element-property :SECTION-TYPE headline)))
		contents)
  )

(defun org-resume-headline-projects (headline contents info)
	(let* ((level (+ (org-export-get-relative-level headline info)
                   (1- (plist-get info :html-toplevel-hlevel))))
				 (text (org-export-data (org-element-property :title headline) info))
				 (resume-headline-type (org-element-property :SECTION-TYPE headline)))
		contents)
  )

(defun org-resume-headline-education (headline contents info)
	(let* ((level (+ (org-export-get-relative-level headline info)
                   (1- (plist-get info :html-toplevel-hlevel))))
				 (text (org-export-data (org-element-property :title headline) info)))
		(format "<section> <h2>%s</h2>\n%s</section>" text contents)))

(defun org-resume-headline-sub-education (headline contents info)
	(let* ((level (+ (org-export-get-relative-level headline info)
                   (1- (plist-get info :html-toplevel-hlevel))))
				 (dates (if (org-element-property :DATES headline)
									  (org-element-property :DATES headline) ""))
				 (major (if (org-element-property :MAJOR headline)
									  (org-element-property :MAJOR headline) ""))
				 (location (if (org-element-property :LOCATION headline)
											 (org-element-property :LOCATION headline) ""))
				 (text (org-export-data (org-element-property :title headline) info)))
		(format "<section> <h3>%s</h3>\n<p>%s</p>\n<p>%s</p>\n<p>%s</p>\n%s\n</section>"
						text location major dates contents)))

(defun org-resume-headline (headline contents info)
  "Transcode a HEADLINE element from Org to HTML.
CONTENTS holds the contents of the headline.  INFO is a plist
holding contextual information."
  (let* ((numbers (org-export-get-headline-number headline info))
         (level (+ (org-export-get-relative-level headline info)
                   (1- (plist-get info :html-toplevel-hlevel))))
         (todo (and (plist-get info :with-todo-keywords)
                    (let ((todo (org-element-property :todo-keyword headline)))
                      (and todo (org-export-data todo info)))))
         (todo-type (and todo (org-element-property :todo-type headline)))
         (priority (and (plist-get info :with-priority)
                        (org-element-property :priority headline)))
         (text (org-export-data (org-element-property :title headline) info))
         (tags (and (plist-get info :with-tags)
                    (org-export-get-tags headline info)))
         (full-text (funcall (plist-get info :html-format-headline-function)
                             todo todo-type priority text tags info))
				 ;; (start (or (or (org-element-property :START headline) nil) (format "")))
				 (timeframe (if (org-element-property :START headline) (format "<p>%s - %s</p>" (org-element-property :START headline) (org-element-property :TRATS headline)) ""))
				 ;; (end (org-element-property :TRATS headline))
				 ;; (role (org-element-property :ROLE headline))
				 (role (if (org-element-property :ROLE headline) (format "<p>%s</p>" (org-element-property :ROLE headline)) ""))
				 ;; (location (org-element-property :LOCATION headline))
				 (location (if (org-element-property :LOCATION headline) (format "<p>%s</p>\n" (org-element-property :LOCATION headline)) ""))
				 (extra-goodies (format "%s%s%s" location role timeframe))
         (contents (or contents ""))
				 (id (org-html--reference headline info))
				 (ul-open (if (= level 4) "  <ul>" ""))
				 (ul-close (if (= level 4) "  </ul>" "")))
		;; Standard headline.  Export it as a section.
    (if (= level 5) (format "    <li>%s</li>" text)
			(format "<section>%s</section>\n"
            (format "\n<h%d>%s</h%d>\n%s\n%s\n%s\n%s\n"
                    level
                    text
                    level
										extra-goodies
										ul-open
										contents
										ul-close)))
		))

;; (defun org-resume-headline (headline contents info)
;;   "Transcode a HEADLINE element from Org to HTML.
;; CONTENTS holds the contents of the headline.  INFO is a plist
;; holding contextual information."
;;   (unless (org-element-property :footnote-section-p headline)
;;     (let* ((numberedp (org-export-numbered-headline-p headline info))
;;            (numbers (org-export-get-headline-number headline info))
;;            (level (+ (org-export-get-relative-level headline info)
;;                      (1- (plist-get info :html-toplevel-hlevel))))
;;            (todo (and (plist-get info :with-todo-keywords)
;;                       (let ((todo (org-element-property :todo-keyword headline)))
;;                         (and todo (org-export-data todo info)))))
;;            (todo-type (and todo (org-element-property :todo-type headline)))
;;            (priority (and (plist-get info :with-priority)
;;                           (org-element-property :priority headline)))
;;            (text (org-export-data (org-element-property :title headline) info))
;;            (tags (and (plist-get info :with-tags)
;;                       (org-export-get-tags headline info)))
;;            (full-text (funcall (plist-get info :html-format-headline-function)
;;                                todo todo-type priority text tags info))
;;            (contents (or contents ""))
;; 					 (id (org-html--reference headline info))
;; 					 (formatted-text
;; 						(if (plist-get info :html-self-link-headlines)
;; 								(format "<a href=\"#%s\">%s</a>" id full-text)
;; 							full-text)))
;;       (if (org-export-low-level-p headline info)
;;           ;; This is a deep sub-tree: export it as a list item.
;;           (let* ((html-type (if numberedp "ol" "ul")))
;; 						(concat
;; 						 (and (org-export-first-sibling-p headline info)
;; 									(apply #'format "<%s class=\"org-%s\">\n"
;; 												 (make-list 2 html-type)))
;; 						 (org-html-format-list-item
;; 							contents (if numberedp 'ordered 'unordered)
;; 							nil info nil
;; 							(concat (org-html--anchor id nil nil info) formatted-text)) "\n"
;; 						 (and (org-export-last-sibling-p headline info)
;; 									(format "</%s>\n" html-type))))
;; 				;; Standard headline.  Export it as a section.
;;         (let ((extra-class
;; 							 (org-element-property :HTML_CONTAINER_CLASS headline))
;; 							(headline-class
;; 							 (org-element-property :HTML_HEADLINE_CLASS headline))
;;               (first-content (car (org-element-contents headline))))
;;           (format "<%s id=\"%s\" class=\"%s\">%s%s</%s>\n"
;;                   (org-html--container headline info)
;;                   (format "outline-container-%s" id)
;;                   (concat (format "outline-%d" level)
;;                           (and extra-class " ")
;;                           extra-class)
;;                   (format "\n<h%d id=\"%s\"%s>%s</h%d>\n"
;;                           level
;;                           id
;; 													(if (not headline-class) ""
;; 														(format " class=\"%s\"" headline-class))
;;                           (concat
;;                            (and numberedp
;;                                 (format
;;                                  "<span class=\"section-number-%d\">%s</span> "
;;                                  level
;;                                  (concat (mapconcat #'number-to-string numbers ".") ".")))
;;                            formatted-text)
;;                           level)
;;                   ;; When there is no section, pretend there is an
;;                   ;; empty one to get the correct <div
;;                   ;; class="outline-...> which is needed by
;;                   ;; `org-info.js'.
;;                   (if (eq (org-element-type first-content) 'section) contents
;;                     (concat (org-html-section first-content "" info) contents))
;;                   (org-html--container headline info)))))))

(org-export-define-derived-backend 'resume 'html
	:translate-alist '((template . org-resume-template)
										 (section . org-resume-section)
										 (headline . org-resume-headline-base))
	:menu-entry
  '(?r "Resume Export to HTML"
       ((?M "To temporary buffer"
						(lambda (a s v b) (org-resume-export-as-html a s v)))
				(?m "To file" (lambda (a s v b) (org-md-export-to-markdown a s v)))
				(?o "To file and open"
						(lambda (a s v b)
							(if a (org-md-export-to-markdown t s v)
								(org-open-file (org-md-export-to-markdown nil s v))))))))

;;; resume.el ends here
