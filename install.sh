# 1. Install pip (if not installed)
# 2. Install dotfiles (py)
# 3. Get dotfiles (repo) -> ~/.dotfiles/
#    - Do backup
#    - Run dotfiles -s -f -C .dotfiles/dotfilesrc
# 4. Install scm_breeze
# 5. Create dirs ~/Apps/ and ~/Coding/

scripts=$(find install -type f -printf "%f\n" | grep -E '^[0-9]{3}.*' | sort)

for s in $scripts; do
    if [ -f install/$s -a -x install/$s ]; then
        install/$s || exit 1
    fi
done
