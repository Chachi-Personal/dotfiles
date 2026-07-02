function takeurl 
    set --local data "$(mktemp)" 
    curl -L "$1" > "$data"
    tar xf "$data"
    set --local thedir "$(tar tf "$data" | head -n 1)" 
    rm "$data"
    cd "$thedir"
end

function takegit 
    git clone "$1"
    cd substr "$1" 1 -4
end

function takedir
    mkdir -p $argv && cd $argv
end

function take
	if string match -r '^(https?|ftp).*\.(tar\.(gz|bz2|xz)|tgz)' $1
        takeurl $1
    else if string match -r '^([A-Za-z0-9]\+@|https?|git|ssh|ftps?|rsync).*\.git/?$' $1
        takegit $1
	else
        takedir $argv
	end
end
