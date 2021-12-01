## emacs-config

Used packages

- use-package
- ggtags for source code navigation
- yasnippet
- flycheck (syntax checking)
- projectile for code repo management
- ivy mode and some helper functions
- neotree

For the Projectile package to work correctly, replace the projectile search directory with *your* source code directory.
```lisp
  (when (file-directory-p "C:\\Work\\Source")
    (setq projectile-project-search-path '("C:\\Work\\Source")))
  (setq projectile-switch-project-action #'projectile-dired))
```
