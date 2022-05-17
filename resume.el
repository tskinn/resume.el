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
	(format outer-template contents))

(defun org-resume-headline-base (headline contents info)
	"Base thing o yeah HEADLINE CONTENTS INFO."
	(let* ((todo (and (plist-get info :with-todo-keywords)
										(let ((todo (org-element-property :todo-keyword headline)))
											(and todo (org-export-data todo info)))))
				 (todo-type (and todo (org-element-property :todo-type headline)))
				 (level (+ (org-export-get-relative-level headline info)
                   (1- (plist-get info :html-toplevel-hlevel))))
				 (text (org-export-data (org-element-property :title headline) info))
				 (resume-headline-type (org-element-property :SECTION-TYPE headline)))
		(cond (todo "") ; skip if todo
					((string= resume-headline-type "resume") (org-resume-headline-resume headline contents info))
					((string= resume-headline-type "work") (org-resume-headline-work headline contents info))
					((string= resume-headline-type "skills") (org-resume-headline-skills headline contents info))
					((string= resume-headline-type "projects") (org-resume-headline-projects headline contents info))
					((string= resume-headline-type "education") (org-resume-headline-education headline contents info))
					(t (org-resume-headline-default headline contents info)))))

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

(defun get-ancestor-headline-type (headline)
	(let* ((parent (org-export-get-parent headline))
				 (parent-type (org-element-property :SECTION-TYPE parent)))
		(while (not parent-type)
			(setq parent (org-export-get-parent parent))
			(setq parent-type (org-element-property :SECTION-TYPE parent)))
		parent-type))

(defun org-resume-headline-default (headline contents info)
	(let* ((parent (org-export-get-parent headline))
				 (parent-headline-type (org-element-property :SECTION-TYPE parent))
				 (ancestor-type (get-ancestor-headline-type headline))
				 (github (if (org-element-property :GITHUB headline)
										 (format "<li>%s</li>\n" (org-element-property :GITHUB headline)) ""))
				 (text (org-export-data (org-element-property :title headline) info)))
		(cond ((string= ancestor-type "resume") "RESSUME")
					((string= ancestor-type "work") (org-resume-headline-sub-work headline contents info))
					((string= ancestor-type "skills") (org-resume-headline-sub-skills headline contents info))
					((string= ancestor-type "projects") (org-resume-headline-sub-projects headline contents info))
					((string= ancestor-type "education") (org-resume-headline-sub-education headline contents info))
					(t "default"))))

(defun org-resume-headline-work (headline contents info)
	(let* ((level (+ (org-export-get-relative-level headline info)
                   (1- (plist-get info :html-toplevel-hlevel))))
				 (text (org-export-data (org-element-property :title headline) info))
				 (resume-headline-type (org-element-property :SECTION-TYPE headline)))
		(format "<section><h2>%s</h2>\n%s\n</section>" text contents)))

(defun org-resume-headline-sub-work (headline contents info)
	(let* ((level (+ (org-export-get-relative-level headline info)
                   (1- (plist-get info :html-toplevel-hlevel))))
				 (dates (if (org-element-property :DATES headline)
									  (org-element-property :DATES headline) ""))
				 (location (if (org-element-property :LOCATION headline)
											 (org-element-property :LOCATION headline) ""))
				 (dates (if (org-element-property :DATES headline)
										(org-element-property :DATES headline) ""))
				 (role (if (org-element-property :ROLE headline)
											 (org-element-property :ROLE headline) ""))
				 (text (org-export-data (org-element-property :title headline) info)))
		(cond ((= level 4) (format "<section> <h3>%s</h3>\n<p><b>%s</b></p>\n<p><i>%s</i></p>\n<p><i>%s</i></p>\n<ul>\n%s</ul>\n</section>"
										 text location role dates contents))
					((> level 4) (format "<li>%s</li>\n" text))
					(t ""))))

(defun org-resume-headline-skills (headline contents info)
	(let* ((level (+ (org-export-get-relative-level headline info)
                   (1- (plist-get info :html-toplevel-hlevel))))
				 (text (org-export-data (org-element-property :title headline) info))
				 (resume-headline-type (org-element-property :SECTION-TYPE headline)))
		(format "<section><h2>%s</h2>\n<ul>\n%s\n</ul>\n</section>" text contents)))

(defun org-resume-headline-sub-skills (headline contents info)
	(let* ((level (+ (org-export-get-relative-level headline info)
                   (1- (plist-get info :html-toplevel-hlevel))))
				 (text (org-export-data (org-element-property :title headline) info)))
		(cond ((= level 4) (format "<li><b>%s:</b> %s </li>\n"
															 text contents))
					((> level 4) text)
					(t ""))))

(defun org-resume-headline-projects (headline contents info)
	(let* ((level (+ (org-export-get-relative-level headline info)
                   (1- (plist-get info :html-toplevel-hlevel))))
				 (text (org-export-data (org-element-property :title headline) info)))
		(format "<section><h2>%s</h2>\n<ul>\n%s\n</ul>\n</section>" text contents)))

(defun org-resume-headline-sub-projects (headline contents info)
	(let* ((level (+ (org-export-get-relative-level headline info)
                   (1- (plist-get info :html-toplevel-hlevel))))
				 (text (org-export-data (org-element-property :title headline) info)))
		(cond ((= level 4) (format "<li><b>%s:</b>%s</li>\n" text contents))
					((> level 4) (format "%s" text))
					(t ""))))

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
		(cond ((= level 4) (format "<section> <h3>%s</h3>\n<p>%s</p>\n<p>%s</p>\n<p>%s</p>\n%s\n</section>"
															 text location major dates contents))
					((= level 5) (format "<section> <h4>%s</h4>\n<ul>\n%s\n</ul>\n</section>" text contents))
					((> level 5) (format "<li>%s</li>" text))
					(t ""))))

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

(setq outer-template "<html>\
	<head>\
		<link rel=\"preconnect\" href=\"https://fonts.gstatic.com\">\
		<link href=\"https://fonts.googleapis.com/css2?family=Open+Sans:wght@700&display=swap\" rel=\"stylesheet\">\
		<link rel=\"stylesheet\" href=\"https://cdnjs.cloudflare.com/ajax/libs/normalize/7.0.0/normalize.min.css\">\
    <link rel=\"preconnect\" href=\"https://fonts.googleapis.com\">\
    <link rel=\"preconnect\" href=\"https://fonts.gstatic.com\" crossorigin>\
    <link href=\"https://fonts.googleapis.com/css2?family=Playfair+Display&family=Roboto+Slab:wght@200&display=swap\" rel=\"stylesheet\">\
    <script src=\"https://raw.githubusercontent.com/tskinn/resume.el/main/script.js\"></script>\
    <link href=\"https://github.com/tskinn/resume.el/blame/main/style.css\" rel=\"stylesheet\">\
	</head>\
  <body>\
  <div>\
	%s\
  </div>\
  </body>\
</html>")

;;; resume.el ends here
