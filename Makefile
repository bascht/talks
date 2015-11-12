all: index
index:
	emacs --batch -l ~//.emacs.d/init.el --visit=README.org --funcall org-html-export-to-html
	mv README.html index.html
